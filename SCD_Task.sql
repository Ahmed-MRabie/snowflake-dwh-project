USE DATABASE SALES_DWH;
USE SCHEMA sales;

-- ======================================================================
-- Add start_date, end_date, is_current To DIMs
-- To Product Dim
ALTER TABLE dim_product
ADD COLUMN start_date DATE;

ALTER TABLE dim_product
ADD COLUMN end_date DATE;

ALTER TABLE dim_product
ADD COLUMN is_current BOOLEAN DEFAULT TRUE;

-- TO Customer Dim
ALTER TABLE dim_customer
ADD COLUMN start_date DATE;

ALTER TABLE dim_customer
ADD COLUMN end_date DATE;

ALTER TABLE dim_customer
ADD COLUMN is_current BOOLEAN DEFAULT TRUE;

-- To Category Dim
ALTER TABLE dim_category
ADD COLUMN start_date DATE;

ALTER TABLE dim_category
ADD COLUMN end_date DATE;

ALTER TABLE dim_category
ADD COLUMN is_current BOOLEAN DEFAULT TRUE;

-- ======================================================================
-- Upadate start_date in DIMs 
UPDATE dim_product
SET start_date = CURRENT_DATE;

UPDATE dim_category
SET start_date = CURRENT_DATE;

UPDATE dim_customer
SET start_date = CURRENT_DATE;


-- ======================================================================
-- Create a stream
CREATE OR REPLACE STREAM stream_dim_product
ON TABLE dim_product
APPEND_ONLY = FALSE;

CREATE OR REPLACE STREAM stream_dim_category
ON TABLE dim_category
APPEND_ONLY = FALSE;

CREATE OR REPLACE STREAM stream_dim_customer
ON TABLE dim_customer
APPEND_ONLY = FALSE;

-- ======================================================================
-- Build Task SCD Type 2
-- Task For Product DIM
CREATE OR REPLACE TASK scd2_product_task
WAREHOUSE = SALES_DWH
SCHEDULE = 'USING CRON * * * * * UTC'
WHEN
    SYSTEM$STREAM_HAS_DATA('stream_dim_product')
AS
BEGIN
    -- Step 1: Update old versions
    UPDATE dim_product dp
    SET end_date = CURRENT_DATE,
        is_current = FALSE
    FROM (
        SELECT *
        FROM stream_dim_product
        WHERE METADATA$ACTION = 'INSERT'
    ) sp
    WHERE dp.product_sk = sp.product_sk 
      AND dp.product_id = sp.product_id
      AND dp.is_current = TRUE
      AND (
          dp.product_name != sp.product_name
       OR dp.brand != sp.brand
       OR dp.price != sp.price
       OR dp.category_id != sp.category_id
      );
    -- Step 2: Insert new version
    INSERT INTO dim_product (product_id, category_id, product_name, brand, price, start_date, end_date, is_current)
    SELECT product_id, category_id, product_name, brand, price,
         CURRENT_DATE, NULL, TRUE
    FROM stream_dim_product sp
    WHERE METADATA$ACTION = 'INSERT';
END;
-- --------------------------------------------
-- Task For Customer DIM
CREATE OR REPLACE TASK scd2_customer_task
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON * * * * * UTC'
WHEN SYSTEM$STREAM_HAS_DATA('stream_dim_customer')
AS
BEGIN
    -- Step 1: Close old records
    UPDATE dim_customer dc
    SET end_date = CURRENT_DATE,
        is_current = FALSE
    FROM (
        SELECT *
        FROM stream_dim_customer
        WHERE METADATA$ACTION = 'INSERT'
    ) sc
    WHERE dc.customer_id = sc.customer_id
      AND dc.is_current = TRUE
      AND (
          dc.first_name != sc.first_name
       OR dc.last_name != sc.last_name
       OR dc.email != sc.email
       OR dc.gender != sc.gender
       OR dc.age != sc.age
       OR dc.city != sc.city
       OR dc.state != sc.state
      );
    -- Step 2: Insert new version
    INSERT INTO dim_customer (customer_id, first_name, last_name, email, gender, age, city, state, start_date, end_date, is_current)
    SELECT customer_id, first_name, last_name, email, gender,
           age, city, state, CURRENT_DATE, NULL, TRUE
    FROM stream_dim_customer sc
    WHERE METADATA$ACTION = 'INSERT';
END;

-- ======================================================================
-- Enable Tasks
ALTER TASK scd2_product_task RESUME;
ALTER TASK scd2_customer_task RESUME;
ALTER WAREHOUSE COMPUTE_WH SET AUTO_RESUME = TRUE;

-- ======================================================================
-- Ex
UPDATE dim_customer
SET email = 'sara4333@gmail.com'
WHERE customer_id = 1 AND is_current = TRUE;

SELECT *
FROM dim_customer
WHERE customer_id = 1;



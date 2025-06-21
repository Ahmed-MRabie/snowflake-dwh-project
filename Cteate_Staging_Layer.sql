USE DATABASE SALES_DWH;
USE SCHEMA sales;
-- ======================================================================
-- Creat Stage Layer
CREATE OR REPLACE STAGE sales_stage

LIST @sales_stage;

-- ======================================================================
-- Create Staging Tables
CREATE OR REPLACE TABLE stg_products_customers (
    customer_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    age INT,
    city STRING,
    state STRING,
    product_id INT,
    product_name STRING,
    brand STRING,
    category STRING,
    price FLOAT
);

CREATE OR REPLACE TABLE stg_sales (
    sale_id STRING,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    quantity INT,
    total_amount FLOAT,
    payment_method STRING
);
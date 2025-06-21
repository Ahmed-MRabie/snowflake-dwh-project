-- Transfer data FROM CSV files To Staging Tables --
COPY INTO stg_products_customers
FROM @sales_stage/products_customers.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);


COPY INTO stg_sales
FROM @sales_stage/sales.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT COUNT(*) FROM stg_products_customers;
SELECT COUNT(*) FROM stg_sales;
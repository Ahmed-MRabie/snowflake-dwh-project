-- Create Customer dimantion Table
CREATE OR REPLACE TABLE dim_customer (
    customer_sk INT AUTOINCREMENT PRIMARY KEY,
    customer_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    gender STRING,
    age INT,
    city STRING,
    state STRING
);

-- Create Category dimantion Table
CREATE OR REPLACE TABLE dim_category (
    category_id INT AUTOINCREMENT PRIMARY KEY,
    category_name STRING
);

-- Create Product dimantion Table
CREATE OR REPLACE TABLE dim_product (
    product_sk INT AUTOINCREMENT PRIMARY KEY,
    product_id INT,
    category_id INT,
    product_name STRING,
    brand STRING,
    price FLOAT,

    FOREIGN KEY (category_id) REFERENCES dim_category(category_id)
);

-- Create Date dimantion Table
CREATE OR REPLACE TABLE dim_date (
    date_sk INT AUTOINCREMENT PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    day INT
);

-- Create Fact Table
CREATE OR REPLACE TABLE fact_sales (
    sales_sk INT AUTOINCREMENT PRIMARY KEY,  -- Surrogate Key
    sale_id STRING,
    customer_sk INT,
    product_sk INT,
    date_sk INT,
    quantity INT,
    total_amount FLOAT,
    payment_method STRING,

    FOREIGN KEY (customer_sk) REFERENCES dim_customer(customer_sk),
    FOREIGN KEY (product_sk) REFERENCES dim_product(product_sk),
    FOREIGN KEY (date_sk) REFERENCES dim_date(date_sk)
);

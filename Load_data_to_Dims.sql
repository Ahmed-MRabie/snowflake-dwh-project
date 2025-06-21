-- Transfare data FROM Staging Table To Dimantion Tables --
INSERT INTO dim_category (category_name)
SELECT DISTINCT category
FROM stg_products_customers;


INSERT INTO dim_product (product_id, category_id, product_name, brand, price)
SELECT p.product_id,
       c.category_id,
       p.product_name,
       p.brand,
       p.price
FROM ( SELECT DISTINCT product_id, category, product_name, brand, price
       FROM stg_products_customers ) p
JOIN dim_category c
ON p.category = c.category_name;


INSERT INTO dim_customer (customer_id, first_name, last_name, email, gender, age, city, state)
SELECT DISTINCT customer_id, first_name, last_name, email, gender, age, city, state
FROM stg_products_customers;


INSERT INTO dim_date (full_date, year, month, day)
SELECT DISTINCT sale_date, YEAR(sale_date), MONTH(sale_date), DAY(sale_date)
FROM stg_sales;


INSERT INTO fact_sales (
    sale_id, customer_sk, product_sk, date_sk,
    quantity, total_amount, payment_method
)
SELECT s.sale_id,
       c.customer_sk,
       p.product_sk,
       d.date_sk,
       s.quantity,
       s.total_amount,
      s.payment_method
FROM stg_sales s
JOIN dim_customer c ON s.customer_id = c.customer_id
JOIN dim_product p ON s.product_id = p.product_id
JOIN dim_date d ON s.sale_date = d.full_date;
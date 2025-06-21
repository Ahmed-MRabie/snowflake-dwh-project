
# ❄️ Snowflake Data Warehouse Project

## 📌 Project Overview

This project demonstrates how to build an end-to-end **Data Warehouse** using **Snowflake**, starting from raw CSV files and ending with a clean **Snowflake Schema (Snowflake-style DWH)** that includes Slowly Changing Dimensions (SCD Type 2) and surrogate keys.

### 🎯 Business Scenario:
We simulate a retail sales scenario, collecting data from:
- Sales transactions
- Customers and products metadata

The final goal is to transform this raw data into a well-structured analytical model for reporting and historical tracking.

---

## 🛠️ Technologies Used

| Tool/Technology     | Purpose                                      |
|---------------------|----------------------------------------------|
| Snowflake           | Data warehouse + staging + transformation   |
| SQL                 | Data modeling, cleansing, and ETL/ELT logic |
| Streams & Tasks     | Automating Slowly Changing Dimensions (SCD2)|
| Python (Optional)   | For generating realistic test data           |
| GitHub              | Version control and project hosting          |

---

## 🔁 Pipeline Steps

1. **Data Generation**  
   - Two main CSV files: `sales.csv` and `products_customers.csv`

2. **Data Staging**  
   - Upload CSVs into an internal Snowflake stage

3. **Raw Table Creation**  
   - Load data into raw staging tables using `COPY INTO`

4. **Transformation Logic**  
   - Populate cleaned `dim` and `fact` tables with surrogate keys

5. **SCD Type 2 Implementation**  
   - Streams track changes in dimension tables
   - Tasks automate versioning logic with `start_date`, `end_date`, and `is_current`

---

## ⭐ Snowflake Schema Overview

- `FACT_SALES` connects to:
  - `DIM_PRODUCT` (with surrogate key and SCD logic)
  - `DIM_CUSTOMER` (with full profile and tracking)
  - `DIM_CATEGORY` (linked to `DIM_PRODUCT`)

- Historical tracking ensures we capture all dimension changes over time

---

## 📊 Final Outcome

By the end of the pipeline, we have:
- A Snowflake schema with clean, historical, and trackable data
- Automated SCD Type 2 processing
- A scalable data warehouse model ready for reporting and analytics

This simulates a real-world enterprise scenario with change tracking and data integrity at the core.

---

## 📚 Resources

- [Snowflake Documentation](https://docs.snowflake.com/)
- [Slowly Changing Dimensions in Snowflake](https://docs.snowflake.com/en/user-guide/streams-intro)
- [SQL Best Practices for DWH](https://mode.com/sql-tutorial/sql-best-practices/)

---

## 🧑‍💻 Author

**Ahmed** – Data Engineering Enthusiast  
[LinkedIn Profile](https://www.linkedin.com/) *(Replace with your link)*

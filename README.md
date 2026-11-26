# Campus Placement & Internship Management System (Oracle SQL + Python)

A 3NF-normalized relational database system built in **Oracle SQL** and integrated with a **Python (`oracledb`) CLI application** to manage student records, eligibility filtering, corporate recruitment drives, applications, and job offers.

## Database Schema (3NF)

| Table Name | Primary Key | Foreign Keys | Description |
| :--- | :--- | :--- | :--- |
| `Departments` | `dept_id` | — | Academic departments offering degrees |
| `Students` | `student_id` | `dept_id` | Student profiles, contact details, and CGPA |
| `Companies` | `company_id` | — | Recruiting corporate partners and industry sectors |
| `Drives` | `drive_id` | `company_id` | Campus recruitment drives, job roles, CTC (LPA), and CGPA cutoffs |
| `Applications` | `app_id` | `student_id`, `drive_id` | Student drive applications (`UNIQUE(student_id, drive_id)`) |
| `Offers` | `offer_id` | `app_id` (Unique) | Final employment offers linked 1:1 to successful applications |

## Project Files
- `01_schema_ddl.sql` — DDL script creating all 6 normalized tables with `CHECK`, `UNIQUE`, and `ON DELETE CASCADE` constraints.
- `02_seed_data_dml.sql` — DML script populating sample departments, students, companies, drives, applications, and offers.
- `03_analytical_queries.sql` — Analytical SQL queries covering `GROUP BY / HAVING`, `LEFT OUTER JOIN`, correlated `EXISTS` subqueries, `> ALL` set comparisons, date arithmetic, and updatable views (`WITH CHECK OPTION`).
- `ds_with_dbms.py` — Python CLI client connecting to Oracle Database via `oracledb` to sync live student records with in-memory Linked List, Stack (Undo), Queue (Interview scheduling), Merge Sort, and Binary Search operations.

## How to Run

### 1. Setup Oracle Database
Execute the SQL scripts sequentially in **Oracle SQL\*Plus** or **Oracle SQL Developer**:
```sql
@01_schema_ddl.sql
@02_seed_data_dml.sql
@03_analytical_queries.sql

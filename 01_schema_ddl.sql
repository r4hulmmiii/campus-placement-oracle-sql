-- ==========================================
-- Campus Placement & Internship Management System
-- Oracle SQL DDL Script (3NF Normalized Schema)
-- ==========================================

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR2(50) NOT NULL UNIQUE
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    full_name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(15),
    cgpa NUMBER(3,2) CHECK (cgpa >= 0.00 AND cgpa <= 10.00),
    dept_id INT,
    grad_year INT CHECK (grad_year >= 2024),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON DELETE CASCADE
);

CREATE TABLE Companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR2(100) NOT NULL,
    industry VARCHAR2(50),
    contact_email VARCHAR2(100) UNIQUE NOT NULL
);

CREATE TABLE Drives (
    drive_id INT PRIMARY KEY,
    company_id INT,
    job_role VARCHAR2(100) NOT NULL,
    ctc_lpa NUMBER(5,2) CHECK (ctc_lpa > 0),
    min_cgpa NUMBER(3,2) CHECK (min_cgpa >= 0.00 AND min_cgpa <= 10.00),
    drive_date DATE NOT NULL,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id) ON DELETE CASCADE
);

CREATE TABLE Applications (
    app_id INT PRIMARY KEY,
    student_id INT,
    drive_id INT,
    apply_date DATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'Applied'
        CHECK (status IN ('Applied', 'Shortlisted', 'Interview', 'Offered', 'Rejected')),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (drive_id) REFERENCES Drives(drive_id) ON DELETE CASCADE,
    CONSTRAINT unique_application UNIQUE (student_id, drive_id)
);

CREATE TABLE Offers (
    offer_id INT PRIMARY KEY,
    app_id INT UNIQUE,
    package_offered NUMBER(5,2) NOT NULL,
    acceptance_status VARCHAR2(20) DEFAULT 'Pending'
        CHECK (acceptance_status IN ('Accepted', 'Rejected', 'Pending')),
    offer_date DATE NOT NULL,
    FOREIGN KEY (app_id) REFERENCES Applications(app_id) ON DELETE CASCADE
);

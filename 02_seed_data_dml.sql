-- ==========================================
-- Sample Data Insertion (DML Script)
-- ==========================================

-- Departments
INSERT INTO Departments (dept_id, dept_name) VALUES (101, 'Computer Applications');
INSERT INTO Departments (dept_id, dept_name) VALUES (102, 'Information Technology');
INSERT INTO Departments (dept_id, dept_name) VALUES (103, 'Data Science');

-- Students
INSERT INTO Students (student_id, full_name, email, phone, cgpa, dept_id, grad_year)
VALUES (1, 'Aarav Sharma', 'aarav.s@college.edu', '9820112233', 8.75, 101, 2026);

INSERT INTO Students (student_id, full_name, email, phone, cgpa, dept_id, grad_year)
VALUES (2, 'Neha Patel', 'neha.p@college.edu', '9820223344', 9.10, 101, 2026);

INSERT INTO Students (student_id, full_name, email, phone, cgpa, dept_id, grad_year)
VALUES (3, 'Rohan Verma', 'rohan.v@college.edu', '9820334455', 7.40, 102, 2026);

INSERT INTO Students (student_id, full_name, email, phone, cgpa, dept_id, grad_year)
VALUES (4, 'Pooja Nair', 'pooja.n@college.edu', '9820445566', 8.20, 103, 2026);

INSERT INTO Students (student_id, full_name, email, phone, cgpa, dept_id, grad_year)
VALUES (5, 'Kunal Joshi', 'kunal.j@college.edu', '9820556677', 6.80, 102, 2026);

-- Companies
INSERT INTO Companies (company_id, company_name, industry, contact_email)
VALUES (201, 'Tata Consultancy Services', 'IT Services', 'careers@tcs.com');

INSERT INTO Companies (company_id, company_name, industry, contact_email)
VALUES (202, 'JPMorgan Chase', 'Finance', 'campus@jpmorgan.com');

INSERT INTO Companies (company_id, company_name, industry, contact_email)
VALUES (203, 'LTI Mindtree', 'IT Consulting', 'recruitment@ltimindtree.com');

INSERT INTO Companies (company_id, company_name, industry, contact_email)
VALUES (204, 'Google', 'Tech', 'jobs@google.com');

-- Drives
INSERT INTO Drives (drive_id, company_id, job_role, ctc_lpa, min_cgpa, drive_date)
VALUES (301, 201, 'Software Engineer', 4.50, 7.00, DATE '2026-08-10');

INSERT INTO Drives (drive_id, company_id, job_role, ctc_lpa, min_cgpa, drive_date)
VALUES (302, 202, 'Analyst FinTech', 8.50, 8.00, DATE '2026-08-18');

INSERT INTO Drives (drive_id, company_id, job_role, ctc_lpa, min_cgpa, drive_date)
VALUES (303, 203, 'Cloud Associate', 5.20, 7.50, DATE '2026-08-25');

INSERT INTO Drives (drive_id, company_id, job_role, ctc_lpa, min_cgpa, drive_date)
VALUES (304, 204, 'Associate Software Engineer', 14.00, 8.50, DATE '2026-09-01');

-- Applications
INSERT INTO Applications (app_id, student_id, drive_id, apply_date, status)
VALUES (401, 1, 301, DATE '2026-08-01', 'Offered');

INSERT INTO Applications (app_id, student_id, drive_id, apply_date, status)
VALUES (402, 1, 302, DATE '2026-08-05', 'Offered');

INSERT INTO Applications (app_id, student_id, drive_id, apply_date, status)
VALUES (403, 2, 302, DATE '2026-08-05', 'Offered');

INSERT INTO Applications (app_id, student_id, drive_id, apply_date, status)
VALUES (404, 3, 301, DATE '2026-08-02', 'Rejected');

INSERT INTO Applications (app_id, student_id, drive_id, apply_date, status)
VALUES (405, 4, 303, DATE '2026-08-12', 'Shortlisted');

INSERT INTO Applications (app_id, student_id, drive_id, apply_date, status)
VALUES (406, 5, 301, DATE '2026-08-02', 'Interview');

-- Offers
INSERT INTO Offers (offer_id, app_id, package_offered, acceptance_status, offer_date)
VALUES (501, 401, 4.50, 'Rejected', DATE '2026-08-14');

INSERT INTO Offers (offer_id, app_id, package_offered, acceptance_status, offer_date)
VALUES (502, 402, 8.50, 'Accepted', DATE '2026-08-22');

INSERT INTO Offers (offer_id, app_id, package_offered, acceptance_status, offer_date)
VALUES (503, 403, 8.50, 'Accepted', DATE '2026-08-22');

COMMIT;

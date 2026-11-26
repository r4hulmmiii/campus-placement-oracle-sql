-- ==========================================
-- Analytical & Reporting Queries (Oracle SQL)
-- ==========================================

-- 1. Aggregates with GROUP BY and HAVING: Departments with avg package > 5.0 LPA
SELECT
    d.dept_name,
    COUNT(o.offer_id) AS total_placed,
    ROUND(AVG(o.package_offered), 2) AS avg_package
FROM Departments d
JOIN Students s ON d.dept_id = s.dept_id
JOIN Applications a ON s.student_id = a.student_id
JOIN Offers o ON a.app_id = o.app_id
GROUP BY d.dept_name
HAVING AVG(o.package_offered) > 5.0;

-- 2. Left Outer Join: All students with application status & package (including unplaced)
SELECT
    s.student_id,
    s.full_name,
    COALESCE(a.status, 'No Application') AS application_status,
    o.package_offered
FROM Students s
LEFT JOIN Applications a ON s.student_id = a.student_id
LEFT JOIN Offers o ON a.app_id = o.app_id;

-- 3. Correlated Subquery with EXISTS: Students with at least one formal job offer
SELECT s.full_name, s.email, s.cgpa
FROM Students s
WHERE EXISTS (
    SELECT 1
    FROM Applications a
    JOIN Offers o ON a.app_id = o.app_id
    WHERE a.student_id = s.student_id
);

-- 4. Set Comparison Subquery (> ALL): Roles offering higher CTC than all Finance roles
SELECT job_role, ctc_lpa
FROM Drives
WHERE ctc_lpa > ALL (
    SELECT d.ctc_lpa
    FROM Drives d
    JOIN Companies c ON d.company_id = c.company_id
    WHERE c.industry = 'Finance'
);

-- 5. String & Date Operations: Formatted contacts and hiring turnaround days
SELECT
    UPPER(s.full_name) AS student_name,
    CONCAT('+91-', s.phone) AS formatted_contact,
    EXTRACT(MONTH FROM a.apply_date) AS application_month,
    ROUND(o.offer_date - a.apply_date) AS turnaround_days
FROM Students s
JOIN Applications a ON s.student_id = a.student_id
JOIN Offers o ON a.app_id = o.app_id;

-- 6. Updatable View with WITH CHECK OPTION: Isolate students with CGPA >= 8.00
CREATE VIEW HighPerformersView AS
SELECT student_id, full_name, cgpa, dept_id
FROM Students
WHERE cgpa >= 8.00
WITH CHECK OPTION;

SELECT * FROM HighPerformersView;

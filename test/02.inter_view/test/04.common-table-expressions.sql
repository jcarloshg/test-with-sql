-- -- Example: List all employees who earn more than the average salary of their own department.
-- WITH
--     dept_avg AS (
--         SELECT department, AVG(salary) AS avg_salary
--         FROM employees
--         GROUP BY
--             department
--     )
-- SELECT e.*
-- FROM employees e
--     JOIN dept_avg d ON e.department = d.department
-- WHERE
--     e.salary > d.avg_salary;
--
-- SELECT department, AVG(salary) AS avg_salary
-- FROM employees
-- GROUP BY
--     department;

-- Step 1: Define the CTE (The "Temporary View")
-- Step 2: Main Query (Join the original table with the CTE)
WITH
    DepartmentBenchmarks AS (
        SELECT department,
            -- Calculate average and round it for cleaner reading
            ROUND(AVG(salary), 2) as avg_dept_salary
        FROM employees
        GROUP BY
            department
    )
SELECT
    e.id,
    e.name,
    e.department,
    e.salary,
    b.avg_dept_salary as department_average,
    -- Optional: Show how much extra they earn
    (e.salary - b.avg_dept_salary) as amount_above_avg
FROM
    employees e
    JOIN DepartmentBenchmarks b ON e.department = b.department
WHERE
    e.salary > b.avg_dept_salary
ORDER BY e.department, e.salary DESC;
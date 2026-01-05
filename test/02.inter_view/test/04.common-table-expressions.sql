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
ORDER BY e.id DESC;

-- RESULT:
-- +-----+----------------+------------------+--------+--------------------+------------------+
-- | id  | name           | department       | salary | department_average | amount_above_avg |
-- +-----+----------------+------------------+--------+--------------------+------------------+
-- | 998 | Alice Williams | Product          | 175337 | 117574.54          | 57762.46         |
-- | 996 | Emma Smith     | Customer Support | 127355 | 118577.41          | 8777.59          |
-- | 995 | David Davis    | Sales            | 133736 | 116888.56          | 16847.44         |
-- | 994 | Charlie Brown  | Marketing        | 161178 | 113511.29          | 47666.71         |
-- | 993 | Bob Brown      | Sales            | 133574 | 116888.56          | 16685.44         |
-- | 990 | Noah Martinez  | Sales            | 144882 | 116888.56          | 27993.44         |
-- | 988 | Liam Johnson   | Marketing        | 136724 | 113511.29          | 23212.71         |
-- | 987 | Eve Smith      | Product          | 158522 | 117574.54          | 40947.46         |
-- | 983 | Olivia Jones   | Product          | 166586 | 117574.54          | 49011.46         |
-- | 982 | Emma Jones     | Marketing        | 128379 | 113511.29          | 14867.71         |
-- +-----+----------------+------------------+--------+--------------------+------------------+
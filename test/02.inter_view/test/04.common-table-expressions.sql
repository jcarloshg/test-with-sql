-- Example: I want to list all employees who earn more than the average salary of their own department.

-- 1. Define the CTE (Think of this as a temporary, named table)
WITH
    DepartmentBenchmarks AS (
        SELECT department, ROUND(AVG(salary), 2) as avg_dept_salary
        FROM employees
        GROUP BY
            department
    );

-- 2. The Main Query (Uses the CTE just like a real table)
SELECT e.name, e.department, e.salary, b.avg_dept_salary,
    -- Calculate how much "extra" they make
    (e.salary - b.avg_dept_salary) as amount_above_avg
FROM
    employees e
    JOIN DepartmentBenchmarks b ON e.department = b.department -- Join the CTE
WHERE
    e.salary > b.avg_dept_salary -- Filter based on CTE data
ORDER BY amount_above_avg DESC;
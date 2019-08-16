SELECT 
    D.Name AS Department, E.Name AS Employee, Salary
FROM 
    Employee E INNER JOIN Department D
    ON E.DepartmentId = D.Id
WHERE 
    (E.DepartmentId, Salary) IN
    (
        SELECT 
            DepartmentId, MAX(Salary)
        FROM 
            Employee
        GROUP BY DepartmentId
    )
;
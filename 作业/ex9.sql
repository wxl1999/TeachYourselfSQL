CREATE TABLE Employee
(
    Id          INTEGER     ,
    Name        TEXT        NOT NULL,
    Salary      INTEGER     NOT NULL,
    ManagerId   INTEGER
);

INSERT INTO Employee
VALUES
    (1, 'Joe', 70000, 3),
    (2, 'Henry', 80000, 4),
    (3, 'Sam', 60000, NULL),
    (4, 'Max', 90000, NULL);

SELECT Name Employee
FROM Employee e1, Employee e2
WHERE e1.ManagerId = e2.Id
AND e1.Salary > e2.Salary;
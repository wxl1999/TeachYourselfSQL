/* CREATE TABLE employee
(
    id          integer     primary key,
    name        text,
    department  char(1),
    managerid   integer
);

insert into employee
values
    (101, 'John', 'A', null),
    (102, 'Dan', 'A', 101),
    (103, 'James', 'A', 101),
    (104, 'Amy', 'A', 101),
    (105, 'Anne', 'A', 101),
    (106, 'Ron', 'B', 101); */


SELECT 
    name
FROM 
    Employee
WHERE
    managerid IN
    (
        SELECT
            E2.managerid
        FROM
            Employee E2
        GROUP BY E2.managerid
        HAVING COUNT(*) >= 5
    );

SELECT 
    DISTINCT E1.name
FROM
    Employee E1, Employee E2
WHERE 
    E1.id = E2.managerid;
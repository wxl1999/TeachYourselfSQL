CREATE TABLE Salary
(
    id      CHAR(1)     NOT NULL,
    name    CHAR(1)     NOT NULL,
    sex     CHAR(1)     NOT NULL,
    Salary  INTEGER     NOT NULL
);

INSERT INTO Salary
VALUES(
    '1', 'A', 'm', 2500
);

INSERT INTO Salary
VALUES(
    '2', 'B', 'f', 1500
);

INSERT INTO Salary
VALUES(
    '3', 'C', 'm', 5500
);

INSERT INTO Salary
VALUES(
    '4', 'D', 'f', 500
);

UPDATE Salary
SET sex = (
    CASE WHEN sex = 'm' THEN 'f' 
    ELSE 'm'
    END
);

SELECT * FROM Salary;
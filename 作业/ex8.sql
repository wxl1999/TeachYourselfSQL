CREATE TABLE Customers1
(
    Id      INTEGER     NOT NULL,
    Name    TEXT     NOT NULL
);

CREATE TABLE Orders1
(
    Id          INTEGER     NOT NULL,
    CustomerId  INTEGER     NOT NULL
);

INSERT INTO Customers1
VALUES
    (1, 'Joe'),
    (2, 'Henry'),
    (3, 'Sam'),
    (4, 'Max');

INSERT INTO Orders1
VALUES
    (1, 3),
    (2, 1);

SELECT Name Customers
FROM Customers1 C LEFT OUTER JOIN Orders1 O
ON C.Id = O.CustomerId;
WHERE CustomerId IS NULL;
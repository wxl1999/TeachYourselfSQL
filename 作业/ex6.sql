CREATE TABLE Person
(
    PersonId    INTEGER     NOT NULL    PRIMARY KEY,
    FirstName   TEXT        NOT NULL,
    LastName    TEXT        NOT NULL
);

CREATE TABLE Address
(
    AddressId   INTEGER     NOT NULL    PRIMARY KEY,
    PersonId    INTEGER     NOT NULL,
    City        TEXT        NOT NULL,
    State       TEXT        NOT NULL
);

INSERT INTO Person
VALUES
    (1, 'wang', 'xiaolei'),
    (2, 'huang', 'jiani'),
    (3, 'chen', 'ke')
;

INSERT INTO Address
VALUES
    (1, 1, 'Beijing', 'China'),
    (2, 3, 'Shanghai' ,'China'),
    (3, 2, 'Suzhou', 'China')
;

SELECT FirstName, LastName, City, State
FROM Person P LEFT OUTER JOIN Address A
ON P.PersonId = A.PersonId;
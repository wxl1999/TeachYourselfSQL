CREATE TABLE Email
(
    Id      INTEGER     NOT NULL    PRIMARY KEY,
    Email   TEXT        NOT NULL
);

INSERT INTO Email
VALUES
    (1, 'a@b.com'),
    (2, 'c@d.com'),
    (3, 'a@b.com');

DELETE e1
FROM Email e1, Email e2
WHERE e1.Email = e2.Email
AND e1.Id > e2.Id;
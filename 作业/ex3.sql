CREATE TABLE courses
(
    student	CHAR(1)	    NOT NULL,
    class	CHAR(10)    NOT NULL
)
;

INSERT INTO courses
VALUES('A', 'Math');

INSERT INTO courses
VALUES('B','English');

INSERT INTO courses
VALUES('C','Math');

INSERT INTO courses
VALUES('D','Biology');

INSERT INTO courses
VALUES('E','Math');

INSERT INTO courses
VALUES('F', 'Computer');

INSERT INTO courses
VALUES('G', 'Math');

INSERT INTO courses
VALUES('H', 'Math');

INSERT INTO courses
VALUES('I', 'Math');

INSERT INTO courses
VALUES('J', 'Math');

SELECT class
FROM courses
GROUP BY class
HAVING COUNT(student) >= 5;
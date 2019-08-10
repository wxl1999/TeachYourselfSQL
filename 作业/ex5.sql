CREATE TABLE cinema
(
    id          CHAR(1)     NOT NULL,
    movie       CHAR(15)    NOT NULL,
    description CHAR(15)    NOT NULL,
    rating      FLOAT       NOT NULL
);

INSERT INTO cinema
VALUES 
    ('1', 'War', 'great 3D', 8.9),
    ('2', 'Science', 'ficiton', 8.5),
    ('3', 'irish', 'boring', 6.2),
    ('4', 'Ice song', 'Fantacy', 8.6),
    ('5', 'House card', 'Interesting', 9.1)
;

SELECT *
FROM cinema
WHERE id % 2 = 1 AND description != 'boring'
ORDER BY rating DESC;  

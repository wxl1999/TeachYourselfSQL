SELECT
    Score, 
    (
        SELECT 
            COUNT(DISTINCT S2.score)
        FROM 
            Scores S2
        WHERE S2.score >= S1.score
    ) AS Rank
FROM 
    Scores S1
ORDER BY score DESC;
SELECT
    Num AS ConsecutiveNums
FROM 
    Logs
GROUP BY 
    Num
HAVING 
    MAX(Id) - MIN(Id) = COUNT(*) - 1
    AND COUNT(*) >= 3;
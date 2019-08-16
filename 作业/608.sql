SELECT
    T1.id,
    CASE 
        WHEN T1.p_id IS NULL THEN 'Root'
        WHEN T1.id IN 
        (
            SELECT
                p_id
            FROM 
                TREE 
            -- WHERE 
               -- T1.id = p_id
        )
        THEN 'Inner'
        ELSE 'Leaf'
    END
FROM 
    TREE T1
ORDER BY T1.id;

SELECT
    id,
    IF (ISNULL(p_id), 'Root',
        IF(id IN (SELECT p_id FROM Tree), 'Inner', 'Leaf')) AS Type
FROM 
    Tree;

--- 2
--- Q1

CREATE TYPE R AS (a int, bint);
CREATE TABLE r of R_TYPE;

INSERT INTO R (a, b) VALUES (7, 5);
INSERT INTO R (a, b) VALUES (12, 14);
INSERT INTO R (a, b) VALUES (8, 3);
INSERT INTO R (a, b) VALUES (3, 17);
INSERT INTO R (a, b) VALUES (15, 7);
INSERT INTO R (a, b) VALUES (20, 12);
INSERT INTO R (a, b) VALUES (5, 1);
INSERT INTO R (a, b) VALUES (9, 18);
INSERT INTO R (a, b) VALUES (14, 9);
INSERT INTO R (a, b) VALUES (2, 20);
INSERT INTO R (a, b) VALUES (11, 13);
INSERT INTO R (a, b) VALUES (4, 2);
INSERT INTO R (a, b) VALUES (18, 11);
INSERT INTO R (a, b) VALUES (7, 16);
INSERT INTO R (a, b) VALUES (13, 4);
INSERT INTO R (a, b) VALUES (1, 19);
INSERT INTO R (a, b) VALUES (6, 8);
INSERT INTO R (a, b) VALUES (19, 10);
INSERT INTO R (a, b) VALUES (10, 6);
INSERT INTO R (a, b) VALUES (17, 15);
INSERT INTO R (a, b) VALUES (16, 1);
INSERT INTO R (a, b) VALUES (3, 14);
INSERT INTO R (a, b) VALUES (8, 7);
INSERT INTO R (a, b) VALUES (14, 13);
INSERT INTO R (a, b) VALUES (5, 9);
INSERT INTO R (a, b) VALUES (2, 20);
INSERT INTO R (a, b) VALUES (9, 4);
INSERT INTO R (a, b) VALUES (12, 18);
INSERT INTO R (a, b) VALUES (20, 11);
INSERT INTO R (a, b) VALUES (11, 2);
INSERT INTO R (a, b) VALUES (4, 16);
INSERT INTO R (a, b) VALUES (6, 3);
INSERT INTO R (a, b) VALUES (18, 8);
INSERT INTO R (a, b) VALUES (1, 19);
INSERT INTO R (a, b) VALUES (15, 10);
INSERT INTO R (a, b) VALUES (17, 5);
INSERT INTO R (a, b) VALUES (7, 12);
INSERT INTO R (a, b) VALUES (10, 14);
INSERT INTO R (a, b) VALUES (3, 6);
INSERT INTO R (a, b) VALUES (16, 17);
INSERT INTO R (a, b) VALUES (19, 1);
INSERT INTO R (a, b) VALUES (8, 4);
INSERT INTO R (a, b) VALUES (5, 13);
INSERT INTO R (a, b) VALUES (14, 7);
INSERT INTO R (a, b) VALUES (9, 20);
INSERT INTO R (a, b) VALUES (13, 9);
INSERT INTO R (a, b) VALUES (2, 11);
INSERT INTO R (a, b) VALUES (20, 18);
INSERT INTO R (a, b) VALUES (12, 15);
INSERT INTO R (a, b) VALUES (11, 2);


SELECT r.a, COUNT(*) AS c
FROM   R AS r
WHERE  r.b <> 3
GROUP BY r.a;
 a  | c 
----+---
 11 | 3
  9 | 3
 15 | 2
 19 | 2
  3 | 3
 17 | 2
  5 | 3
  4 | 2
 10 | 2
  6 | 1
 14 | 3
 13 | 2
  2 | 3
 16 | 2
  7 | 3
 12 | 3
 20 | 3
  1 | 2
 18 | 2
  8 | 2

-- This query will return a count of rows for each distinct value of a where the value of b is not 3. 
-- If there are multiple rows with the same a but different values of b (as long as b is not 3), they will all contribute to the count.

SELECT r.a, COUNT(*) AS c
FROM   R AS r 
GROUP BY r.a
HAVING EVERY(r.b <> 3);
 a  | c 
----+---
 11 | 3
  9 | 3
 15 | 2
 19 | 2
  3 | 3
 17 | 2
  5 | 3
  4 | 2
 10 | 2
 14 | 3
 13 | 2
  2 | 3
 16 | 2
  7 | 3
 12 | 3
 20 | 3
  1 | 2
 18 | 2

-- Filtering with HAVING: The HAVING EVERY(r.b <> 3) clause checks if all rows in each group satisfy the condition r.b <> 3.↳

-- The EVERY() function returns TRUE if all values in the group meet the condition, and FALSE if any row in the group has b = 3.

-- This query will only return groups (with their counts) where all rows in the group have b values that are not equal to 3. 
-- If even one row in a group has b = 3, that entire group will be excluded from the results.


---- 3

SELECT ps.product_name AS complete FROM production_steps AS ps GROUP BY ps.product_name HAVING EVERY(ps.completion_date IS NOT NULL);

complete |
----+-----
TIE      |

---- 4

---- Q1

DROP TABLE IF EXISTS A CASCADE;
CREATE TABLE A (
  row int,
  col int,
  val int,
  PRIMARY KEY(row, col));

DROP TABLE IF EXISTS B CASCADE;
CREATE TABLE B ( LIKE A );

-- Example
INSERT INTO A (row,col,val)
VALUES (1,1,1), (1,2,2),
       (2,1,3), (2,2,4);


INSERT INTO B (row,col,val)
VALUES (1,1,1), (1,2,2), (1,3,1),
       (2,1,2), (2,2,1), (2,3,2);

SELECT * FROM A;

SELECT * FROM B;

SELECT 
    A.row AS row,
    B.col AS col,
    SUM(A.val * B.val) AS val
FROM 
    A
JOIN 
    B ON A.col = B.row
GROUP BY 
    A.row, 
    B.col
ORDER by row, col;


---- Q2

TRUNCATE A;
TRUNCATE B;

INSERT INTO A (row,col,val)
VALUES (1,1,1), (1,2,3),
       (2,3,7);


INSERT INTO B (row,col,val)
VALUES (1,1,4),          (1,3,8 ),
       (2,1,1), (2,2,1), (2,3,10),
       (3,1,3), (3,2,6);

SELECT 
    A.row AS row,
    B.col AS col,
    SUM(A.val * B.val) AS val
FROM 
    A
JOIN 
    B ON A.col = B.row
GROUP BY 
    A.row, 
    B.col
ORDER by row, col;

-- The SQL query handles missing entries by performing operations only on the entries that exist in both A and B.
-- The result is still correct for sparse matrices, meaning that missing entries are treated as zeros during the multiplication process.

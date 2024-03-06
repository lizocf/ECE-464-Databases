-- 1. List, for every boat, the number of times it has been reserved, excluding those boats that have never been reserved (list the id and the name).

-- SELECT boats.bname, reserves.bid, COUNT(*) rsvps FROM reserves 
-- INNER JOIN boats ON boats.bid = reserves.bid
-- GROUP BY boats.bname, reserves.bid;

-- or --

SELECT boats.bname, reserves.bid, COUNT(*) rsvps
FROM reserves, boats WHERE boats.bid = reserves.bid
GROUP BY boats.bname, reserves.bid 
ORDER BY boats.bname, reserves.bid;


--         bname         | bid | rsvps 
-- ----------------------+-----+-------
--  Clipper              | 103 |     3
--  Clipper              | 104 |     5
--  Driftwood            | 108 |     1
--  Driftwood            | 109 |     4
--  Interlake            | 101 |     2
--  Interlake            | 102 |     3
--  Klapser              | 110 |     3
--  Marine               | 105 |     3
--  Marine               | 106 |     3
--  Marine               | 107 |     1
--  Sooney               | 111 |     1
--  Sooney               | 112 |     1

-- 2. List those sailors who have reserved every red boat (list the id and the name).

-- SELECT sailors.sname, reserves.sid FROM reserves 
-- INNER JOIN boats ON boats.bid = reserves.bid
-- JOIN sailors ON sailors.sid = reserves.sid 
-- WHERE boats.color LIKE '%red%' 
-- GROUP BY sailors.sname, reserves.sid;

-- or --

SELECT sailors.sname, reserves.sid                                     
FROM sailors, boats, reserves
WHERE boats.color='red' AND boats.bid=reserves.bid 
AND sailors.sid = reserves.sid
GROUP BY sailors.sname, reserves.sid
ORDER BY sailors.sname, reserves.sid;

--   sname   | sid 
-- ----------+-----
--  dan      |  88
--  dusting  |  22
--  dye      |  89
--  emilio   |  23
--  figaro   |  35
--  horatio  |  64
--  lubber   |  31
--  ossola   |  61
--  scruntus |  24
--  shaun    |  62
--  stum     |  59

-- -- 3. List those sailors who have reserved only red boats.

SELECT sailors.sname, reserves.sid                                     
FROM sailors, boats, reserves
WHERE boats.color='red' AND boats.bid=reserves.bid 
AND sailors.sid = reserves.sid 
EXCEPT 
SELECT sailors.sname, reserves.sid                                     
FROM sailors, boats, reserves 
WHERE boats.color != 'red' AND boats.bid=reserves.bid 
AND sailors.sid = reserves.sid
GROUP BY sailors.sname, reserves.sid;

--   sname   | sid 
-- ----------+-----
--  emilio   |  23
--  shaun    |  62
--  ossola   |  61
--  figaro   |  35
--  scruntus |  24

-- 4. For which boat are there the most reservations?

SELECT boats.bname, reserves.bid, COUNT(*) rsvps
FROM reserves, boats WHERE boats.bid = reserves.bid
GROUP BY boats.bname, reserves.bid ORDER BY rsvps DESC LIMIT 1;

--         bname         | bid | rsvps 
-- ----------------------+-----+-------
--  Clipper              | 104 |     5

-- 5. Select all sailors who have never reserved a red boat. (opposite of 3)

SELECT sailors.sname, reserves.sid                                     
FROM sailors, boats, reserves 
WHERE boats.color != 'red' AND boats.bid=reserves.bid 
AND sailors.sid = reserves.sid
GROUP BY sailors.sname, reserves.sid
EXCEPT
SELECT sailors.sname, reserves.sid                                     
FROM sailors, boats, reserves
WHERE boats.color='red' AND boats.bid=reserves.bid 
AND sailors.sid = reserves.sid;

--   sname  | sid 
-- ---------+-----
--  vin     |  90
--  jit     |  60
--  horatio |  74

-- 6. Find the average age of sailors with a rating of 10.

SELECT AVG(age)
FROM sailors                              
WHERE rating = 10;

--          avg         
-- ---------------------
--  35.0000000000000000

-- 7. For each rating, find the name and id of the youngest sailor.
-- please do this ): --

SELECT DISTINCT ex.rating, sailors.sname, ex.min_age
FROM sailors INNER JOIN ( SELECT sailors.rating, MIN(sailors.age) min_age 
FROM sailors GROUP BY sailors.rating) ex
ON sailors.age = ex.min_age AND ex.rating = sailors.rating 
GROUP BY ex.rating, sailors.sname, ex.min_age
ORDER BY ex.rating, ex.min_age; 


--  rating |  sname   | min_age 
-- --------+----------+---------
--       1 | brutus   |      33
--       1 | scruntus |      33
--       3 | art      |      25
--       3 | dye      |      25
--       7 | horatio  |      16
--       7 | ossola   |      16
--       8 | andy     |      25
--       8 | stum     |      25
--       9 | dan      |      25
--       9 | horatio  |      25
--      10 | jit      |      35
--      10 | rusty    |      35
--      10 | shaun    |      35
--      10 | zorba    |      35


-- 8. Select, for each boat, the sailor who made the highest number of reservations for that boat.

SELECT DISTINCT boats.bid, sailors.sname, COUNT(*) rsvps
FROM boats JOIN reserves ON boats.bid = reserves.bid
JOIN sailors ON sailors.sid = reserves.sid
GROUP BY boats.bid, sailors.sname
HAVING COUNT(*) >= ALL
    (SELECT COUNT(*)
    FROM reserves WHERE reserves.bid = boats.bid
    GROUP BY reserves.sid)
ORDER BY boats.bid;

--  bid |  sname   | count 
-- -----+----------+-------
--  101 | dusting  |     1
--  101 | horatio  |     1
--  102 | dusting  |     1
--  102 | horatio  |     1
--  102 | lubber   |     1
--  103 | dusting  |     1
--  103 | horatio  |     1
--  103 | lubber   |     1
--  104 | dusting  |     1
--  104 | emilio   |     1
--  104 | figaro   |     1
--  104 | lubber   |     1
--  104 | scruntus |     1
--  105 | emilio   |     1
--  105 | figaro   |     1
--  105 | stum     |     1
--  106 | jit      |     2 -- distinct
--  107 | dan      |     1
--  108 | dye      |     1
--  109 | dye      |     1
--  109 | jit      |     1
--  109 | stum     |     1
--  109 | vin      |     1
--  110 | dan      |     2 -- distinct
--  111 | dan      |     1
--  112 | ossola   |     1
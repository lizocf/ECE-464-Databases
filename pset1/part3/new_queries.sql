-- Here are some examples of queries you may run with boat_repairs:


-- 1. How much money was currently earned by repair fees? (which repairs were already paid off and how much total)

SELECT SUM(total) FROM boat_repairs br
WHERE paid_date IS NOT NULL;

--  sum  
-- ------
--  3250

-- 2. Which boat cannot be used for sailing at the moment? (condition < 7)

SELECT b.bid, b.bname FROM boats b WHERE condition < 7;

--  bid |        bname         
-- -----+----------------------
--  103 | Clipper             
--  104 | Clipper             
--  106 | Marine              
--  107 | Marine              
--  109 | Driftwood  


-- 3. Which sailor is the most frequent in causing damage to boats? (Should ban them!!!)

SELECT s.sid, s.sname, COUNT(*) AS damage_count
FROM boat_repairs br
JOIN sailors s ON br.sid_responsible = s.sid
GROUP BY s.sid, s.sname
ORDER BY damage_count DESC
LIMIT 1;

--  sid | sname  | damage_count 
-- -----+--------+--------------
--   23 | emilio |            3
-- select * from sailors as s
-- left join reserves as r on r.sid = s.sid;

-- left join: every key in table 1 and table 1 intersection table 2
-- right join:
-- inner join:
-- outer join:

-- all sailors who reserved after 1998-09-09
select * from sailors as s
left join reserves as r on r.sid = s.sid and r.day > '1998-09-09'; -- use single quotes!

-- All reservations where the age of the sailer is higher than the length of the boat
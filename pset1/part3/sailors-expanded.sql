/*
SQL queries to populate a Sailors and Boats dataset (Part 3)
*/

/*
BRIEF WRITE-UP:
The mom/pop shop may suffer from multiple damage reports per boat. As a result,
they would need some way to track which boats need repair, whether it is in good
condition to be used, and whether or not the tourists had paid off the damages. 
I propose a "boat_repairs" table that tracks which boat needs repairs, a damage column
for the shop owners to write a description of what happened, which sailor was responsible
for doing the damage, the fee they must pay, when the damage was done, and when the 
repair was paid. 

*/

create table boat_repairs(
    rid int PRIMARY KEY,         -- repair id
    bid int,                     -- which boat needs repairs
    damage varchar(50),          -- here, shop owner can write a brief description of what damage was done.
    sid_responsible int, -- which sailor is responsible for the damage?
    cost int,                    -- how much does the sailor need to pay off?
    dmg_date date,               -- when was the damage dealt?
    due_date date,               -- when shop owner wants money by
    paid_date date DEFAULT NULL,  -- when was it paid off?        
    late_fees int DEFAULT 0,     -- if past due date, add $50 for example
    total int                    -- total cost of repair fee
);


create table boats(
    bid int PRIMARY KEY,
	bname char(20),
	color char(10),
	length int,
    condition int,                     -- the condition of a boat is ranked from a scale of 0-10 (bad -> good).
    needs_repair boolean DEFAULT FALSE -- if a bid is in boat_repairs AND paid_date is NULL, then TRUE
);

create table sailors(
    sid int PRIMARY KEY,
    sname varchar(30),
    rating int,
    age int
);

create table reserves(
    sid int,
    bid int,
    day date,
	PRIMARY KEY (sid, bid, day)
);


-- example inputs for boat_repairs --

INSERT INTO boat_repairs VALUES (1, 103, 'Hull damage', 88, 500, '2024-02-15', '2024-03-15', '2024-03-20', 0, 500); -- No late fee
INSERT INTO boat_repairs VALUES (2, 104, 'Sail torn', 22, 300, '2024-02-20', '2024-03-20', '2024-03-25', 50, 350);  -- Late fee applied
INSERT INTO boat_repairs VALUES (3, 108, 'Leaking', 89, 200, '2024-02-25', '2024-03-25', '2024-04-05', 100, 300);   -- Late fee applied
INSERT INTO boat_repairs VALUES (4, 109, 'Mast broken', 23, 700, '2024-03-01', '2024-04-01', '2024-04-03', 50, 750); -- Late fee applied
INSERT INTO boat_repairs VALUES (5, 101, 'Rudder damaged', 23, 400, '2024-03-05', '2024-04-05', '2024-04-01', 0, 400);-- No late fee
INSERT INTO boat_repairs VALUES (6, 102, 'Anchor lost', 23, 600, '2024-03-10', '2024-04-10', '2024-04-12', 50, 650); -- Late fee applied
INSERT INTO boat_repairs VALUES (7, 110, 'Sail ripped', 35, 250, '2024-03-15', '2024-04-15', '2024-04-16', 50, 300);  -- Late fee applied
INSERT INTO boat_repairs VALUES (8, 105, 'Propeller damaged', 35, 450, '2024-03-20', '2024-04-20', NULL, 0, 450);    -- No payment yet
INSERT INTO boat_repairs VALUES (9, 106, 'Keel cracked', 61, 550, '2024-03-25', '2024-04-25', NULL, 0, 550);          -- No payment yet
INSERT INTO boat_repairs VALUES (10, 107, 'Engine failure', 59, 800, '2024-03-30', '2024-04-30', NULL, 0, 800);     -- No payment yet

--  - - - - - - - -- - --- -- --  --

insert into sailors values (22,'dusting',7,45);
insert into sailors values (29,'brutus',1,33);
insert into sailors values (31,'lubber',8,55);
insert into sailors values (32,'andy',8,25);
insert into sailors values (58,'rusty',10,35);
insert into sailors values (64,'horatio',7,16);
insert into sailors values (71,'zorba',10,35);
insert into sailors values (74,'horatio',9,25);
insert into sailors values (85,'art',3,25);
insert into sailors values (95,'bob',3,63);
insert into sailors values (23,'emilio',7,45);
insert into sailors values (24,'scruntus',1,33);
insert into sailors values (35,'figaro',8,55);
insert into sailors values (59,'stum',8,25);
insert into sailors values (60,'jit',10,35);
insert into sailors values (61,'ossola',7,16);
insert into sailors values (62,'shaun',10,35);
insert into sailors values (88,'dan',9,25);
insert into sailors values (89,'dye',3,25);
insert into sailors values (90,'vin',3,63);

insert into reserves values (23,104,'1998/10/10');
insert into reserves values (24,104,'1998/10/10');
insert into reserves values (35,104,'1998/8/10');
insert into reserves values (59,105,'1998/7/10');
insert into reserves values (23,105,'1998/11/10');
insert into reserves values (35,105,'1998/11/6');
insert into reserves values (59,106,'1998/11/12');
insert into reserves values (60,106,'1998/9/5');
insert into reserves values (60,106,'1998/9/8');
insert into reserves values (88,107,'1998/9/8');
insert into reserves values (89,108,'1998/10/10');
insert into reserves values (90,109,'1998/10/10');
insert into reserves values (89,109,'1998/8/10');
insert into reserves values (60,109,'1998/7/10');
insert into reserves values (59,109,'1998/11/10');
insert into reserves values (62,110,'1998/11/6');
insert into reserves values (88,110,'1998/11/12');
insert into reserves values (88,110,'1998/9/5');
insert into reserves values (88,111,'1998/9/8');
insert into reserves values (61,112,'1998/9/8');
insert into reserves values (22,101,'1998/10/10');
insert into reserves values (22,102,'1998/10/10');
insert into reserves values (22,103,'1998/8/10');
insert into reserves values (22,104,'1998/7/10');
insert into reserves values (31,102,'1998/11/10');
insert into reserves values (31,103,'1998/11/6');
insert into reserves values (31,104,'1998/11/12');
insert into reserves values (64,101,'1998/9/5');
insert into reserves values (64,102,'1998/9/8');
insert into reserves values (74,103,'1998/9/8');

insert into boats values (101,'Interlake','blue', 45, 10);
insert into boats values (102,'Interlake','red', 45, 8);
insert into boats values (103,'Clipper','green', 40, 6);
insert into boats values (104,'Clipper','red', 40, 6);
insert into boats values (105,'Marine','red', 35, 7);
insert into boats values (106,'Marine','green', 35, 4);
insert into boats values (107,'Marine','blue', 35, 4);
insert into boats values (108,'Driftwood','red', 35, 9);
insert into boats values (109,'Driftwood','blue', 35, 2);
insert into boats values (110,'Klapser','red', 30, 8);
insert into boats values (111,'Sooney','green', 28, 10);
insert into boats values (112,'Sooney','red', 28, 10);

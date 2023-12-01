-- Assignment --
-- Q1 --- 
-- Identify the primary keys and foreign keys in maven movies database and Discuss the differences---
-- PRIMARY KEY
-- This is a unique identifier generally is focuse on the uniqueness of the table its assures that the value in a specific column is unique.
-- a table allows only one primary key in a table.

-- FOKREIGN KEY 
-- This is used to build relationship bewteen two tables or you can say it is act like a bridge between two table.
-- Tables can allows more then one foreign key.

-- show tables;
-- describe actor;
 -- actor_id is primary key and last_name is foreign key
 
-- describe actor_award;
 -- actor_id is primary key and last_name is foreign key
 
-- describe address;
 -- address_id is primary key and city_id is foreign key
 
-- describe advisor;
 -- advisor_id is primary key
 
-- describe category;
 -- category_id is primary key 
 
-- describe city;
 -- city_id is primary key and country_id is fireign key
 
 -- describe country;
 -- country_id is primary key
 
-- describe customer;
 -- customer_id is primary key and store_id ,last_name,address_id is foreign key
 
-- describe film;
 -- film_id is primary key and title ,languge_id ,origignal_languge_id  is foreign key
 
-- describe film_actor;
 -- actor_id , film_id is primary key
 
-- describe film_category;
 -- film_id and category_id is primary key
 
--  describe film_text;
  -- film_id is primary key and title is foreign key
  
use mavenmovies;
-- Q2--- list all details of actors ---

select*from actor;

-- Q3 --- list of all customer information from DB ---

select*from customer;

-- Q4 --- list different countries ---

select*from country;

-- Q5 --- list all the active customers ---

select first_name, last_name, active from customer;

-- Q6 -- list of all rentle IDs for customer with ID 1,

select customer_id, rental_id from rental where customer_id=1;

-- Q7-- display all the films whose rental duration is grater then 5,

select title,description,rental_duration from film where rental_duration>5;

-- Q8-- list the total number of films whose replacement cost is grater then $15 and less then $20,

select title , description, replacement_cost from film where replacement_cost>15 and replacement_cost<20;

-- Q9-- display the count of unique first_name of actors,

select count(distinct first_name) as first_name from actor;

-- Q10--  display the first 10 records from customer table,

select*from customer limit 10;

-- Q11--  display the first 3 record from the customer table whose first name starts with 'b',

select * from customer where first_name like 'b%' limit 3;

-- Q12-- display the name of first 5 movies(films) which are rated as 'G',

select title,rating from film where rating = 'G' limit 5;

-- Q13-- find all customer whose first name starts with 'A',

select first_name from customer where first_name like 'A%';

-- Q14-- find all customer whose first name ends with 'a' ,

select first_name from customer where first_name like '%A';

-- Q15-- Display the list of first 4 cities which start and end with 'a',

select city from city where  city like 'a%a' limit 4;

-- Q16-- find all customer whose first name have 'NI' in any position,

select first_name from customer where first_name like '%NI%';

-- Q17-- find all customer whose first name  have 'r' in the second position,

select first_name from customer where first_name like '_r%';

-- Q18-- FIND all customer whose first name starts with 'a' and at least 5 characters in length,

select first_name from customer where first_name like 'a%'and length(first_name)>=5;

-- Q19-- find all customer whose first name starts with 'a ' and ends with 'o',

select first_name from customer where first_name like 'a%o';

-- Q20-- get the film with pg and pg-13 rating using IN oprator,

select title, rating from film where rating in ('pg','pg-13');

-- Q21-- get the film with lengh between 50 to 100 using between oprator,

select title, length  from film where length between 50 and 100;

-- Q22-- get the top 50 actor using limit oprrtor,

select *from actor order by actor_id limit 50;

-- Q23-- get the distinct film ids  from inventory table,

select distinct film_id  from inventory;

-- END -- 
/*  Normalisation and CTE queries_assignment

 Q 1. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.

--> Actor_award table violate nf1 formation in mavenmovies database violate 1nf formation we can normalised it by updating 
 the actor_award table , avoid multivalued (each column has only atomic values) , Also we can create seperate tables for the
 columns which contain multiple values etc 
select awards from actor_award ;


 Q 2. Choose a table in Sakila and describe how you would determine whether it is in 2NF. If it violates 2NF, explain the steps to normalize it.

--> select * from film ; 
film table from sakila databse violates 2nf because of the special features column special feature column on the
table violate 1nf and 2nf has a rule that table is in 1nf 
Identify Partial Dependencies: all the non-prime attributes like title , discription , release_year etc are fully dependent on the primary key
which is film id 
we can create a another table and make them columns foreign keys and these foreign keys make reference to that film id table 
by using these steps we can avoid 2 nf .


 Q 3. Identify a table in Sakila that violates 3NF. 
 Describe the transitive dependencies present and outline the steps to normalize the table to 3NF.

--> if we saw the customer table in the sakila database we get to know that the column name address_id is linked with store id
 and both are non key attribute  and 3nf stays that table is in 2 nf from and it ensure that all the non key attribute column on the
table are not related with each other (one non key attribute column related to other non key attribute column) so because of that it 
violate 2 and 3 nf 

steps to prevent 3nf ; 

1, analyse the violation 
2, create new table to store data 
3 , update customer table (make store id as foreign key )
4 , update address info. (so it reference to the foreign key )
etc 


Q 4. Take a specific table in Sakila and guide through the process of normalizing it from the initial
	unnormalized form up to at least 2NF.

--> Initial Unnormalized Form:

The film_actor table in the Sakila database is already in 1NF because it contains no repeating groups. 
However, it can be further normalized to 2NF to eliminate partial dependencies.

2NF Violation:

The film_actor table violates 2NF because the non-key attribute last_update is transitively dependent on the primary key actor_id through the actor table.
This means that last_update can be determined from actor_id without needing the entire primary key of film_actor, which is actor_id and film_id.

Normalization Steps:

Identify the transitive dependency: Determine that last_update is transitively dependent on actor_id through the actor table.
Create a new table: Create a new table named actor_update to store the actor_id and last_update columns.
Modify the original table: Remove the last_update column from the film_actor table.
Establish a relationship: Establish a foreign key relationship between the film_actor table and the actor_update table using the actor_id column.
*/

-- Q 5. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have
-- acted in from the actor and film_actor tables.

WITH ActorFilmCount AS (
    SELECT
        a.actor_id,
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM
        actor a
    JOIN
        film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY
        a.actor_id, actor_name
)

SELECT
    actor_name,
    film_count
FROM
    ActorFilmCount
ORDER BY
    film_count DESC, actor_name ; 
    
    
-- Q 6. Use a recursive CTE to generate a hierarchical list of categories and their subcategories from the category table in Sakila.   

WITH RECURSIVE CategoryHierarchy AS (
    SELECT
        c.category_id,
        c.name AS category_name,
        NULL AS parent_category_id,
        0 AS level
    FROM
        category c
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM film_category fc
            WHERE fc.category_id = c.category_id
        )

    UNION ALL

    SELECT
        c.category_id,
        c.name AS category_name,
        fc.category_id AS parent_category_id,
        ch.level + 1 AS level
    FROM
        category c
    JOIN
        film_category fc ON c.category_id = fc.category_id
    JOIN
        CategoryHierarchy ch ON fc.film_id = ch.category_id
)

SELECT
    category_id,
    category_name,
    parent_category_id,
    level
FROM
    CategoryHierarchy
ORDER BY
    level, category_id ; 
    
    
-- Q 7. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.    
    
    WITH FilmLanguageInfo AS (
    SELECT
        f.title AS film_title,
        l.name AS language,
        f.rental_rate
    FROM
        film f
    JOIN
        language l ON f.language_id = l.language_id
)

SELECT
    film_title,
    language,
    rental_rate
FROM
    FilmLanguageInfo;
    
-- Q 8. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.   

WITH CustomerRevenue AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(p.amount) AS total_revenue
    FROM
        customer c
    LEFT JOIN
        payment p ON c.customer_id = p.customer_id
    GROUP BY
        c.customer_id, customer_name
)

SELECT
    customer_id,
    customer_name,
    COALESCE(total_revenue, 0) AS total_revenue
FROM
    CustomerRevenue
ORDER BY
    total_revenue DESC;
    

-- Q 9. Utilize a CTE with a window function to rank films based on their rental duration from the film table.  
 
WITH RankedFilms AS (
    SELECT
        film_id,
        title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS rental_duration_rank
    FROM
        film
)

SELECT
    film_id,
    title,
    rental_duration,
    rental_duration_rank
FROM
    RankedFilms
ORDER BY
    rental_duration_rank;
    
    
-- Q 10. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 
-- Customer table to retrieve additional customer details.   

WITH CustomerRentals AS (
    SELECT
        customer_id,
        COUNT(rental_id) AS rental_count
    FROM
        rental
    GROUP BY
        customer_id
    HAVING
        COUNT(rental_id) > 2
)

SELECT
    c.*,
    cr.rental_count
FROM
    customer c
JOIN
    CustomerRentals cr ON c.customer_id = cr.customer_id
ORDER BY
    cr.rental_count DESC;
    
    
-- Q 11. Write a query using a CTE to find the total number of rentals made each month, considering the from the rental table.    

WITH MonthlyRentals AS (
    SELECT
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(rental_id) AS total_rentals
    FROM
        rental
    GROUP BY
        rental_month
)

SELECT
    rental_month,
    total_rentals
FROM
    MonthlyRentals
ORDER BY
    rental_month;
    
    
-- Q 12. Use a CTE to pivot the data from the payment table to display the total payments made by each customer in
-- separate columns for different payment methods.    

-- > Since, we dont have payment method column or any  column that specify payment type we calculate total payments made by each customer ;
WITH CustomerPayments AS (
    SELECT
        customer_id,
        SUM(amount) AS total_payments
    FROM
        payment
    GROUP BY
        customer_id
)

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cp.total_payments
FROM
    customer c
JOIN
    CustomerPayments cp ON c.customer_id = cp.customer_id;
    
    
-- Q 13. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table. 

WITH ActorPairs AS (
    SELECT
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id,
        COUNT(*) AS films_together
    FROM
        film_actor fa1
        JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
    GROUP BY
        fa1.actor_id, fa2.actor_id
    HAVING
        COUNT(*) > 0
)

SELECT
    ap.actor1_id,
    ap.actor2_id,
    ap.films_together
FROM
    ActorPairs ap;
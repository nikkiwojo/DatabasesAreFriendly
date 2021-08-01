/* SQL "Sakila" database query exercises - phase 1 */

-- Database context
USE sakila;

-- Your solutions...
/* i. Which actors have the first name 'Scarlett'? */
SELECT * FROM actor WHERE first_name = 'Scarlett';

/* ii. Which actors have the last name 'Johansson"? */
SELECT * FROM actor WHERE last_name = 'Johansson';

/* iii. How many distinct actors last names are there? */
SELECT count(distinct(last_name)) FROM actor;

/* iv. Which last names are not repeated? */
SELECT last_name, count(last_name) FROM actor GROUP BY last_name HAVING count(last_name) = 1;

/* v. Which last names appear more than once? */
SELECT last_name, count(last_name) FROM actor GROUP BY last_name HAVING count(last_name) > 1;

/* vi. Which actor has appeared in the most films? */
SELECT a.first_name, a.last_name, a.actor_id, count(fa.film_id) FROM actor AS a 
JOIN film_actor AS fa ON a.actor_id = fa.actor_id 
GROUP BY fa.actor_id 
ORDER BY count(fa.actor_id) DESC LIMIT 1;

/* vii. Is "Academy Dinosaur" available for rent from Store 1? */
SELECT f.title, f.film_id, i.film_id, i.store_id, i.inventory_id FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
WHERE f.title LIKE "ACADEMY DINOSAUR" AND store_id LIKE "1"; 

SELECT i.inventory_id, r.inventory_id, r.return_date, r.rental_date FROM inventory AS i
JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE i.inventory_id IN (1,2,3,4)
AND r.rental_date < r.return_date;

/* viii. Insert a record to represent Mary Smith renting 'Academy Dinosaur' from Mike Hillyer at Store 1 today */
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (CURRENT_TIMESTAMP, 1, 1, 1);

/* ix. When is Academy Dinosaur due? */
SELECT rental_duration FROM film WHERE title LIKE "Academy Dinosaur";

/* x. What is the average running time of all the films in the sakila DB? */
SELECT avg(length) FROM film;

/* xi. What is the average running time of films by category? */
SELECT fc.category_id, fc.film_id, f.film_id, avg(f.length), c.name, c.category_id FROM film_category AS fc
JOIN film AS f ON fc.film_id = f.film_id
JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg(f.length) DESC;

/* xii. Why does this query return the empty set? */
SELECT * FROM film NATURAL JOIN inventory;
-- This query returns the empty set because a natural join is used to match rows,
-- film and inventory do not have any rows in common.




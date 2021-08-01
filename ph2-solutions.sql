/* SQL "Sakila" database query exercises - phase 1 */

-- Database context
USE sakila;

-- Your solutions...
/* 1a. Display the first and last names of all actors from the table actor. */
SELECT first_name, last_name FROM actor;

/* 1b. Display the first/last name of each actor in single column in upper case letters. Name the column Actor Name. */
SELECT CONCAT(first_name, " ", last_name) AS "Actor Name" FROM actor; 

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." */
SELECT actor_id, first_name, last_name FROM actor WHERE first_name LIKE "Joe";

/* 2b. Find all actors whose last name contain the letters GEN */
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";

/* 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name. */
SELECT first_name, last_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name;

/* 2d. Using in, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China */
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

/* 3a. Add a middle_name column to the table actor. Position it between first_name and last_name */
ALTER TABLE actor ADD middle_name varchar(100);
SELECT first_name, middle_name, last_name FROM actor;

/* 3b. Change the data type of the middle_name column to blobs */
ALTER TABLE actor MODIFY COLUMN middle_name tinyblob;

/* 3c. Now delete the middle_name column */
ALTER TABLE actor DROP middle_name;

/* 4a. List the names of actors, as well as how many actors have that last name. */
SELECT last_name, count(last_name) FROM actor GROUP BY last_name;

/* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors. */
SELECT last_name, count(last_name) FROM actor GROUP BY last_name HAVING count(last_name) > 1;

/* 4c. The actor Harpo Williams was accidentally entered as Groucho Williams. Fix it. */
UPDATE actor SET first_name = 'HARPO' WHERE first_name LIKE 'GROUCHO' AND last_name = 'Williams';

/* 4d. If the first name is currently harpo, change it to groucho. Otherwise, change the first name to mucho groucho*/
UPDATE actor SET first_name = 
CASE 
	WHEN first_name = 'HARPO' THEN 'Groucho'
    ELSE 'Mucho Groucho'
END
WHERE actor_id = 172;

/* 5a. You cannot locate the schema of the address table. */
SHOW CREATE TABLE address; 

/* 6a. Display the first names, last names, and addresses of each staff member. */
SELECT s.address_id, s.first_name, s.last_name, a.address_id, a.address, a.address2 FROM staff AS s
JOIN address AS a ON s.address_id = a.address_id;

/* 6b. Display the total amount rung up by each staff member in August of 2005. */
SELECT sum(p.amount), p.staff_id, p.payment_date, s.staff_id, s.first_name, s.last_name FROM payment AS p
JOIN staff AS s ON p.staff_id = s.staff_id
GROUP BY p.staff_id, p.payment_date, s.staff_id, s.first_name, s.last_name
HAVING p.payment_date LIKE '2005-08-%';

/* 6c. List each film and the number of actors who are listed for that film. */
SELECT f.film_id, f.title, sum(fa.actor_id), fa.film_id FROM film AS f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title, fa.film_id;

/* 6d. How many copies of the film Hunchback Impossible exist in the inventory system? */
SELECT i.inventory_id, i.film_id, f.film_id, f.title FROM inventory AS i
JOIN film AS f ON i.film_id = f.film_id
WHERE f.title = 'hunchback impossible';

/* 6e. List the total paid by each customer. List the customers alphabetically by last name. */
SELECT sum(p.amount), p.customer_id, c.customer_id, c.first_name, c.last_name FROM payment AS p
JOIN customer AS c ON p.customer_id = c.customer_id
GROUP BY p.customer_id, c.customer_id, c.first_name, c.last_name
ORDER BY c.last_name ASC;

/* 7a. Display the titles of movies starting with the letters K and Q whose language is English. */ 
SELECT l.language_id, l.name, f.language_id, f.title FROM language AS l
JOIN film AS f ON l.language_id = f.language_id
WHERE f.title LIKE 'K%' OR 'Q%';

/* 7b. Display all actors who appear in the film Alone Trip. */
SELECT fa.actor_id, fa.film_id, a.actor_id, a.first_name, a.last_name FROM film_actor AS fa
JOIN actor AS a ON fa.actor_id = a.actor_id
WHERE fa.film_id = 17; 

/* 7c. You will need the names and email addresses of all Canadian customers. */
SELECT city.country_id, city.city_id, address.city_id, address.address_id, customer.email FROM city
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
WHERE city.country_id = 20;

/* 7d. Identify all movies categorized as family films. */
SELECT c.category_id, c.name, fc.film_id, fc.category_id, f.film_id, f.title FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN film AS f ON fc.film_id = f.film_id
WHERE c.name = 'Family';

/* 7e. Display the most frequently rented movies in descending order. */
SELECT r.inventory_id, count(r.rental_date), i.inventory_id, i.film_id, f.film_id, f.title FROM rental AS r
JOIN inventory AS i ON r.inventory_id = i.inventory_id
JOIN film AS f ON i.film_id = f.film_id
GROUP BY r.inventory_id, i.inventory_id, i.film_id, f.film_id, f.title
ORDER BY count(r.rental_date) DESC;

/* 7f. Write a query to display how much business, in dollars, each store brought in. */
SELECT s.store_id, s.manager_staff_id, r.staff_id, r.rental_id, p.rental_id, sum(p.amount) FROM store AS s
JOIN rental AS r ON s.manager_staff_id = r.staff_id
JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY s.store_id, s.manager_staff_id, r.staff_id, r.rental_id, p.rental_id
ORDER BY sum(p.amount);

/* 7g. Write a query to display for each store its store ID, city, and country */
SELECT c.country, city.city, s.store_id FROM country AS c
JOIN city ON c.country_id = city.country_id
JOIN address AS a ON city.city_id = a.city_id
JOIN store AS s ON a.address_id = s.address_id;

/* 7h. List the top five genres in gross revenue in descending order. */
SELECT c.name AS "Genres", sum(p.amount) AS "Amount" FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN inventory AS i ON fc.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC LIMIT 5;

/* 8a. Create a view for the problem above. */
CREATE VIEW top_five AS
SELECT c.name AS "Genres", sum(p.amount) AS "Amount" FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN inventory AS i ON fc.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY sum(p.amount) DESC LIMIT 5;

/* 8b. How would you display the view that you created in 8a? */
SELECT * FROM top_five;

/* 8c. Write a query to delete the view you just created. */
DROP VIEW top_five; 





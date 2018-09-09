USE sakila;

SELECT first_name, last_name FROM actor;

SELECT CONCAT_WS (" ", first_name, last_name) AS ActorName FROM actor;

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

SELECT last_name FROM actor WHERE last_name LIKE '%gen%';

SELECT first_name, last_name FROM actor WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name;

SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor ADD middle_name VARCHAR(200);
SELECT first_name, middle_name, last_name From actor;

ALTER TABLE actor CHANGE middle_name blobs varchar(200);

ALTER TABLE actor DROP COLUMN middle_name;

SELECT last_name, COUNT(*) as name_count FROM actor GROUP BY last_name ORDER BY name_count DESC;

SELECT last_name, COUNT(*) as name_count FROM actor GROUP BY last_name HAVING name_count > 1 ORDER BY name_count DESC;

UPDATE actor SET `first_name` = "HARPO" WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

UPDATE actor SET `first_name` = "GROUCHO" WHERE actor_id = 172;
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id = 172;

SELECT * FROM `INFORMATION_SCHEMA`.`TABLES`
WHERE TABLE_NAME LIKE 'address';

CREATE TABLE address_new LIKE address;
INSERT INTO address_new SELECT * FROM address;

SELECT staff.first_name, staff.last_name, address.address 
FROM staff JOIN address 
ON staff.address_id = address.address_id;

SELECT last_name, first_name, SUM(amount) AS staff_total
FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.staff_id;

SELECT last_name, COUNT(*) as name_count FROM actor GROUP BY last_name ORDER BY name_count DESC;
SELECT staff.first_name, staff.last_name, address.address 
FROM staff JOIN address 
ON staff.address_id = address.address_id;

SELECT COUNT(*) AS Title_Count
FROM inventory
WHERE film_id IN 
	(
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible'
    );
    
SELECT first_name, last_name, SUM(amount) AS Cust_Total 
FROM payment INNER JOIN customer
ON customer.customer_id = payment.customer_id GROUP BY last_name, first_name;

SELECT title
FROM film
WHERE ((title LIKE "K%") OR (title LIKE "Q%")) AND title IN
	(
	SELECT title 
    FROM film 
	WHERE language_id IN 
		(
		SELECT language_id FROM language
		WHERE name = "English"));
        
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
		SELECT actor_id
		FROM film_actor
		WHERE film_id IN
		(
			SELECT film_id 
			FROM film 
			WHERE title = 'Alone Trip'
		 ));
   
   
SELECT first_name, last_name, address, email, country
FROM (((address INNER JOIN customer ON address.address_id = customer.address_id)
	JOIN city ON address.city_id = city.city_id) 
	JOIN country ON country.country_id = city.country_id) WHERE country = "Canada";
    
SELECT title, description
FROM film
WHERE film_id IN
	(
    SELECT film_id
	FROM film_category
	WHERE category_id IN
		(
		SELECT category_id 
		FROM category
		WHERE name = 'Family'
			));
	
CREATE TABLE film_rentals (SELECT film_id, SUM((SELECT COUNT(inventory_id)
FROM rental
WHERE rental.inventory_id = inventory.inventory_id)) AS total_rentals
FROM inventory GROUP BY film_id
ORDER BY total_rentals DESC);
SELECT title, total_rentals FROM film_rentals INNER JOIN film ON film_rentals.film_id = film.film_id; 

SELECT store.store_id, COUNT(payment.payment_id) payment_count, SUM(payment.amount) AS total_amount FROM store 
	JOIN inventory  ON store.store_id = inventory.store_id
    JOIN rental  ON inventory.inventory_id = rental.inventory_id
    JOIN payment  ON rental.rental_id = payment.rental_id
GROUP BY store.store_id;

SELECT store_id, city, country
FROM (((store INNER JOIN address ON store.address_id = address.address_id 
	JOIN city ON city.city_id = address.city_id 
	JOIN country ON city.country_id = country.country_id)));
    
SELECT category.name, SUM(payment.amount) AS gross_revenue FROM category
	JOIN film_category ON film_category.category_id = category.category_id
    JOIN inventory ON inventory.film_id = film_category.film_id
    JOIN rental ON rental.inventory_id = inventory.inventory_id
    JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY gross_revenue DESC 
LIMIT 5;

CREATE VIEW Top_5_Genres AS
	SELECT category.name, SUM(payment.amount) AS gross_revenue FROM category
		JOIN film_category ON film_category.category_id = category.category_id
		JOIN inventory ON inventory.film_id = film_category.film_id
		JOIN rental ON rental.inventory_id = inventory.inventory_id
		JOIN payment ON payment.rental_id = rental.rental_id
		GROUP BY category.name
	ORDER BY gross_revenue DESC 
	LIMIT 5;
    
SELECT * FROM Top_5_Genres;

DROP VIEW IF EXISTS Top_5_Genres;
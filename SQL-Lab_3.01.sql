# SQL - Lab 3.01

# 1. Drop column picture from staff.

USE sakila;


SELECT * 
from sakila.staff
;

ALTER TABLE staff
DROP COLUMN picture
;

SELECT * 
from staff
;

# 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly. 

SELECT * 
from sakila.staff
;


SELECT *
FROM sakila.customer
WHERE CONCAT(first_name,' ', last_name ) = 'TAMMY SANDERS'
;

INSERT INTO staff(staff_id,first_name,last_name,address_id,email,store_id,active,username,last_update) -- explicitly avoiding password column
VALUES
(3,'TAMMY','SANDERS',79,'TAMMY.SANDERS@sakilastaff.com',2,1,'Tammy',current_date())
;



-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you  would need to add there. You can query those pieces of information. 
-- For eg., you would notice that you need customer_id information as well. To get that you can use the following query:

SELECT customer_id
FROM sakila.customer
WHERE CONCAT(first_name,' ', last_name) = 'CHARLOTTE HUNTER'
;

SELECT *
FROM sakila.customer
WHERE first_name = 'mike'
;

SELECT *
FROM sakila.rental
;

SELECT f.film_id
		, i.inventory_id
FROM sakila.film f
	JOIN sakila.inventory i
    USING (film_id)
WHERE f.title = 'Academy Dinosaur'
	AND store_id = (SELECT store_id
					FROM sakila.staff
					WHERE first_name = 'Mike'
                    )
;

SELECT inventory_id -- Query to see what copies of the film are currently available in the store 1
FROM sakila.rental
WHERE inventory_id IN (
						(SELECT i.inventory_id
						FROM sakila.film f
							JOIN sakila.inventory i
								USING (film_id)
						WHERE f.title = 'Academy Dinosaur'
							AND store_id = (SELECT store_id
											FROM sakila.staff
											WHERE first_name = 'Mike'
                                            )
						)
					  )
	AND rental_date <= current_date()
    AND (return_date < current_date()
		OR return_date IS NOT NULL)
GROUP BY inventory_id
;

-- to get the last rental_id in oroder to input new rental ID
SELECT MAX(rental_id)
FROM sakila.rental
;

-- validation
INSERT INTO rental(rental_id, rental_date, inventory_id, customer_id, staff_id, last_update)
VALUES
((16049+1), current_date(), 1, 130, 1, current_date())
;

SELECT *
FROM sakila.rental
WHERE CONVERT(rental_date, DATE)= current_date()
;


CREATE DATABASE sakila_test;
# mysqldump sakila | mysql sakila_test

-- 2. Activity-2 , 
-- Excercise-1

# We have identified that the primary keys have been correctly assigned. 
# As well as the structural integrity of the relationships between primary and foreign keys as have been restrained.

USE information_schema;

SELECT table_name
		, referenced_table_name
FROM REFERENTIAL_CONSTRAINTS
WHERE UNIQUE_CONSTRAINT_SCHEMA = 'sakila';

SELECT film_id
		, COUNT(category_id) AS c_count
FROM sakila.film_category
GROUP BY film_id
-- having c_count > 1
ORDER BY c_count DESC
;





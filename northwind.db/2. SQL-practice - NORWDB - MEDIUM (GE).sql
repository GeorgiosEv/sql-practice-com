/* EXERCISE 1
Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table. */
SELECT 
	pr.product_name,
    sup.company_name,
    cat.category_name
FROM categories AS cat
JOIN products AS pr ON cat.category_id = pr.category_id
JOIN suppliers AS sup ON pr.supplier_id = sup.supplier_id;

/* EXERCISE 2
Show the category_name and the average product unit price for each category rounded to 2 decimal places. */
SELECT
	cat.category_name,
    ROUND(AVG(pr.unit_price), 2) AS average_unit_price
FROM categories AS cat
JOIN products AS pr ON cat.category_id = pr.category_id
GROUP BY cat.category_name;

/* EXERCISE 3
Show the city, company_name, contact_name from the customers and suppliers table merged together.
Create a column which contains 'customers' or 'suppliers' depending on the table it came from. */
SELECT city, company_name, contact_name, 'customers' AS relationship
FROM customers
UNION ALL
SELECT city, company_name, contact_name, 'suppliers' AS relationship
FROM suppliers
-- NOTE: As the exercise did not define whether it required including the duplicates, I used UNION ALL. You can still use UNION and get rid of the duplicate records; the result will be the same.

/* EXERCISE 4
Show the total amount of orders for each year/month. */
SELECT
	YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS no_of_orders
FROM orders
GROUP BY order_year, order_month;
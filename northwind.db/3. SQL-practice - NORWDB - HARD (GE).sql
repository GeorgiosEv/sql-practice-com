/* EXERCISE 1
Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late, "Not Shipped" if shipped_date is null.
Order by employee last_name, then by first_name, and then descending by number of orders.*/
SELECT 
	emp.first_name,
    emp.last_name,
    COUNT(ord.order_id) AS num_orders, -- COUNT(*) works fine here as well
    (CASE
     	WHEN ord.shipped_date <= ord.required_date THEN 'On Time'
     	WHEN ord.shipped_date > ord.required_date THEN 'Late'
     	WHEN ord.shipped_date IS NULL THEN 'Not Shipped'
    	END) AS shipped
FROM employees AS emp
JOIN orders AS ord ON emp.employee_id = ord.employee_id
GROUP BY emp.first_name, emp.last_name, shipped
ORDER BY emp.last_name, emp.first_name, num_orders DESC;

/* EXERCISE 2
Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places. */
SELECT
	DISTINCT YEAR(ord.order_date) AS order_year,
    ROUND(SUM(pr.unit_price * ord_d.quantity * ord_d.discount), 2) AS discount_amount
FROM orders AS ord
JOIN order_details AS ord_d ON ord.order_id = ord_d.order_id
JOIN products AS pr ON ord_d.product_id = pr.product_id
GROUP BY order_year
ORDER BY order_year DESC;
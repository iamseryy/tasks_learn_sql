/*
1. Используя операторы языка SQL, 
создайте таблицу “sales”. Заполните ее данными.
*/

DROP DATABASE IF EXISTS task_2;
CREATE DATABASE task_2;
USE task_2;

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	id SERIAL PRIMARY KEY,
	order_date  DATE NOT NULL,
	count_product  INT
);

INSERT INTO `sales` (order_date, count_product)
VALUES 
('2022-01-01', 156),
('2022-01-02', 180),
('2022-01-03', 21),
('2022-01-04', 124),
('2022-01-05', 341);

/*
2.  Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва : 
меньше 100  -    Маленький заказ
от 100 до 300 - Средний заказ
больше 300  -     Большой заказ
*/

SELECT 
	id AS 'id заказа',
    (
		CASE
			WHEN count_product < 100 THEN 'Маленький заказ'
            WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
            WHEN count_product > 300 THEN 'Большой заказ'
		END
    ) AS 'Тип заказа'
FROM sales;

/*
3. Создайте таблицу “orders”, заполните ее значениями
*/

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
	employee_id VARCHAR(10) NOT NULL,
	amount DECIMAL(20, 2),
    order_status ENUM('OPEN', 'CLOSED', 'CANCELLED') NOT NULL
);

INSERT INTO `orders` (employee_id, amount, order_status)
VALUES 
('e03', 15.00, 1),
('e01', 25.50, 1),
('e05', 100.70, 2),
('e02', 22.18, 1),
('e04', 9.50, 3);

/*
3.1. Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED -  «Order is cancelled»
*/

SELECT 
	id,
    employee_id,
    amount,
    order_status,
    (
		CASE
			WHEN order_status = 1 THEN 'Order is in open state'
            WHEN order_status = 2 THEN 'Order is closed'
            WHEN order_status = 3 THEN 'Order is cancelled'
        END
    ) AS full_order_status
FROM orders;

/*
Чем 0 отличается от NULL?
	- NULL - это специальное значение, которое используется для обозначения отсутсвия данных, 
			т.е отсутствие какого-либо значения в ячейке
	- 0 - это нулевое значение  
*/
    

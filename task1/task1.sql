DROP DATABASE IF EXISTS task_1;
CREATE DATABASE task_1;
USE task_1;

/*
	1. Создайте таблицу с мобильными телефонами. 
    Заполните БД данными (поля и наполнение см. в презентации)
*/
CREATE TABLE mobile_phones
(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    product_name VARCHAR(20) NOT NULL,
    manufacturer VARCHAR(20) NOT NULL,
    product_count INT,
    price INT 
);

INSERT INTO mobile_phones (product_name, manufacturer, product_count, price)
VALUES 
('iPhone X', 'Apple', 3, 76000),
('iPhone 8', 'Apple', 2, 51000),
('Galaxy S9', 'Samsung', 2, 56000),
('Galaxy S8', 'Samsung', 1, 41000),	
('P20 Pro', 'Huawei', 5, 36000);

-- 2. Выведите название, производителя и цену для товаров, количество которых превышает 2
SELECT manufacturer, price 
FROM mobile_phones
WHERE product_count > 2;

-- 3. Выведите весь ассортимент товаров марки “Samsung”
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones
WHERE manufacturer = 'Samsung';

-- 4.  С помощью регулярных выражений найти:
-- 4.1. Товары, в которых есть упоминание "Iphone"
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones
WHERE product_name like '%Iphone%'
	OR manufacturer like '%Iphone%'; 

-- 4.2. Товары, в которых есть упоминание"Samsung"
SELECT id, product_name, manufacturer, product_count, price 
FROM mobile_phones
WHERE product_name like '%Samsung%'
	OR manufacturer like '%Samsung%'; 

-- 4.3. Товары, в которых есть ЦИФРЫ

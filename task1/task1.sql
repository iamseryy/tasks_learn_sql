CREATE SCHEMA IF NOT EXISTS `task1`;

USE task1;

CREATE TABLE mobile_phones
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(20) NOT NULL,
    manufacturer VARCHAR(20) NOT NULL,
    product_count INT,
    price INT 
);
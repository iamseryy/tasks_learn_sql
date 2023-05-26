/*
Работаем с таблицей staff (скрипт создания в материалах к уроку)
*/

DROP DATABASE IF EXISTS task_3;
CREATE DATABASE task_3;
USE task_3;

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (
	id INT AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(45),
	lastname VARCHAR(45),
	post VARCHAR(100),
	seniority INT, 
	salary INT, 
	age INT
);

-- Наполнение данными
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', '40', 100000, 60),
('Петр', 'Власов', 'Начальник', '8', 70000, 30),
('Катя', 'Катина', 'Инженер', '2', 70000, 19),
('Саша', 'Сасин', 'Инженер', '12', 50000, 35),
('Иван', 'Иванов', 'Рабочий', '40', 30000, 59),
('Петр', 'Петров', 'Рабочий', '20', 25000, 40),
('Сидр', 'Сидоров', 'Рабочий', '10', 20000, 35),
('Антон', 'Антонов', 'Рабочий', '8', 19000, 28),
('Юрий', 'Юрков', 'Рабочий', '5', 15000, 25),
('Максим', 'Максимов', 'Рабочий', '2', 11000, 22),
('Юрий', 'Галкин', 'Рабочий', '3', 12000, 24),
('Людмила', 'Маркина', 'Уборщик', '10', 10000, 49);

/*
1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания 
*/

-- в порядке убывания
SELECT firstname, lastname, post, seniority, salary, age
FROM staff
ORDER BY salary DESC;

-- в порядке возрастания
SELECT firstname, lastname, post, seniority, salary, age
FROM staff
ORDER BY salary;

/*
2. Выведите 5 максимальных заработных плат (salary)
*/

SELECT DISTINCT salary
FROM staff
ORDER BY salary DESC
LIMIT 5;

/*
3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
*/

SELECT 
	post, 
    SUM(salary) AS total_salary
FROM staff
GROUP BY post;

/*
4. Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
*/

SELECT COUNT(id) AS staff_count
FROM staff
WHERE 
	post = 'Рабочий'
    and age BETWEEN 24 AND 49;

/*
5. Найдите количество специальностей
*/

SELECT COUNT(DISTINCT post) AS post_count
FROM staff;

/*
6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет 
*/

SELECT 
	post,
    AVG(age) AS avg_age
FROM staff
GROUP BY post
HAVING avg_age < 30;

-- или если только вывести одно поле post
-- вариант 1
SELECT post
FROM 
	(
		SELECT 
			staff_sub.post AS post,
			AVG(staff_sub.age) AS avg_age
		FROM staff AS staff_sub
		GROUP BY post
		HAVING avg_age < 30
	) AS post_list;
    
-- вариант 2
SELECT DISTINCT staff_main.post
FROM staff AS staff_main
WHERE EXISTS ( 
				SELECT AVG(staff_sub.age) AS avg_age
				FROM staff AS staff_sub
				WHERE staff_sub.post = staff_main.post
                HAVING avg_age < 30
            );


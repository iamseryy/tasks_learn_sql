USE lesson_4;

/*
1. Создайте таблицу users_old, аналогичную таблице users. 
Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old. 
(использование транзакции с выбором commit или rollback – обязательно).
*/

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE);
    
DROP PROCEDURE IF EXISTS sp_set_user_old; 
DELIMITER //
CREATE PROCEDURE sp_set_user_old(user_id BIGINT, OUT tran_result varchar(100))
proc_label: BEGIN
	DECLARE `_rollback` BIT DEFAULT b'0';
    DECLARE code varchar(100);
	DECLARE error_string varchar(100); 
    DECLARE id_old BIGINT;
    DECLARE firstname_old VARCHAR(50);
    DECLARE lastname_old VARCHAR(50);
    DECLARE email_old VARCHAR(120);
    
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		SET `_rollback` = b'1';
 		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    END;

	SELECT 
		id, firstname, lastname, email 
        INTO id_old, firstname_old, lastname_old, email_old
    FROM users
    WHERE users.id = user_id;
	
    IF id_old IS NULL THEN
		SET tran_result = CONCAT('Ошибка: ', 'PE-999', ' Текст ошибки: ', 'Пользователь не найден');
        LEAVE proc_label;
	END IF;

    START TRANSACTION;
	INSERT INTO users_old (id, firstname, lastname, email)
	VALUE(id_old, firstname_old, lastname_old, email_old);
    
	DELETE FROM users WHERE users.id = user_id;

    IF `_rollback` THEN
		SET tran_result = CONCAT('Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = 'O K';
		COMMIT;
	END IF;
END//

DELIMITER ;

CALL sp_set_user_old(9, @tran_result); 
SELECT @tran_result;
 

/*
2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS  VARCHAR(50) NO SQL 
BEGIN
	DECLARE current_hour INT;
    SET  current_hour = HOUR(CURTIME());
	CASE
		WHEN current_hour BETWEEN 0 AND 5 THEN RETURN 'Доброй ночи';
		WHEN current_hour BETWEEN 6 AND 11 THEN RETURN 'Доброе утро';
		WHEN current_hour BETWEEN 12 AND 17 THEN RETURN 'Добрый день';
		WHEN current_hour BETWEEN 18 AND 23 THEN RETURN 'Добрый вечер';
	END CASE;
END//
DELIMITER ;

SELECT hello();

/*
3. (по желанию)* Создайте таблицу logs типа Archive. 
Пусть при каждом создании записи в таблицах users, 
communities и messages в таблицу logs помещается время и дата создания записи, 
название таблицы, идентификатор первичного ключа.
*/

DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
	created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    table_name VARCHAR(50),
	entity_id INT UNSIGNED NOT NULL
) ENGINE=ARCHIVE;

DROP PROCEDURE IF EXISTS add_to_logs; 
DELIMITER //
CREATE PROCEDURE add_to_logs(table_name VARCHAR(50), entity_id INT)
BEGIN
	INSERT INTO logs (table_name, entity_id) VALUES (table_name, entity_id);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS add_user_to_log;
DELIMITER //
CREATE TRIGGER add_user_to_log AFTER INSERT ON users
FOR EACH ROW
BEGIN
	CALL add_to_logs('users', NEW.id);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS add_community_to_log;
DELIMITER //
CREATE TRIGGER add_community_to_log AFTER INSERT ON communities
FOR EACH ROW
BEGIN
	CALL add_to_logs('communities', NEW.id);
END//
DELIMITER ;

DROP TRIGGER IF EXISTS add_message_to_log;
DELIMITER //
CREATE TRIGGER add_message_to_log AFTER INSERT ON messages
FOR EACH ROW
BEGIN
	CALL add_to_logs('messages', NEW.id);
END//
DELIMITER ;

INSERT INTO users (firstname, lastname, email) VALUES
('Name1', 'Last name1', 'name1@test.org'),
('Name2', 'Last name2', 'name2@test.org');

INSERT INTO communities (name) VALUES 
('Test1'), 
('Test2');

INSERT INTO messages  (from_user_id, to_user_id, body, created_at) VALUES
(1, 2, 'Test1',  DATE_ADD(NOW(), INTERVAL 1 MINUTE)),
(2, 1, 'Test2',  DATE_ADD(NOW(), INTERVAL 3 MINUTE));
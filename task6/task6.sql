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
    


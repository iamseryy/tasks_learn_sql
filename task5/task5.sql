USE lesson_4;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.

CREATE OR REPLACE VIEW v_young_users AS
(
	SELECT 
		users.firstname, 
        users.lastname, 
        profiles.hometown, 
        profiles.gender
    FROM users
    JOIN profiles ON users.id = profiles.user_id
    WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) <= 20
);

SELECT * FROM v_young_users;


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


/*
2. Найдите кол-во,  отправленных сообщений каждым пользователем и  выведите 
ранжированный список пользователей, указав имя и фамилию пользователя, количество 
отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным 
количеством сообщений) . (используйте DENSE_RANK)
*/

-- вариант решения 1
WITH message_rating AS
( 
SELECT 
		CONCAT(users.firstname, ' ', users.lastname) AS user,
		COUNT(messages.id) AS total_messages
	FROM users
	LEFT JOIN messages ON users.id = messages.from_user_id 
	GROUP BY user
    ORDER BY total_messages
)
SELECT
	user,
    total_messages,
    DENSE_RANK() OVER(ORDER BY total_messages DESC) AS rating
FROM message_rating;

-- вариант решения 2
SELECT 
		CONCAT(users.firstname, ' ', users.lastname) AS user,
		COUNT(messages.id) AS total_messages,
        DENSE_RANK() OVER(ORDER BY COUNT(messages.id) DESC) AS rating
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id 
GROUP BY user
ORDER BY rating;


/*
3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления 
(created_at) и найдите разницу дат отправления между соседними сообщениями, 
получившегося списка. (используйте LEAD или LAG)
*/

-- вариант решения 1 - разница дат в днях, час., мин., сек.
WITH sorted_messages AS
( 
	SELECT
		id,
		from_user_id,
		to_user_id,
		body,
		created_at,
        TIMESTAMPDIFF(SECOND, LAG(created_at, 1, 0) OVER(ORDER BY created_at), created_at) AS diff_in_sec
	FROM messages
	ORDER BY created_at
)

SELECT
	id,
	from_user_id,
	to_user_id,
	body,
	created_at,
	CONCAT(	  FLOOR(TIME_FORMAT(SEC_TO_TIME(diff_in_sec), '%H') / 24), ' days ',
			  MOD(TIME_FORMAT(SEC_TO_TIME(diff_in_sec), '%H'), 24), 'h:',
			  FLOOR(MOD(diff_in_sec, 3600) / 60), 'm:',
			  MOD(diff_in_sec, 60), 's'
			) AS difference
FROM sorted_messages;

-- вариант решения 2 - разница дат в час., мин., сек.
SELECT
		id,
		from_user_id,
		to_user_id,
		body,
		created_at,
        SEC_TO_TIME(TIMESTAMPDIFF(SECOND, LAG(created_at, 1, 0) OVER(ORDER BY created_at), created_at)) AS difference
	FROM messages
	ORDER BY created_at;
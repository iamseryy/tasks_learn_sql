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


WITH message_rating AS
( 
SELECT 
		CONCAT(users.firstname, ' ', users.lastname) AS user,
		COUNT(messages.id) AS total_messeges
	FROM users
	LEFT JOIN messages ON users.id = messages.from_user_id 
	GROUP BY user
    ORDER BY total_messeges
)
SELECT
	user,
    total_messeges,
    DENSE_RANK() OVER(ORDER BY total_messeges DESC) AS rating
FROM message_rating;


/*
3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления 
(created_at) и найдите разницу дат отправления между соседними сообщениями, 
получившегося списка. (используйте LEAD или LAG)
*/
WITH sorted_messages AS
( 
	SELECT
		id,
		from_user_id,
		to_user_id,
		body,
		created_at,
		LAG(created_at, 1, 0) OVER(ORDER BY created_at) AS prev_created_at,
		LEAD(created_at, 1, 0) OVER(ORDER BY created_at) AS last_created_at
	FROM messages
	ORDER BY created_at
)

SELECT
		id,
		from_user_id,
		to_user_id,
		body,
		created_at,
        TIMESTAMPDIFF(SECOND, prev_created_at, created_at) AS prev_diff,
        TIMESTAMPDIFF(SECOND, created_at, last_created_at) AS last_diff
FROM sorted_messages
;



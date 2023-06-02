-- Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
USE task_4;

SELECT COUNT(likes.id) AS likes
FROM likes
WHERE 
	likes.user_id IN (
			SELECT profiles.user_id
            FROM profiles
            WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) < 12
    );


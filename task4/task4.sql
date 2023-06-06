USE task_4;


-- 1. Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT COUNT(likes.id) AS 'Total likes received by users under 12'
FROM likes
WHERE 
	likes.media_id IN (	
		SELECT 	media.id
		FROM media
		JOIN profiles ON media.user_id = profiles.user_id
		WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) < 12
	);
    
    
-- 2. Определить кто больше поставил лайков (всего): мужчины или женщины. 
SELECT 
	(
		CASE 
			WHEN (NOT EXISTS(SELECT likes.id FROM likes)) THEN 'no likes yet'
			WHEN (
					(	SELECT COUNT(likes.id)
						FROM likes
						JOIN profiles ON likes.user_id = profiles.user_id
						WHERE profiles.gender = 'm') =
												(	SELECT COUNT(likes.id)
													FROM likes
													JOIN profiles ON likes.user_id = profiles.user_id
													WHERE profiles.gender = 'f')
			) THEN 'equally'
        
			WHEN (
					(	SELECT COUNT(likes.id) 
						FROM likes
						JOIN profiles ON likes.user_id = profiles.user_id
						WHERE profiles.gender = 'm') >
												(	SELECT COUNT(likes.id) 
													FROM likes
													JOIN profiles ON likes.user_id = profiles.user_id
													WHERE profiles.gender = 'f')
			) THEN 'man'
        
			ELSE 'woman'
        
	END) AS 'Who liked more: man or woman';


-- 3. Вывести всех пользователей, которые не отправляли сообщения.
SELECT CONCAT(users.firstname, ' ', users.lastname) AS 'Users who did not send messages'
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
WHERE messages.from_user_id is NULL;


-- 4. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.
SET @user := 1;

SELECT CONCAT(users.firstname, ' ', users.lastname) AS 'best friend'
FROM (
	SELECT 	
	COUNT(messages.id) AS count_mess, 
	messages.from_user_id AS id
	FROM messages
	WHERE 
		messages.to_user_id = @user
		AND messages.from_user_id IN (
										SELECT initiator_user_id AS id FROM friend_requests 
										WHERE target_user_id = @user AND status = 'approved'
										UNION
										SELECT target_user_id FROM friend_requests 
										WHERE initiator_user_id = @user AND status = 'approved'
									)
	GROUP BY messages.from_user_id
	HAVING count_mess = (
		SELECT MAX(count_mess)
		FROM (
			SELECT
				COUNT(messages.id) AS count_mess, 
				messages.from_user_id as friend
			FROM messages
			WHERE
				messages.to_user_id = @user
				AND messages.from_user_id IN (
												SELECT initiator_user_id AS id FROM friend_requests 
												WHERE target_user_id = @user AND status ='approved'
												UNION
												SELECT target_user_id FROM friend_requests 
												WHERE initiator_user_id = @user AND status ='approved'
											)
			GROUP BY messages.from_user_id
		) AS friend_count_mess
	)
) AS best_friend
JOIN users ON best_friend.id = users.id;

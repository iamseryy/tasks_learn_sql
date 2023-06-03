USE task_4;

-- 1. Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
SELECT COUNT(likes.id) AS 'Total number of likes received by users under 12'
FROM likes
WHERE 
	likes.media_id IN (	
		SELECT 	media.id
		FROM media
		JOIN profiles ON media.user_id = profiles.user_id
		WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, NOW()) < 12
	);
    
-- 2.Определить кто больше поставил лайков (всего): мужчины или женщины. 
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
        
	END) AS 'Who liked more: man or woman'

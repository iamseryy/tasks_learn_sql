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



    


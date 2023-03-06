---
SELECT COUNT(id)
FROM stackoverflow.posts
WHERE post_type_id=1 
   AND (score>300 OR favorites_count >= 100)
GROUP BY post_type_id;

---
SELECT ROUND(AVG(t.count),0)
FROM (
      SELECT COUNT(id),
             creation_date::date
      FROM stackoverflow.posts
      WHERE post_type_id = 1
      GROUP BY creation_date::date
      HAVING creation_date::date BETWEEN '2008-11-01' AND '2008-11-18') AS t;

---
SELECT COUNT(DISTINCT u.id)
FROM stackoverflow.badges AS b
JOIN stackoverflow.users AS u ON b.user_id=u.id
WHERE b.creation_date::date = u.creation_date::date;

---
SELECT COUNT(DISTINCT p.id)
FROM stackoverflow.posts AS p
JOIN stackoverflow.users u ON p.user_id = u.id
JOIN stackoverflow.votes v ON p.id = v.post_id
WHERE u.display_name = 'Joel Coehoorn';

---
SELECT *,
RANK() OVER (ORDER BY id DESC)
FROM stackoverflow.vote_types
ORDER BY 1;

---
SELECT DISTINCT u.id, 
COUNT(v.id) OVER (PARTITION BY v.user_id)
FROM stackoverflow.votes v
JOIN stackoverflow.vote_types vt ON v.vote_type_id = vt.id
JOIN stackoverflow.users u ON v.user_id = u.id 
WHERE vt.name = 'Close'
ORDER BY 2 DESC, 
         1 DESC 
LIMIT 10;

---
SELECT DISTINCT b.user_id,
COUNT(b.id),
DENSE_RANK() OVER (ORDER BY COUNT(b.id) DESC)
FROM stackoverflow.badges AS b
WHERE DATE_TRUNC('day', creation_date)::date BETWEEN '2008-11-15' AND '2008-12-15'
GROUP BY 1
ORDER BY 2 DESC, 1 ASC
LIMIT 10;

---
SELECT title,
       user_id,
       score,
       ROUND(AVG(score) OVER (PARTITION BY user_id))
FROM stackoverflow.posts
WHERE title IS NOT NULL
AND score != 0;   

---
WITH list AS
(SELECT DISTINCT b.user_id,
COUNT(b.id)
FROM stackoverflow.badges as b
GROUP BY 1
HAVING COUNT(b.id) > 1000
ORDER BY COUNT(b.id) DESC)
SELECT p.title
FROM list as l
JOIN stackoverflow.posts as p ON p.user_id=l.user_id
WHERE p.title IS NOT NULL;

---
SELECT id,
       views,
       CASE 
         WHEN views >= 350 THEN 1
         WHEN views < 350 AND views >= 100 THEN 2
         WHEN views < 100 THEN 3
       END  
FROM stackoverflow.users AS u 
WHERE location LIKE '%United States%' AND views != 0;

---
WITH list AS
(SELECT u.id,
        u.views,
          CASE 
            WHEN views >= 350 THEN 1
            WHEN views < 350 AND views >= 100 THEN 2
            WHEN views < 100 THEN 3
          END as groupp  
FROM stackoverflow.users AS u 
WHERE location LIKE '%United States%' AND views != 0)
SELECT id, 
       groupp, 
       views 
FROM 
(SELECT id,
       MAX(views) OVER (PARTITION BY groupp) as max_views,
       views,
       groupp
FROM list) t 
WHERE max_views = views
ORDER BY views DESC, id asc;

---
SELECT DISTINCT EXTRACT(DAY FROM creation_date), 
       COUNT(id) OVER (PARTITION BY EXTRACT(DAY FROM creation_date)),
       COUNT(id) OVER (ORDER BY EXTRACT(DAY FROM creation_date))
FROM stackoverflow.users AS u
WHERE CAST(creation_date AS date) BETWEEN '2008-11-01' AND '2008-11-30';

---
SELECT DISTINCT p.user_id,
       FIRST_VALUE(p.creation_date) OVER (PARTITION BY p.user_id ORDER BY p.creation_date) - u.creation_date
FROM stackoverflow.posts p
JOIN stackoverflow.users u ON p.user_id = u.id;

---
SELECT DISTINCT DATE_TRUNC('month', creation_date)::date as dt,
SUM(views_count)
FROM stackoverflow.posts
WHERE DATE_TRUNC('month', creation_date)::date BETWEEN '2008-01-01' AND '2008-12-01'
GROUP BY dt
ORDER BY 2 DESC;

---
SELECT DISTINCT DATE_TRUNC('month', creation_date)::date as dt,
SUM(views_count)
FROM stackoverflow.posts
WHERE DATE_TRUNC('month', creation_date)::date BETWEEN '2008-01-01' AND '2008-12-01'
GROUP BY dt
ORDER BY 2 DESC;

---
WITH posts_number AS
(SELECT DISTINCT u.id
FROM stackoverflow.users u
JOIN stackoverflow.posts p ON u.id = p.user_id 
WHERE DATE_TRUNC('month', u.creation_date)::date = '2008-09-01' AND DATE_TRUNC('month', p.creation_date)::date = '2008-12-01')

SELECT DATE_TRUNC('month', p.creation_date)::date as post_month,
COUNT(p.id) AS posts_count
FROM posts_number pn
JOIN stackoverflow.posts p ON pn.id = p.user_id
WHERE DATE_TRUNC('month', p.creation_date)::date BETWEEN '2008-01-01' AND '2008-12-01'
GROUP BY post_month
ORDER BY post_month DESC;

---
SELECT user_id,
       creation_date,
       views_count,
       SUM(views_count) OVER (PARTITION BY user_id ORDER BY creation_date) as total_views
FROM stackoverflow.posts p
ORDER BY 1, 2;

---
WITH days AS
(SELECT user_id, DATE_TRUNC('day', creation_date)::date, COUNT(DATE_TRUNC('day', creation_date)::date) AS days_count 
FROM stackoverflow.posts p
WHERE DATE_TRUNC('day', creation_date)::date BETWEEN '2008.12.01' AND '2008.12.07'
GROUP BY 1, 2)
SELECT ROUND(AVG(days_count))
FROM days; 

---
SELECT EXTRACT(month FROM creation_date) as monthm, 
       COUNT(p.id) as cnt,
       ROUND(((COUNT(p.id)::numeric / LAG(COUNT(p.id), 1, NULL) OVER (ORDER BY EXTRACT(month FROM creation_date))) - 1) * 100, 2)
FROM stackoverflow.posts p 
WHERE DATE_TRUNC('month', p.creation_date)::date BETWEEN '2008-09-01' AND '2008-12-01'
GROUP BY monthm
ORDER BY monthm;

---
WITH post AS
(SELECT user_id, COUNT(id)
FROM stackoverflow.posts
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1)
SELECT DISTINCT EXTRACT(WEEK FROM creation_date),
       LAST_VALUE(creation_date) OVER (PARTITION BY EXTRACT(WEEK FROM creation_date))
FROM (SELECT EXTRACT(WEEK FROM creation_date),
      creation_date
FROM stackoverflow.posts p
JOIN post p2 ON p.user_id = p2.user_id
WHERE creation_date::date BETWEEN '2008-10-01' AND '2008-10-31'
ORDER BY 1,2) as post;

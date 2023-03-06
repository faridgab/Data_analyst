---
SELECT COUNT(id)
FROM company
WHERE status = 'closed';

---
SELECT SUM(funding_total) as fund
FROM company
WHERE category_code = 'news' AND country_code = 'USA'
GROUP BY name
ORDER BY fund DESC;

---
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash' 
      AND EXTRACT(YEAR FROM CAST(acquired_at AS date)) BETWEEN 2011 AND 2013;

---
SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%';

---
SELECT *
FROM people
WHERE (twitter_username LIKE 'money%' OR twitter_username LIKE '%money%' OR twitter_username LIKE '%money')
AND last_name LIKE 'K%';

---
SELECT country_code AS country,
       SUM(funding_total) AS fund
FROM company
GROUP BY country
ORDER BY fund DESC;

---
SELECT funded_at,
       MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round 
GROUP BY funded_at
HAVING MIN(raised_amount) <> 0
       AND MIN(raised_amount) <> MAX(raised_amount);

---
SELECT *,
       CASE
           WHEN invested_companies >= 100 THEN 'high_activity'
           WHEN invested_companies >= 20 AND invested_companies < 100 THEN 'middle_activity'
           WHEN invested_companies < 20 THEN 'low_activity'
       END
FROM fund;

---
SELECT
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity,
       ROUND(AVG(investment_rounds), 0) as rounds
FROM fund
GROUP BY activity
ORDER BY rounds ASC;

---
SELECT country_code,
       MIN(invested_companies),
       MAX(invested_companies),
       AVG(invested_companies)
FROM fund
WHERE EXTRACT(YEAR FROM CAST(founded_at AS date)) BETWEEN 2010 AND 2012
GROUP BY country_code
HAVING MIN(invested_companies) <> 0
ORDER BY AVG(invested_companies) DESC
LIMIT 10;

---
SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p
LEFT JOIN education AS e ON p.id = e.person_id;

---
select c.name,
       count(distinct e.instituition)
from company as c
join people as p ON c.id=p.company_id
join education as e ON p.id=e.person_id
group by c.name
order by count(distinct e.instituition) desc
limit 5;

---
SELECT DISTINCT p.id                                 
FROM company AS c
JOIN funding_round AS fc ON c.id=fc.company_id
JOIN people AS p ON c.id=p.company_id
WHERE (fc.is_first_round = 1 AND fc.is_last_round = 1) AND c.status = 'closed';

---
SELECT DISTINCT p.id,
                ed.instituition                                 
FROM company AS c
INNER JOIN funding_round AS fc ON c.id=fc.company_id
INNER JOIN people AS p ON c.id=p.company_id
INNER JOIN education AS ed ON p.id=ed.person_id
WHERE fc.is_first_round = 1 AND fc.is_last_round = 1 AND c.status = 'closed';

---
SELECT DISTINCT p.id,
                e.instituition
FROM company AS c
INNER JOIN people AS p ON c.id = p.company_id
LEFT JOIN education AS e ON p.id = e.person_id
WHERE c.status LIKE 'closed'
   AND c.id IN (SELECT company_id
                FROM funding_round
                WHERE is_first_round = 1
                   AND is_last_round = 1)
   AND  e.instituition IS NOT NULL;


---
SELECT DISTINCT p.id,
                COUNT(e.instituition)
FROM company AS c
INNER JOIN people AS p ON c.id = p.company_id
LEFT JOIN education AS e ON p.id = e.person_id
WHERE c.status LIKE 'closed'
  AND c.id IN (SELECT company_id
               FROM funding_round
               WHERE is_first_round = 1
                  AND is_last_round = 1)
  AND  e.instituition IS NOT NULL
GROUP BY p.id;

---
SELECT SUM(list.unv) / COUNT(list.id)
FROM 
(SELECT p.id AS id,
        COUNT(e.instituition) AS unv
FROM education AS e
LEFT JOIN people AS p ON e.person_id=p.id 
WHERE company_id IN 
(SELECT id
FROM company
WHERE id IN (SELECT company_id
FROM funding_round
WHERE is_first_round = 1 AND is_last_round = 1)
AND status = 'closed')
GROUP BY p.id) AS list;

---
SELECT SUM (count) / COUNT (person_id)
FROM (
      SELECT DISTINCT(e.person_id), COUNT(e.instituition)
      FROM people AS p
      LEFT OUTER JOIN education AS e ON p.id = e.person_id
      LEFT OUTER JOIN company AS c ON c.id = p.company_id
      WHERE c.name = 'Facebook'
      GROUP BY e.person_id
) AS inst;

---
SELECT f.name AS name_of_fund,
c.name AS name_of_company,
fr.raised_amount AS amount
FROM investment AS i
JOIN company AS c ON i.company_id=c.id
JOIN fund AS f ON i.fund_id=f.id
JOIN funding_round AS fr ON i.funding_round_id=fr.id
WHERE EXTRACT(YEAR FROM CAST(fr.funded_at AS DATE)) BETWEEN 2012 AND 2013
AND c.milestones>6;

---
SELECT b.name AS acquiring_company,
       a.price_amount,
       c.name AS acquired_company,
       c.funding_total,
       ROUND(a.price_amount/c.funding_total)
FROM acquisition AS a
LEFT JOIN company AS b ON a.acquiring_company_id=b.id
LEFT JOIN company AS c ON a.acquired_company_id=c.id
WHERE a.price_amount <> 0
AND c.funding_total <> 0
ORDER BY a.price_amount DESC, acquired_company
LIMIT 10;

---
SELECT c.name as company_name,
       EXTRACT(MONTH FROM CAST(fr.funded_at AS date))
FROM company AS c
JOIN funding_round AS fr ON c.id=fr.company_id
WHERE c.category_code = 'social' 
      AND (EXTRACT(YEAR FROM CAST(fr.funded_at AS date)) BETWEEN 2010 AND 2013) 
      AND fr.raised_amount <> 0;

---
WITH
fr AS (SELECT EXTRACT (MONTH FROM fr.funded_at) AS month,
       COUNT(fr.company_id),
       COUNT(DISTINCT(f.name)) AS f_name
       FROM funding_round AS fr
       LEFT JOIN investment AS i ON fr.id=i.funding_round_id
       LEFT JOIN fund AS f ON i.fund_id=f.id
       WHERE fr.funded_at BETWEEN '01.01.2010' AND '31.12.2013'
       AND f.country_code = 'USA'
       GROUP BY EXTRACT (MONTH FROM fr.funded_at)
       ORDER BY EXTRACT (MONTH FROM fr.funded_at)),
a AS (SELECT EXTRACT(MONTH FROM acquired_at) AS month,
       COUNT(id) AS cnt,
       SUM(price_amount) AS sm
       FROM acquisition
       WHERE EXTRACT(YEAR FROM acquired_at) BETWEEN 2010 AND 2013
       GROUP BY EXTRACT(MONTH FROM acquired_at)
       ORDER BY EXTRACT(MONTH FROM acquired_at))
SELECT fr.month,
       fr.f_name,
       a.cnt,
       a.sm
FROM fr LEFT JOIN a ON fr.month=a.month;


---
SELECT A.country_code, A.year_2011, B.year_2012, C.year_2013
from
(select avg(funding_total) as year_2011,
    country_code
    from company
    where extract(year from cast(founded_at as date))=2011
group by country_code) as A

INNER JOIN

(select avg(funding_total) as year_2012,
    country_code
    from company
    where extract(year from cast(founded_at as date))=2012
group by country_code) as B on
A.country_code=B.country_code

INNER JOIN 

(select avg(funding_total) as year_2013,
    country_code
    from company
    where extract(year from cast(founded_at as date))=2013
group by country_code) as C on 
A.country_code=C.country_code

order by A.year_2011 desc;

-- 1. С помощью SQL-запроса выведите названия ограничений первичных ключей.
select tc.table_name as "Название таблицы",
       tc.constraint_name as "Название ограничения",
       kc.column_name as "Название колонки"
from   information_schema.table_constraints tc
       inner join information_schema.key_column_usage kc on tc.constraint_name = kc.constraint_name  
where 
       tc.constraint_schema = 'public' and 
       tc.constraint_type = 'PRIMARY KEY' 
     
-- 2. Выведите уникальные названия городов из таблицы городов,
--    названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.
select distinct c.city  from city c
where c.city like 'L%a' and c.city NOT LIKE '% %'
order by c.city 

-- 3. Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--    в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--    и стоимость которых превышает 1.00.
--    Платежи нужно отсортировать по дате платежа.
select * from payment p
where p.payment_date :: date between '17/06/2005' and '19.06.2005' 
      and p.amount > 1.00
order by p.payment_date

-- 4. Выведите информацию о 10-ти последних платежах за прокат фильмов.
select * from payment p
order by p.payment_date desc
limit 10

-- 5. Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--  Каждой колонке задайте наименование на русском языке.
select concat_ws(' ',c.first_name,c.last_name) as "Фамилия и имя",
       c.email as "Электронная почта",
       length(c.email) as "Длина email", 
       date(c.last_update) as "Дата последнего обновления"
from customer c
     
-- 6. Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--    Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.
select lower(c.last_name) ,lower(c.first_name), c.active  
from customer c 
where c.active = 1 and (c.first_name = 'KELLY' or c.first_name = 'WILLIE')

-- 7. Выведите одним запросом информацию о фильмах, у которых рейтинг "R" 
--    и стоимость аренды указана от 0.00 до 3.00 включительно, 
--    а также фильмы c рейтингом "PG-13" и стоимостью аренды больше или равной 4.00.
select f.film_id , f.title , f.description , f.rating , f.rental_rate 
from film f 
where (f.rating = 'R' and f.rental_rate between 0.00 and 3.00) or 
      (f.rating = 'PG-13' and f.rental_rate >= 4.00)
      
-- 8. Получите информацию о трёх фильмах с самым длинным описанием фильма.
select f.film_id , f.title , f.description , length (f.description ) 
from film f 
order by length (f.description) desc
limit 3

-- 9. Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--    в первой колонке должно быть значение, указанное до @, 
--    во второй колонке должно быть значение, указанное после @.
--    Первая буква в новых колонках должна быть заглавной, остальные строчными.
select c.customer_id , c.email,
       initcap(split_part(c.email,'@', 1)) as "Email before @",
       initcap(split_part(c.email,'@', 2)) as "Email after @"
from customer c 




     
    








      
    
    



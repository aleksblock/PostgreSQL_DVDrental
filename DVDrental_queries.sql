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


-- 10. Выведите для каждого покупателя его адрес проживания, 
--    город и страну проживания.
select concat_ws(' ',c.last_name,c.first_name)  as "Имя покупателя",
       a.address, c2.city, c3.country  
from customer c
inner join address a on c.address_id  = a.address_id 
inner join city c2 on a.city_id  = c2.city_id 
inner join country c3 on c2.country_id = c3.country_id


-- 11. С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей,
--     у которых количество покупателей больше 300-от.
--     Для решения используйте фильтрацию по сгруппированным строкам 
--     с использованием функции агрегации.
select s.store_id , count(distinct c.customer_id) 
from store s
inner join customer c on s.store_id  = c.store_id
group by s.store_id 
having count(distinct c.customer_id) > 300


-- 12. Доработайте запрос 11,  добавив в него информацию о городе магазина, 
--     а также фамилию и имя продавца, который работает в этом магазине.
select s.store_id, count(distinct c.customer_id), c2.city, concat_ws(' ',s2.last_name ,s2.first_name)
from store s
inner join customer c on s.store_id  = c.store_id
inner join address a on s.address_id = a.address_id 
inner join city c2 on a.city_id  = c2.city_id 
inner join staff s2 on s.manager_staff_id = s2.staff_id 
group by s.store_id,c2.city,s2.staff_id  
having count(distinct c.customer_id) > 300


-- 13. Выведите ТОП-5 покупателей, 
--     которые взяли в аренду за всё время наибольшее количество фильмов
select concat_ws(' ',c.last_name ,c.first_name) , count(i.film_id)  
from customer c 
inner join rental r on c.customer_id  = r.customer_id 
inner join inventory i on r.inventory_id = i.inventory_id
group by c.customer_id
order by 2 desc 
limit 5


-- 14. Посчитайте для каждого покупателя 4 аналитических показателя:
--     1. количество фильмов, которые он взял в аренду
--     2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--     3. минимальное значение платежа за аренду фильма
--     4. максимальное значение платежа за аренду фильма
select concat_ws(' ',c.last_name ,c.first_name) as "Фамилия и имя поукпателя",
       count(i.film_id) as "Количество фильмов",
       round(sum(p.amount)) as "Общая стоимость платежей",
       min(p.amount) as "Минимальная стоимость платежа",
       max(p.amount) as "Максимальная стоимость платежа"
from customer c 
inner join rental r on c.customer_id  = r.customer_id 
inner join payment p on r.rental_id  = p.rental_id 
inner join inventory i on r.inventory_id = i.inventory_id
group by c.customer_id
order by 1


-- 15. Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
--     чтобы в результате не было пар с одинаковыми названиями городов. 
--     Для решения необходимо использовать декартово произведение.
select c.city , c2.city 
from city c, city c2
where c.city != c2.city 


-- 16. Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--     и дате возврата фильма (поле return_date), 
--    вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
select r.customer_id, 
       avg(extract (day from r.return_date - r.rental_date)) as "Среднее количество дней"
from rental r
group by r.customer_id
order by r.customer_id

-- 17. Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.
select t.title as "Название фильма",
       t.rating as "Рейтинг",
       c."name" as "Жанр", 
       t.release_year as "Год выпуска",
       l."name" as "Язык",
       t.count_rent as "Количество аренд",
       t.sum_amount as "Общая стоимость аренд"
from 
(
  select f.film_id, f.title, f.rating, f.release_year, f.language_id,
       count(r.rental_id) as "count_rent",
       sum(p.amount) as "sum_amount"
  from film f 
  inner join inventory i on f.film_id = i.film_id 
  inner join rental r on i.inventory_id = r.inventory_id 
  inner join payment p on r.rental_id = p.rental_id 
  group by f.film_id   
) t
left join film_category fc on t.film_id = fc.film_id  
left join category c on fc.category_id  = c.category_id
left join "language" l on t.language_id  = l.language_id
order by t.title


-- 18. Доработайте запрос 17 и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.
select t.title as "Название фильма",
       t.rating as "Рейтинг",
       c."name" as "Жанр", 
       t.release_year as "Год выпуска",
       l."name" as "Язык",
       0 as "Количество аренд",
       null as "Общая стоимость аренд"
from 
(
  select f.film_id, f.title, f.rating, f.release_year, f.language_id 
  from film f 
  left join inventory i on f.film_id = i.film_id 
  left join rental r on i.inventory_id = r.inventory_id 
  where i.inventory_id is null and r.rental_id  is null     
) t
left join film_category fc on t.film_id = fc.film_id  
left join category c on fc.category_id  = c.category_id
left join "language" l on t.language_id  = l.language_id
order by t.title

-- 19. Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--     Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".
select p.staff_id , 
       count(p.payment_id ) as "Количество продаж",
       case
		    when count(p.payment_id ) > 7300 then 'Да'
	 	    else 'Нет'	
  	   end	as "Премия"
from payment p 
group by p.staff_id


     
    








      
    
    



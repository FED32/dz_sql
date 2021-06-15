--=============== МОДУЛЬ 6. POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".

select film_id, title, special_features 
from film
where special_features @> '{Behind the Scenes}'
order by film_id




--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

select film_id, title, special_features 
from film
where '{Behind the Scenes}' && special_features
order by film_id


select film_id, title, special_features 
from film
where special_features::text ilike '%Behind the Scenes%'
order by film_id


select film_id, title, special_features 
from film
where 'Behind the Scenes' = any(special_features)
order by film_id


--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.

--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

with cte as (
	select film_id, title, special_features 
	from film
	where special_features @> '{Behind the Scenes}'
	order by film_id
)
select customer_id, count(special_features) 
from rental
left join inventory using(inventory_id)
inner join cte using(film_id)
group by customer_id
order by customer_id


--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

select customer_id, count(special_features) 
from rental
left join inventory using(inventory_id)
inner join (select film_id, title, special_features 
	from film
	where special_features @> '{Behind the Scenes}'
	order by film_id) as ff using(film_id)
group by customer_id
order by customer_id


--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

create materialized view
aaaa 
as 
select customer_id, count(special_features) 
from rental
left join inventory using(inventory_id)
inner join (select film_id, title, special_features 
	from film
	where special_features @> '{Behind the Scenes}'
	order by film_id) as ff using(film_id)
group by customer_id
order by customer_id
with no data

refresh materialized view 
aaaa


--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:

--1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, 
--   поиск значения в массиве происходит быстрее
--2. какой вариант вычислений работает быстрее: 
--   с использованием CTE или с использованием подзапроса

explain analyze
select film_id, title, special_features 
from film
where special_features @> '{Behind the Scenes}'
order by film_id


explain analyze
select film_id, title, special_features 
from film
where '{Behind the Scenes}' && special_features
order by film_id


explain analyze
select film_id, title, special_features 
from film
where special_features::text ilike '%Behind the Scenes%'
order by film_id

explain analyze
select film_id, title, special_features 
from film
where 'Behind the Scenes' = any(special_features)
order by film_id


explain analyze
with cte as (
	select film_id, title, special_features 
	from film
	where special_features @> '{Behind the Scenes}'
	order by film_id
)
select customer_id, count(special_features) 
from rental
left join inventory using(inventory_id)
inner join cte using(film_id)
group by customer_id
order by customer_id

explain analyze
select customer_id, count(special_features) 
from rental
left join inventory using(inventory_id)
inner join (select film_id, title, special_features 
	from film
	where special_features @> '{Behind the Scenes}'
	order by film_id) as ff using(film_id)
group by customer_id
order by customer_id



--1 суммарное время поиска в массиве с использованием @>, <@, && примерно одинаково, преобразование в текст приводит к увеличению времени при сортировке, функция any работает соизмеримо с &&
--&& Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.014..0.497 rows=538 loops=1), Sort  (cost=89.91..91.22 rows=525 width=78) (actual time=0.636..0.654 rows=538 loops=1)
--::text ilike Seq Scan on film  (cost=0.00..71.06 rows=1 width=78) (actual time=0.026..4.362 rows=538 loops=1), Sort  (cost=71.07..71.08 rows=1 width=78) (actual time=4.539..4.560 rows=538 loops=1)
--any Seq Scan on film  (cost=0.00..75.94 rows=525 width=78) (actual time=0.014..0.453 rows=538 loops=1), Sort  (cost=99.66..100.97 rows=525 width=78) (actual time=0.495..0.513 rows=538 loops=1)


--@> Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.015..0.504 rows=538 loops=1)
--<@ Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.019..0.538 rows=538 loops=1)
--&& Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.027..0.535 rows=538 loops=1)
--2 вычисления с использованием подзапроса работают быстрее, чем с использованием cte 

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выполняйте это задание в форме ответа на сайте Нетологии

--ЗАДАНИЕ №2
--Используя оконную функцию выведите для каждого сотрудника
--сведения о самой первой продаже этого сотрудника.





--ЗАДАНИЕ №3
--Для каждого магазина определите и выведите одним SQL-запросом следующие аналитические показатели:
-- 1. день, в который арендовали больше всего фильмов (день в формате год-месяц-день)
-- 2. количество фильмов взятых в аренду в этот день
-- 3. день, в который продали фильмов на наименьшую сумму (день в формате год-месяц-день)
-- 4. сумму продажи в этот день





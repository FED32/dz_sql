--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select
concat(cu.last_name, ' ', cu.first_name) "Фимилия и имя",
a.address "Адрес",
c.city "Город",
co.country "Страна"
from customer cu
left join address a on cu.address_id = a.address_id 
left join city c on a.city_id = c.city_id 
left join country co on c.country_id = co.country_id 



--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select store_id as "ID магазина", count(distinct customer_id) as "Количество покупателей"
from customer
group by store_id 


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select store_id as "ID магазина", count(distinct customer_id) as "Количество покупателей"
from customer
group by store_id 
having count(distinct customer_id) > 300

-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select "ID магазина", "Количество покупателей", c.city as "Город магазина", concat(s2.last_name, ' ', s2.first_name) as "Фамилия и имя продавца"
from (select store_id as "ID магазина", count(distinct customer_id) as "Количество покупателей"
   from customer
   group by store_id 
   having count(distinct customer_id) > 300 ) as res
   left join store s on res."ID магазина" = s.store_id
left join address a on s.address_id = a.address_id 
left join staff s2 on s.manager_staff_id = s2.staff_id
left join city c on a.city_id = c.city_id 


--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select
concat(last_name, ' ', first_name) as "Фамилия и имя покупателя", count as "Количество фильмов"
from (
   select customer_id, count(inventory_id)
   from rental
   group by customer_id
   order by count(inventory_id) desc
   limit 5) as r
left join customer c on r.customer_id = c.customer_id
order by "Количество фильмов" desc


--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма


select
concat(last_name, ' ', first_name) as "Фамилия и имя покупателя",
"Количество фильмов",
"Общая стоимость платежей",
"Минимальная стоимость платежа",
"Максимальная стоимость платежа"
from(
	select customer_id, 
	count(rental_id) as "Количество фильмов", 
	round(sum(amount), 0) as "Общая стоимость платежей", 
	min(amount) as "Минимальная стоимость платежа", 
	max(amount) as "Максимальная стоимость платежа"
	from payment
	group by customer_id) as rr
left join customer c on rr.customer_id = c.customer_id

--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select c.city as "Город 1", s.city as "Город 2"
from city c
cross join city s
where c.city != s.city


--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.

select 
customer_id as "ID покупателя",
round(avg((extract(epoch from (return_date - rental_date)))/86400)::numeric, 2) as "Среднее количество дней на возврат"
from rental
group by customer_id
order by "ID покупателя"

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.





--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.





--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".








--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия регионов из таблицы адресов

select distinct district from address;



--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те регионы, 
--названия которых начинаются на "K" и заканчиваются на "a", и названия не содержат пробелов

select distinct district from address 
where district like 'K%a' and district not like '% %';



--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 марта 2007 года по 19 марта 2007 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.

select payment_id, payment_date, amount from payment
where payment_date::date between '17-03-2007' and '19-03-2007' and amount>1.00
order by payment_date;



--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.

select payment_id, payment_date, amount from payment
order by payment_date desc
limit 10;



--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.

--select concat(first_name,' ', last_name) as "Фамилия и имя", email as "Электронная почта", character_length(email) as "Длина Email", to_char(last_update, 'YYYY-MM-DD') as "Дата" from customer;
select concat(first_name,' ', last_name) as "Фамилия и имя",
email as "Электронная почта",
character_length(email) as "Длина Email",
last_update::date as "Дата"
from customer;


--ЗАДАНИЕ №6
--Выведите одним запросом активных покупателей, имена которых Kelly или Willie.
--Все буквы в фамилии и имени из нижнего регистра должны быть переведены в высокий регистр.

select upper(last_name), upper(first_name) from customer
where activebool = true and (first_name = 'Kelly' or first_name = 'Willie');



--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите одним запросом информацию о фильмах, у которых рейтинг "R" 
--и стоимость аренды указана от 0.00 до 3.00 включительно, 
--а также фильмы c рейтингом "PG-13" и стоимостью аренды больше или равной 4.00.

select film_id, title, description, rating, rental_rate from film
where (rating = 'R' and rental_duration between 0.00 and 3.00) or (rating = 'PG' and rental_duration >= 4.00);



--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.

--select title, description, length (description) from film
select film_id, title, description from film
order by length (description) desc
limit 3;


--ЗАДАНИЕ №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--в первой колонке должно быть значение, указанное до @, 
--во второй колонке должно быть значение, указанное после @.

select customer_id, email, split_part(email, '@', 1) as "Email before @", split_part(email, '@', 2) as "Email after @"
from customer


--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква должна быть заглавной, остальные строчными.

select customer_id, email, 
concat(upper(left(split_part(email, '@', 1), 1)), substring(split_part(email, '@', 1), 2)) as "Email before @", 
concat(upper(left(split_part(email, '@', 2), 1)), substring(split_part(email, '@', 2), 2)) as "Email after @"
from customer


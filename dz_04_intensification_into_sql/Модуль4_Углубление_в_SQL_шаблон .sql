--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаете новые таблицы в формате:
--таблица_фамилия, 
--если подключение к контейнеру или локальному серверу, то создаете новую схему и в ней создаете таблицы.


-- Спроектируйте базу данных для следующих сущностей:
-- 1. язык (в смысле английский, французский и тп)
-- 2. народность (в смысле славяне, англосаксы и тп)
-- 3. страны (в смысле Россия, Германия и тп)


--Правила следующие:
-- на одном языке может говорить несколько народностей
-- одна народность может входить в несколько стран
-- каждая страна может состоять из нескольких народностей

 
--Требования к таблицам-справочникам:
-- идентификатор сущности должен присваиваться автоинкрементом
-- наименования сущностей не должны содержать null значения и не должны допускаться дубликаты в названиях сущностей
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

create table language (
	lang_id serial primary key,
	lang_name varchar(50) not null unique,
	create_date timestamp default now()
	);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ
insert into language (lang_name)
values ('Русский'),	('Французский'), ('Японский'), ('Испанский'), ('Португальский'), ('Итальянский'), ('Немецкий'), ('Украинский'), ('Белорусский');

insert into language (lang_name)
values ('Английский');

insert into language (lang_name)
values ('Башкирский'), ('Татарский');

select * from language


--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ

create table nation (
	nation_id serial primary key,
	nation_name varchar(50) not null unique,
	create_date timestamp default now()
	);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

insert into nation (nation_name)
values ('Славяне'), ('Англо-саксы'), ('Немцы'), ('Романцы'), ('Неороманцы'), ('Французы'), ('Татары'), ('Башкиры');

select * from nation

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

create table countries (
	country_id serial primary key,
	country_name varchar(50) not null unique,
	create_date timestamp default now()
	);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ

insert into countries (country_name)
values ('США'), ('Россия'), ('Бразилия'), ('Канада'), ('Украина'), ('Белоруссия'), ('Япония'), ('Испания'), ('Италия'), ('Франция'), ('Германия');

insert into countries (country_name)
values ('Австралия'), ('Новая Зеландия'), ('Аргентина'), ('Португалия')

insert into countries (country_name)
values ('Великобритания')

select * from countries

--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table country_nation (
country_id integer references countries(country_id),
nation_id integer references nation(nation_id),
create_date timestamp default now(),
primary key (country_id, nation_id)
);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

insert into country_nation(country_id, nation_id)
values (2, 1)

insert into country_nation(country_id, nation_id)
values (2, 8), (2, 7), (5, 1), (6, 1), (1, 2), (16, 2), (4, 2), (4, 6), (12, 2), (13, 2), (11, 3), (3, 5), (14, 5), (10, 6), (8, 4), (15, 4), (9, 4)

select * from country_nation


--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table nation_lang (
nation_id integer references nation(nation_id),
lang_id integer references language(lang_id),
create_date timestamp default now(),
primary key (nation_id, lang_id)
);


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into nation_lang 
values (1, 1), (1, 8), (1, 9), (2, 11), (3, 7), (5, 4), (5, 5), (6, 2), (4, 4), (4, 5), (4, 6)

select * from nation_lang
--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.



--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]



--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41



--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new



--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме



--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых



--ЗАДАНИЕ №7 
--Удалите таблицу film_new
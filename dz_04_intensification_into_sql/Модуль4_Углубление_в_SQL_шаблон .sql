--=============== ������ 4. ���������� � SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--���� ������: ���� ����������� � �������� ����, �� �������� ����� ������� � �������:
--�������_�������, 
--���� ����������� � ���������� ��� ���������� �������, �� �������� ����� ����� � � ��� �������� �������.


-- ������������� ���� ������ ��� ��������� ���������:
-- 1. ���� (� ������ ����������, ����������� � ��)
-- 2. ���������� (� ������ �������, ���������� � ��)
-- 3. ������ (� ������ ������, �������� � ��)


--������� ���������:
-- �� ����� ����� ����� �������� ��������� �����������
-- ���� ���������� ����� ������� � ��������� �����
-- ������ ������ ����� �������� �� ���������� �����������

 
--���������� � ��������-������������:
-- ������������� �������� ������ ������������� ���������������
-- ������������ ��������� �� ������ ��������� null �������� � �� ������ ����������� ��������� � ��������� ���������
 
--�������� ������� �����

create table language (
	lang_id serial primary key,
	lang_name varchar(50) not null unique,
	create_date timestamp default now()
	);

--�������� ������ � ������� �����
insert into language (lang_name)
values ('�������'),	('�����������'), ('��������'), ('���������'), ('�������������'), ('�����������'), ('��������'), ('����������'), ('�����������');

insert into language (lang_name)
values ('����������');

insert into language (lang_name)
values ('����������'), ('���������');

select * from language


--�������� ������� ����������

create table nation (
	nation_id serial primary key,
	nation_name varchar(50) not null unique,
	create_date timestamp default now()
	);

--�������� ������ � ������� ����������

insert into nation (nation_name)
values ('�������'), ('�����-�����'), ('�����'), ('�������'), ('����������'), ('��������'), ('������'), ('�������');

select * from nation

--�������� ������� ������

create table countries (
	country_id serial primary key,
	country_name varchar(50) not null unique,
	create_date timestamp default now()
	);

--�������� ������ � ������� ������

insert into countries (country_name)
values ('���'), ('������'), ('��������'), ('������'), ('�������'), ('����������'), ('������'), ('�������'), ('������'), ('�������'), ('��������');

insert into countries (country_name)
values ('���������'), ('����� ��������'), ('���������'), ('����������')

insert into countries (country_name)
values ('��������������')

select * from countries

--�������� ������ ������� �� �������

create table country_nation (
country_id integer references countries(country_id),
nation_id integer references nation(nation_id),
create_date timestamp default now(),
primary key (country_id, nation_id)
);

--�������� ������ � ������� �� �������

insert into country_nation(country_id, nation_id)
values (2, 1)

insert into country_nation(country_id, nation_id)
values (2, 8), (2, 7), (5, 1), (6, 1), (1, 2), (16, 2), (4, 2), (4, 6), (12, 2), (13, 2), (11, 3), (3, 5), (14, 5), (10, 6), (8, 4), (15, 4), (9, 4)

select * from country_nation


--�������� ������ ������� �� �������

create table nation_lang (
nation_id integer references nation(nation_id),
lang_id integer references language(lang_id),
create_date timestamp default now(),
primary key (nation_id, lang_id)
);


--�������� ������ � ������� �� �������
insert into nation_lang 
values (1, 1), (1, 8), (1, 9), (2, 11), (3, 7), (5, 4), (5, 5), (6, 2), (4, 4), (4, 5), (4, 6)

select * from nation_lang
--======== �������������� ����� ==============


--������� �1 
--�������� ����� ������� film_new �� ���������� ������:
--�   	film_name - �������� ������ - ��� ������ varchar(255) � ����������� not null
--�   	film_year - ��� ������� ������ - ��� ������ integer, �������, ��� �������� ������ ���� ������ 0
--�   	film_rental_rate - ��������� ������ ������ - ��� ������ numeric(4,2), �������� �� ��������� 0.99
--�   	film_duration - ������������ ������ � ������� - ��� ������ integer, ����������� not null � �������, ��� �������� ������ ���� ������ 0
--���� ��������� � �������� ����, �� ����� ��������� ������� ������� ������������ ����� �����.



--������� �2 
--��������� ������� film_new ������� � ������� SQL-�������, ��� �������� ������������� ������� ������:
--�       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--�       film_year - array[1994, 1999, 1985, 1994, 1993]
--�       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--�   	  film_duration - array[142, 189, 116, 142, 195]



--������� �3
--�������� ��������� ������ ������� � ������� film_new � ������ ����������, 
--��� ��������� ������ ���� ������� ��������� �� 1.41



--������� �4
--����� � ��������� "Back to the Future" ��� ���� � ������, 
--������� ������ � ���� ������� �� ������� film_new



--������� �5
--�������� � ������� film_new ������ � ����� ������ ����� ������



--������� �6
--�������� SQL-������, ������� ������� ��� ������� �� ������� film_new, 
--� ����� ����� ����������� ������� "������������ ������ � �����", ���������� �� �������



--������� �7 
--������� ������� film_new
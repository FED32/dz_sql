--=============== ������ 6. POSTGRESQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� SQL-������, ������� ������� ��� ���������� � ������� 
--�� ����������� ��������� "Behind the Scenes".

select film_id, title, special_features 
from film
where special_features @> '{Behind the Scenes}'
order by film_id




--������� �2
--�������� ��� 2 �������� ������ ������� � ��������� "Behind the Scenes",
--��������� ������ ������� ��� ��������� ����� SQL ��� ������ �������� � �������.

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


--������� �3
--��� ������� ���������� ���������� ������� �� ���� � ������ ������� 
--�� ����������� ��������� "Behind the Scenes.

--������������ ������� ��� ���������� �������: ����������� ������ �� ������� 1, 
--���������� � CTE. CTE ���������� ������������ ��� ������� �������.

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


--������� �4
--��� ������� ���������� ���������� ������� �� ���� � ������ �������
-- �� ����������� ��������� "Behind the Scenes".

--������������ ������� ��� ���������� �������: ����������� ������ �� ������� 1,
--���������� � ���������, ������� ���������� ������������ ��� ������� �������.

select customer_id, count(special_features) 
from rental
left join inventory using(inventory_id)
inner join (select film_id, title, special_features 
	from film
	where special_features @> '{Behind the Scenes}'
	order by film_id) as ff using(film_id)
group by customer_id
order by customer_id


--������� �5
--�������� ����������������� ������������� � �������� �� ����������� �������
--� �������� ������ ��� ���������� ������������������ �������������

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


--������� �6
--� ������� explain analyze ��������� ������ �������� ���������� ��������
-- �� ���������� ������� � �������� �� �������:

--1. ����� ���������� ��� �������� ����� SQL, ������������ ��� ���������� ��������� �������, 
--   ����� �������� � ������� ���������� �������
--2. ����� ������� ���������� �������� �������: 
--   � �������������� CTE ��� � �������������� ����������

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



--1 ��������� ����� ������ � ������� � �������������� @>, <@, && �������� ���������, �������������� � ����� �������� � ���������� ������� ��� ����������, ������� any �������� ���������� � &&
--&& Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.014..0.497 rows=538 loops=1), Sort  (cost=89.91..91.22 rows=525 width=78) (actual time=0.636..0.654 rows=538 loops=1)
--::text ilike Seq Scan on film  (cost=0.00..71.06 rows=1 width=78) (actual time=0.026..4.362 rows=538 loops=1), Sort  (cost=71.07..71.08 rows=1 width=78) (actual time=4.539..4.560 rows=538 loops=1)
--any Seq Scan on film  (cost=0.00..75.94 rows=525 width=78) (actual time=0.014..0.453 rows=538 loops=1), Sort  (cost=99.66..100.97 rows=525 width=78) (actual time=0.495..0.513 rows=538 loops=1)


--@> Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.015..0.504 rows=538 loops=1)
--<@ Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.019..0.538 rows=538 loops=1)
--&& Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.027..0.535 rows=538 loops=1)
--2 ���������� � �������������� ���������� �������� �������, ��� � �������������� cte 

--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� � ����� ������ �� ����� ���������

--������� �2
--��������� ������� ������� �������� ��� ������� ����������
--�������� � ����� ������ ������� ����� ����������.





--������� �3
--��� ������� �������� ���������� � �������� ����� SQL-�������� ��������� ������������� ����������:
-- 1. ����, � ������� ���������� ������ ����� ������� (���� � ������� ���-�����-����)
-- 2. ���������� ������� ������ � ������ � ���� ����
-- 3. ����, � ������� ������� ������� �� ���������� ����� (���� � ������� ���-�����-����)
-- 4. ����� ������� � ���� ����





--=============== ������ 3. ������ SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ��� ������� ���������� ��� ����� ����������, 
--����� � ������ ����������.

select
concat(cu.last_name, ' ', cu.first_name) "������� � ���",
a.address "�����",
c.city "�����",
co.country "������"
from customer cu
left join address a on cu.address_id = a.address_id 
left join city c on a.city_id = c.city_id 
left join country co on c.country_id = co.country_id 



--������� �2
--� ������� SQL-������� ���������� ��� ������� �������� ���������� ��� �����������.

select store_id as "ID ��������", count(distinct customer_id) as "���������� �����������"
from customer
group by store_id 


--����������� ������ � �������� ������ �� ��������, 
--� ������� ���������� ����������� ������ 300-��.
--��� ������� ����������� ���������� �� ��������������� ������� 
--� �������������� ������� ���������.

select store_id as "ID ��������", count(distinct customer_id) as "���������� �����������"
from customer
group by store_id 
having count(distinct customer_id) > 300

-- ����������� ������, ������� � ���� ���������� � ������ ��������, 
--� ����� ������� � ��� ��������, ������� �������� � ���� ��������.

select "ID ��������", "���������� �����������", c.city as "����� ��������", concat(s2.last_name, ' ', s2.first_name) as "������� � ��� ��������"
from (select store_id as "ID ��������", count(distinct customer_id) as "���������� �����������"
   from customer
   group by store_id 
   having count(distinct customer_id) > 300 ) as res
   left join store s on res."ID ��������" = s.store_id
left join address a on s.address_id = a.address_id 
left join staff s2 on s.manager_staff_id = s2.staff_id
left join city c on a.city_id = c.city_id 


--������� �3
--�������� ���-5 �����������, 
--������� ����� � ������ �� �� ����� ���������� ���������� �������

select
concat(last_name, ' ', first_name) as "������� � ��� ����������", count as "���������� �������"
from (
   select customer_id, count(inventory_id)
   from rental
   group by customer_id
   order by count(inventory_id) desc
   limit 5) as r
left join customer c on r.customer_id = c.customer_id
order by "���������� �������" desc


--������� �4
--���������� ��� ������� ���������� 4 ������������� ����������:
--  1. ���������� �������, ������� �� ���� � ������
--  2. ����� ��������� �������� �� ������ ���� ������� (�������� ��������� �� ������ �����)
--  3. ����������� �������� ������� �� ������ ������
--  4. ������������ �������� ������� �� ������ ������


select
concat(last_name, ' ', first_name) as "������� � ��� ����������",
"���������� �������",
"����� ��������� ��������",
"����������� ��������� �������",
"������������ ��������� �������"
from(
	select customer_id, 
	count(rental_id) as "���������� �������", 
	round(sum(amount), 0) as "����� ��������� ��������", 
	min(amount) as "����������� ��������� �������", 
	max(amount) as "������������ ��������� �������"
	from payment
	group by customer_id) as rr
left join customer c on rr.customer_id = c.customer_id

--������� �5
--��������� ������ �� ������� ������� ��������� ����� �������� ������������ ���� ������� ����� �������,
 --����� � ���������� �� ���� ��� � ����������� ���������� �������. 
 --��� ������� ���������� ������������ ��������� ������������.
 
select c.city as "����� 1", s.city as "����� 2"
from city c
cross join city s
where c.city != s.city


--������� �6
--��������� ������ �� ������� rental � ���� ������ ������ � ������ (���� rental_date)
--� ���� �������� ������ (���� return_date), 
--��������� ��� ������� ���������� ������� ���������� ����, �� ������� ���������� ���������� ������.

select 
customer_id as "ID ����������",
round(avg((extract(epoch from (return_date - rental_date)))/86400)::numeric, 2) as "������� ���������� ���� �� �������"
from rental
group by customer_id
order by "ID ����������"

--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� ������ ������� ��� ��� ����� � ������ � �������� ����� ��������� ������ ������ �� �� �����.





--������� �2
--����������� ������ �� ����������� ������� � �������� � ������� ������� ������, ������� �� ���� �� ����� � ������.





--������� �3
--���������� ���������� ������, ����������� ������ ���������. �������� ����������� ������� "������".
--���� ���������� ������ ��������� 7300, �� �������� � ������� ����� "��", ����� ������ ���� �������� "���".








--=============== ������ 2. ������ � ������ ������ =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--�������� ���������� �������� �������� �� ������� �������

select distinct district from address;



--������� �2
--����������� ������ �� ����������� �������, ����� ������ ������� ������ �� �������, 
--�������� ������� ���������� �� "K" � ������������� �� "a", � �������� �� �������� ��������

select distinct district from address 
where district like 'K%a' and district not like '% %';



--������� �3
--�������� �� ������� �������� �� ������ ������� ���������� �� ��������, ������� ����������� 
--� ���������� � 17 ����� 2007 ���� �� 19 ����� 2007 ���� ������������, 
--� ��������� ������� ��������� 1.00.
--������� ����� ������������� �� ���� �������.

select payment_id, payment_date, amount from payment
where payment_date between '17-03-2007' and '19-03-2007' and amount>1.00
order by payment_date;



--������� �4
-- �������� ���������� � 10-�� ��������� �������� �� ������ �������.

select payment_id, payment_date, amount from payment
order by payment_date desc
limit 10;



--������� �5
--�������� ��������� ���������� �� �����������:
--  1. ������� � ��� (� ����� ������� ����� ������)
--  2. ����������� �����
--  3. ����� �������� ���� email
--  4. ���� ���������� ���������� ������ � ���������� (��� �������)
--������ ������� ������� ������������ �� ������� �����.

select concat(first_name,' ', last_name) as "������� � ���", email as "����������� �����", character_length(email) as "����� Email", to_char(last_update, 'YYYY-MM-DD') as "����" from customer;



--������� �6
--�������� ����� �������� �������� �����������, ����� ������� Kelly ��� Willie.
--��� ����� � ������� � ����� �� ������� �������� ������ ���� ���������� � ������� �������.

select upper(last_name), upper(first_name) from customer
where activebool = true and (first_name = 'Kelly' or first_name = 'Willie');



--======== �������������� ����� ==============

--������� �1
--�������� ����� �������� ���������� � �������, � ������� ������� "R" 
--� ��������� ������ ������� �� 0.00 �� 3.00 ������������, 
--� ����� ������ c ��������� "PG-13" � ���������� ������ ������ ��� ������ 4.00.

select film_id, title, description, rating, rental_rate from film
where (rating = 'R' and rental_duration between 0.00 and 3.00) or (rating = 'PG' and rental_duration >= 4.00);



--������� �2
--�������� ���������� � ��� ������� � ����� ������� ��������� ������.

--select title, description, length (description) from film
select film_id, title, description from film
order by length (description) desc
limit 3;


--������� �3
-- �������� Email ������� ����������, �������� �������� Email �� 2 ��������� �������:
--� ������ ������� ������ ���� ��������, ��������� �� @, 
--�� ������ ������� ������ ���� ��������, ��������� ����� @.

select Name, value 
from customer
	cross string_split(email, "@");
--select value from string_split(email, @) from customer
--string_split(email, @)
--����� ��� �� ���������� ������, ��������� ����������� �������� sql

--������� �4
--����������� ������ �� ����������� �������, �������������� �������� � ����� ��������: 
--������ ����� ������ ���� ���������, ��������� ���������.




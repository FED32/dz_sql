--=============== ÌÎÄÓËÜ 6. POSTGRESQL =======================================
--= ÏÎÌÍÈÒÅ, ×ÒÎ ÍÅÎÁÕÎÄÈÌÎ ÓÑÒÀÍÎÂÈÒÜ ÂÅÐÍÎÅ ÑÎÅÄÈÍÅÍÈÅ È ÂÛÁÐÀÒÜ ÑÕÅÌÓ PUBLIC===========
SET search_path TO public;


--======== ÎÑÍÎÂÍÀß ×ÀÑÒÜ ==============

--ÇÀÄÀÍÈÅ ¹1
--Íàïèøèòå SQL-çàïðîñ, êîòîðûé âûâîäèò âñþ èíôîðìàöèþ î ôèëüìàõ 
--ñî ñïåöèàëüíûì àòðèáóòîì "Behind the Scenes".

select film_id, title, special_features 
from film
where special_features @> '{Behind the Scenes}'
order by film_id




--ÇÀÄÀÍÈÅ ¹2
--Íàïèøèòå åùå 2 âàðèàíòà ïîèñêà ôèëüìîâ ñ àòðèáóòîì "Behind the Scenes",
--èñïîëüçóÿ äðóãèå ôóíêöèè èëè îïåðàòîðû ÿçûêà SQL äëÿ ïîèñêà çíà÷åíèÿ â ìàññèâå.

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


--ÇÀÄÀÍÈÅ ¹3
--Äëÿ êàæäîãî ïîêóïàòåëÿ ïîñ÷èòàéòå ñêîëüêî îí áðàë â àðåíäó ôèëüìîâ 
--ñî ñïåöèàëüíûì àòðèáóòîì "Behind the Scenes.

--Îáÿçàòåëüíîå óñëîâèå äëÿ âûïîëíåíèÿ çàäàíèÿ: èñïîëüçóéòå çàïðîñ èç çàäàíèÿ 1, 
--ïîìåùåííûé â CTE. CTE íåîáõîäèìî èñïîëüçîâàòü äëÿ ðåøåíèÿ çàäàíèÿ.

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


--ÇÀÄÀÍÈÅ ¹4
--Äëÿ êàæäîãî ïîêóïàòåëÿ ïîñ÷èòàéòå ñêîëüêî îí áðàë â àðåíäó ôèëüìîâ
-- ñî ñïåöèàëüíûì àòðèáóòîì "Behind the Scenes".

--Îáÿçàòåëüíîå óñëîâèå äëÿ âûïîëíåíèÿ çàäàíèÿ: èñïîëüçóéòå çàïðîñ èç çàäàíèÿ 1,
--ïîìåùåííûé â ïîäçàïðîñ, êîòîðûé íåîáõîäèìî èñïîëüçîâàòü äëÿ ðåøåíèÿ çàäàíèÿ.

select customer_id, count(special_features) 
from rental
left join inventory using(inventory_id)
inner join (select film_id, title, special_features 
	from film
	where special_features @> '{Behind the Scenes}'
	order by film_id) as ff using(film_id)
group by customer_id
order by customer_id


--ÇÀÄÀÍÈÅ ¹5
--Ñîçäàéòå ìàòåðèàëèçîâàííîå ïðåäñòàâëåíèå ñ çàïðîñîì èç ïðåäûäóùåãî çàäàíèÿ
--è íàïèøèòå çàïðîñ äëÿ îáíîâëåíèÿ ìàòåðèàëèçîâàííîãî ïðåäñòàâëåíèÿ

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


--ÇÀÄÀÍÈÅ ¹6
--Ñ ïîìîùüþ explain analyze ïðîâåäèòå àíàëèç ñêîðîñòè âûïîëíåíèÿ çàïðîñîâ
-- èç ïðåäûäóùèõ çàäàíèé è îòâåòüòå íà âîïðîñû:

--1. Êàêèì îïåðàòîðîì èëè ôóíêöèåé ÿçûêà SQL, èñïîëüçóåìûõ ïðè âûïîëíåíèè äîìàøíåãî çàäàíèÿ, 
--   ïîèñê çíà÷åíèÿ â ìàññèâå ïðîèñõîäèò áûñòðåå
--2. êàêîé âàðèàíò âû÷èñëåíèé ðàáîòàåò áûñòðåå: 
--   ñ èñïîëüçîâàíèåì CTE èëè ñ èñïîëüçîâàíèåì ïîäçàïðîñà

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



--1 ñóììàðíîå âðåìÿ ïîèñêà â ìàññèâå ñ èñïîëüçîâàíèåì @>, <@, && ïðèìåðíî îäèíàêîâî, ïðåîáðàçîâàíèå â òåêñò ïðèâîäèò ê óâåëè÷åíèþ âðåìåíè ïðè ñîðòèðîâêå, ôóíêöèÿ any ðàáîòàåò ñîèçìåðèìî ñ &&
--&& Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.014..0.497 rows=538 loops=1), Sort  (cost=89.91..91.22 rows=525 width=78) (actual time=0.636..0.654 rows=538 loops=1)
--::text ilike Seq Scan on film  (cost=0.00..71.06 rows=1 width=78) (actual time=0.026..4.362 rows=538 loops=1), Sort  (cost=71.07..71.08 rows=1 width=78) (actual time=4.539..4.560 rows=538 loops=1)
--any Seq Scan on film  (cost=0.00..75.94 rows=525 width=78) (actual time=0.014..0.453 rows=538 loops=1), Sort  (cost=99.66..100.97 rows=525 width=78) (actual time=0.495..0.513 rows=538 loops=1)


--@> Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.015..0.504 rows=538 loops=1)
--<@ Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.019..0.538 rows=538 loops=1)
--&& Seq Scan on film  (cost=0.00..66.19 rows=525 width=78) (actual time=0.027..0.535 rows=538 loops=1)
--2 âû÷èñëåíèÿ ñ èñïîëüçîâàíèåì ïîäçàïðîñà ðàáîòàþò áûñòðåå, ÷åì ñ èñïîëüçîâàíèåì cte 

--======== ÄÎÏÎËÍÈÒÅËÜÍÀß ×ÀÑÒÜ ==============

--ÇÀÄÀÍÈÅ ¹1
--Âûïîëíÿéòå ýòî çàäàíèå â ôîðìå îòâåòà íà ñàéòå Íåòîëîãèè

--ÇÀÄÀÍÈÅ ¹2
--Èñïîëüçóÿ îêîííóþ ôóíêöèþ âûâåäèòå äëÿ êàæäîãî ñîòðóäíèêà
--ñâåäåíèÿ î ñàìîé ïåðâîé ïðîäàæå ýòîãî ñîòðóäíèêà.





--ÇÀÄÀÍÈÅ ¹3
--Äëÿ êàæäîãî ìàãàçèíà îïðåäåëèòå è âûâåäèòå îäíèì SQL-çàïðîñîì ñëåäóþùèå àíàëèòè÷åñêèå ïîêàçàòåëè:
-- 1. äåíü, â êîòîðûé àðåíäîâàëè áîëüøå âñåãî ôèëüìîâ (äåíü â ôîðìàòå ãîä-ìåñÿö-äåíü)
-- 2. êîëè÷åñòâî ôèëüìîâ âçÿòûõ â àðåíäó â ýòîò äåíü
-- 3. äåíü, â êîòîðûé ïðîäàëè ôèëüìîâ íà íàèìåíüøóþ ñóììó (äåíü â ôîðìàòå ãîä-ìåñÿö-äåíü)
-- 4. ñóììó ïðîäàæè â ýòîò äåíü





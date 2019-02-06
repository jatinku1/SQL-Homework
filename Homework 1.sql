use sakila;

select * from actor;
#1
select concat(last_name, ', ', first_name) as Name
from actor;

select actor_id, first_name, last_name
from actor
where first_name = 'Joe';
#2
select * 
from actor
where first_name like 'Gen%';

select * 
from actor
where last_name like '%li%';

select * from country;

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');
#3
alter table actor
add column Description varchar(25) after last_name;

alter table actor
modify column Description blob;

alter table actor
drop column Description;

#4
select last_name, count(*) as 'Number of Actors' 
from actor group by last_name;


select last_name, count(*) as 'Number of Actors' 
from actor group by last_name HAVING count(*) >=2;

update actor 
set first_name = 'HARPO'
where First_name = "Groucho" AND last_name = "Williams";


select * from actor where last_name = 'Williams';

update actor 
set first_name = 'Groucho' 
where actor_id = 172;

#5
describe sakila.address;

#6
select * from address;
select * from staff;

select first_name, last_name, address
from staff s 
join address a
on s.address_id = a.address_id;

select p.staff_id, s.first_name, s.last_name, sum(p.amount)
from staff s 
join payment p 
on s.staff_id = p.staff_id and payment_date like '2005-08%'; 

select f.title as 'Film Title', count(fa.actor_id) as `Number of Actors`
from film_actor fa
inner join film f 
on fa.film_id= f.film_id
group by f.title;

select title, (
select count(*) from inventory
where film.film_id = inventory.film_id
) as 'Number of Copies'
from film
where title = "Hunchback Impossible";

select c.first_name, c.last_name, sum(p.amount) as `Total Paid`
from customer c
join payment p 
on c.customer_id= p.customer_id
group by c.last_name;


#7
select title
from film where title 
like 'K%' or title like 'Q%'
and title in 
(
select title 
from film 
where language_id = 1
);

select first_name, last_name
from actor
where actor_id in
(
select actor_id
from film_actor
where film_id in 
(
select film_id
from film
where title = 'Alone Trip'
));

select cus.first_name, cus.last_name, cus.email 
from customer cus
join address a 
on (cus.address_id = a.address_id)
join city c
on (c.city_id = a.city_id)
join country
on (country.country_id = c.country_id)
where country.country= 'Canada';

select title, description from film 
where film_id in
(
select film_id from film_category
where category_id in
(
select category_id from category
where name = "Family"
));

select f.title, count(rental_id) as 'Times Rented'
from rental r
join inventory i
on (r.inventory_id = i.inventory_id)
join film f
on (i.film_id = f.film_id)
group by f.title
order by `Times Rented` desc;

select s.store_id, sum(amount) as 'Gross Business Revenue'
from payment p
join rental r
on (p.rental_id = r.rental_id)
join inventory i
on (i.inventory_id = r.inventory_id)
join store s
on (s.store_id = i.store_id)
group by s.store_id; 

select s.store_id, c.city, country.country 
from store s
join address a 
on (s.address_id = a.address_id)
join city c
on (c.city_id = a.city_id)
join country
on (country.country_id = c.country_id);

#7 H
select c.name as 'Genre', sum(p.amount) as 'Gross' 
from category c
join film_category fc 
on (c.category_id=fc.category_id)
join inventory i 
on (fc.film_id=i.film_id)
join rental r 
on (i.inventory_id=r.inventory_id)
join payment p 
on (r.rental_id=p.rental_id)
group by c.name order by Gross  limit 5;


create view genre_revenue as
select c.name as 'Genre', sum(p.amount) as 'Gross' 
from category c
join film_category fc 
on (c.category_id=fc.category_id)
join inventory i 
on (fc.film_id=i.film_id)
join rental r 
on (i.inventory_id=r.inventory_id)
join payment p 
on (r.rental_id=p.rental_id)
group by c.name order by Gross  limit 5;

select * from genre_revenue;

drop view genre_revenue;
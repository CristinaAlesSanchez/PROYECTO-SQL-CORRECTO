--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.

select f.title , f.rating 
from film f
where rating='R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.

select a.actor_id , a.first_name 
from actor a 
where a.actor_id between 30 and 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.

select f.title , f.language_id, f.original_language_id 
from film f
where f.language_id = f.original_language_id ; 

--5. Ordena las películas por duración de forma ascendente.

select f.title , f.length 
from film f 
order by f.length asc ;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

select concat(a.first_name , ' ', a.last_name ) as "Nombre completo Actor"
from actor a 
where a.last_name ilike '%Allen%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

select f.rating as "Clasificacion" ,
       count(f.film_id ) as "Recuento Peliculas"        
from film f 
group by f.rating  
order by "Recuento Peliculas" ;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.

select f.title, f.rating , f.length as "Duracion"
from film f 
where f.rating = 'PG-13' 
or f.length > 180 ;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select round(variance(f.replacement_cost ), 2) as "Varianza"
from film f ;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select MAX(f.length ) as "Mayor duracion",
       MIN(f.length ) as "Menor duracion" 
from film f ;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select r.rental_id , r.rental_date , p.amount 
from rental r  
join payment p on r.rental_id = p.rental_id 
order by r.rental_date ASC  
limit 1 offset 2;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

select f.title , f.rating 
from film f 
where f.rating not in ('NC-17', 'G');

--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

select f.rating as "Clasificacion",
       AVG(f.length) as "PromedioDuracion"
from film f 
group by f.rating ;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select f.title , f.length  
from film f 
where f.length > 180;

--15. ¿Cuánto dinero ha generado en total la empresa?

select SUM(p.amount )
from payment p ;

--16. Muestra los 10 clientes con mayor valor de id.

select c.customer_id , c.first_name 
from customer c 
order by c.customer_id desc
limit 10; 

--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

select concat(a.first_name, ' ' , a.last_name ) as "Actor",
       f.title 
from actor a 
join  film_actor fa on a.actor_id =fa.actor_id 
join film f on fa.film_id =f.film_id 
where f.title = 'EGG IGBY';

--18. Selecciona todos los nombres de las películas únicos.

select distinct  f.title 
from film f ;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

select f.title , c."name" , f.length 
from film f 
join film_category fc on f.film_id =fc.film_id 
join category c on fc.category_id =c.category_id 
where c."name" = 'Comedy'
and f.length > 180;

--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select c."name" as "Categoria",
       AVG(f.length) as "Promedio" 
from category c  
inner join film_category fc on c.category_id = fc.category_id 
join film f on fc.film_id = f.film_id 
group by c."name" 
having AVG(f.length ) > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?

select AVG(f.rental_duration) as "Media duracion"
from film f ;

--22. Crea una columna con el nombre y apellidos de todos los actores y actrices

select concat(a.first_name ,' ', a.last_name ) as "Nombre y Apellidos"
from actor a ;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente

select DATE(r.rental_date) as "Dia" , 
        count(*) as "Cantidad Alquiler"
from rental r
group by DATE(r.rental_date)
order by "Cantidad Alquiler"  DESC;

--24. Encuentra las películas con una duración superior al promedio.

select f.title , f.length 
from film f 
where f.length > ( 
         select AVG(f.length)
         from FILM F);

--25. Averigua el número de alquileres registrados por mes.

select extract (month from r.rental_date ) as "Mes",
       count(*) as "Total Alquiler"
from rental r 
group by EXTRACT(month from r.rental_date)
order by extract (month from r.rental_date );

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

select
       ROUND(AVG(p.amount ), 2) as "Promedio",
       ROUND(stddev(p.amount ), 2) as "Desviacion estandar",
       ROUND(variance( p.amount ), 2) as "Varianza"
from payment p ;

--27. ¿Qué películas se alquilan por encima del precio medio?

select f.title , f.rental_rate 
from film f 
join (select AVG(rental_rate) as avg_rate from film f ) as "Promedio"
      on f.rental_rate > "Promedio".avg_rate 
order by f.rental_rate desc ;

--28. Muestra el id de los actores que hayan participado en más de 40 peliculas

select fa.actor_id, 
       count(fa.film_id ) as "Total peliculas"
from film_actor fa 
group by actor_id 
having count(fa.film_id ) > 40;   

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

select f.film_id , f.title, count(i.inventory_id) as "Disponibles" 
from film f 
left join inventory i 
     on f.film_id = i.film_id 
group by f.film_id , f.title 
order by f.title ;

--30. Obtener los actores y el número de películas en las que ha actuado.

select a.actor_id ,
       concat(a.first_name ,' ', a.last_name ) as "Nombre actor",
       count(fa.film_id ) as "Numero pelicula"      
from actor a
left join film_actor fa 
    on a.actor_id = fa.actor_id 
group by a.actor_id , "Nombre actor" 
order by "Numero pelicula" desc;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas peliculas no tienen actores asociados.

select f.film_id , f.title , 
       a.actor_id , concat(a.first_name ,' ', a.last_name ) as "Actor"
from film f 
left join film_actor fa 
     on f.film_id = fa.film_id 
left join actor a 
     on fa.actor_id = a.actor_id 
order by f.title , "Actor";

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna pelicula.

select a.actor_id , concat(a.first_name ,' ', a.last_name ) as "Actor",
       f.film_id , f.title        
from  actor a 
left join film_actor fa 
     on a.actor_id  = fa.actor_id  
left join film f 
     on fa.film_id  = f.film_id  
order by "Actor" , f.title ;

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

select f.film_id , f.title,
       r.rental_id , r.rental_date , r.return_date 
from film f 
left join inventory i 
     on f.film_id = i.film_id 
left join rental r 
     on i.inventory_id = r.inventory_id 
     
--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
     
select c.customer_id, 
       concat(c.first_name ,' ', c.last_name ) as "Clientes",
       round(SUM(p.amount), 2) as "Total gastado"
from customer c 
join payment p 
    on c.customer_id =p.customer_id 
group by c.customer_id , "Clientes" 
order by "Total gastado" desc
limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select a.first_name 
from actor a 
where a.first_name = 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.

select a.first_name as "Nombre",
       a.last_name as "Apellido"
from actor a ;

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select 
      MIN(a.actor_id ) as "ID mas bajo",
      MAX(a.actor_id ) as "ID mas alto"
from actor a ;

--38. Cuenta cuántos actores hay en la tabla “actor”.

select count(a.actor_id ) as "Total actores"
from actor a ;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select a.last_name, a.first_name  
from actor a
order by a.last_name asc, a.first_name asc;

--40. Selecciona las primeras 5 películas de la tabla “film”.

select *
from film f
limit 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cual es el nombre mas repetido?

select a.first_name, 
      count(a.first_name) as "Total actores"
from actor a 
group by a.first_name 
order by "Total actores" desc;

--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

select r.rental_id , r.rental_date , r.return_date ,
       c.customer_id , concat(c.first_name ,' ', c.last_name )
from rental r 
join customer c 
    on r.customer_id = c.customer_id 
order by r.rental_date ;

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres

select c.customer_id , concat(c.first_name ,' ', c.last_name ) as "Clientes",
       r.rental_id , r.rental_date , r.return_date 
from customer c 
left join rental r 
     on c.customer_id =r.customer_id 
order by "Clientes", r.rental_date ;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta?¿Por que? Deja despues de la consulta la contestacion.

select f.film_id , f.title , c.category_id , c."name"  
from film f 
cross join category c ;
--No, mezcla todas las peliculas con las categorias sin orden ninguno y genera todas las combinaciones posibles entre películas y categorías, lo que normalmente no aporta valor analítico y produce un volumen de datos innecesario

--45. Encuentra los actores que han participado en películas de la categoría 'Action'

select distinct a.actor_id ,
       concat(a.first_name ,' ', a.last_name ) as "Actores",
       c."name"    
from actor a 
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id 
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id =c.category_id 
where c."name" = 'Action';

--46. Encuentra todos los actores que no han participado en películas.

select a.actor_id ,
       concat(a.first_name ,' ', a.last_name ) as "Actores"
from actor a 
left join film_actor fa on a.actor_id =fa.actor_id 
where fa.film_id is null;

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

select concat(a.first_name ,' ', a.last_name ) as "Actor",
       count(fa.film_id ) as "Total peliculas"
from actor a 
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id , "Actor" 
order by "Total peliculas" ;

--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el numero de peliculas en las que han participado.

create view "actor_num_peliculas" AS
select concat(a.first_name ,' ', a.last_name ) as "Actores",
       count(fa.film_id ) as "Numero peliculas"
from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
group by a.actor_id , "Actores" ;

--49. Calcula el número total de alquileres realizados por cada cliente.

select c.customer_id ,
       concat(c.first_name ,' ', c.last_name ) as "Cliente",
       count(r.rental_id ) as "Total alquileres"
from customer c 
join rental r on c.customer_id = r.customer_id 
group by c.customer_id , "Cliente"
order by "Total alquileres" ;

--50. Calcula la duración total de las películas en la categoría 'Action'.

select SUM(f.length ) as "Duracion total"
from film f 
join film_category fc on fc.film_id =f.film_id 
join category c on fc.category_id =c.category_id 
where c."name" = 'Action';

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

create temporary table "cliente_rentas_temporal" AS
select c.customer_id ,
       concat(c.first_name ,' ', c.last_name ) as "Cliente",
       count(r.rental_id) as "Total Alquileres"
from customer c 
join rental r on c.customer_id = r.customer_id 
group by c.customer_id , "Cliente" ;

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las peliculas que han sido alquiladas al menos 10 veces.

create temporary table "peliculas_alquiladas" AS
select f.film_id , f.title ,
      count(r.rental_id ) as "Total Alquileres"
from film f 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id =r.inventory_id 
group by f.film_id , f.title 
having count(r.rental_id ) >= 10
order by "Total Alquileres";

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

select distinct f.title 
from customer c 
join rental r on c.customer_id =r.customer_id 
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id 
where c.first_name = 'TAMMY'
  and c.last_name = 'SANDERS'
  and r.return_date  is null
order by f.title ;

--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.

select distinct a.first_name , a.last_name, c."name" 
from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
join film f on fa.film_id = f.film_id 
join film_category fc on f.film_id =fc.film_id 
join category c on fc.category_id = c.category_id 
where c."name" = 'Sci-Fi'
order by a.last_name ;

--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

select distinct a.first_name , a.last_name , f.title 
from actor a 
join film_actor fa on a.actor_id = fa.actor_id 
join film f on fa.film_id =f.film_id 
join inventory i on f.film_id = i.film_id 
join rental r on i.inventory_id =r.inventory_id 
join (
     select MIN(r.rental_date ) as "Fecha primera"
     from film f 
     join inventory i on f.film_id = i.film_id 
     join rental r on i.inventory_id = r.inventory_id 
     where f.title ='SPARTACUS CHEAPER') PRIMERA
on r.rental_date > PRIMERA."Fecha primera" 
order by a.last_name ;


--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.

select a.first_name , a.last_name 
from actor a 
where not exists (
         select *
         from film_actor fa 
         join film_category fc on fa.film_id = fc.film_id 
         join category c on fc.category_id =c.category_id 
         where fa.actor_id = a.actor_id 
         and c."name" = 'Music')
order by a.last_name ;

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 dias.

select distinct f.title 
from rental r
join inventory i on r.inventory_id = i.inventory_id  
join film f on i.film_id = f.film_id 
where r.return_date > r.rental_date + interval 8 day ;

--58. Encuentra el título de todas las películas que son de la misma categoría que 'Animation'.

select f.title 
from film f 
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id 
where c."name" = 'Animation'
order by f.title ;

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.

select f.title 
from film f 
join film f2 on f.length = f2.length 
       where f2.title  = 'DANCING FEVER'
order by f.title  ;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

select c.first_name , c.last_name
from customer c 
join rental r on c.customer_id = r.customer_id 
join inventory i on r.inventory_id =i.inventory_id 
group by c.customer_id , c.first_name , c.last_name 
having count(distinct i.film_id ) >= 7
order by c.last_name  ;

--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

select c."name" as "Categoria",
       count(r.rental_id ) as "Recuento Alquileres"
from category c
join film_category fc on c.category_id = fc.category_id 
join inventory i on fc.film_id = i.film_id 
join rental r on i.inventory_id = r.inventory_id 
group by "Categoria" 
order by "Recuento Alquileres" ;

--62. Encuentra el número de películas por categoría estrenadas en 2006.

select c."name" as "Categoria",
       count(f.film_id ) as "Total peliculas"
from category c 
join film_category fc on c.category_id = fc.category_id 
join film f on fc.film_id = f.film_id 
where f.release_year = 2006
group by c."name" 
order by "Total peliculas" ;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

select s.staff_id ,
      concat(s.first_name ,' ', s.last_name ) as "Trabajadores" , st.store_id , st.address_id  
from staff s 
cross join store st ;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

select c.customer_id ,
       concat(c.first_name ,' ', c.last_name ) as "Cliente", 
       count(r.rental_id ) as "Total peliculas alquiladas"
from customer c 
join rental r on c.customer_id =r.customer_id 
group by c.customer_id , "Cliente" 
order by "Total peliculas alquiladas" ;


















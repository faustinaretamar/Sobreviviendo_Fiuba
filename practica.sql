-- LEANDRO DEBERÁ APROBRAR, DE LO CONTRARIO SE CUELGA DE LAS ESCALERAS CON UNA BUFANDA

--Consulta básica sobre ki:
--Mostrar el nombre y el ki de todos los personajes que tienen un ataque secundario y cuyo ki es mayor a 8000, 
--ordenados de forma descendente por ki.

SELECT p.nombre, p.ki FROM personajes p 
WHERE p.ki > 8000 AND p.ataque_secundario is NOT NULL
GROUP BY p.nombre
ORDER BY p.ki;

--Consulta sobre torneos y ubicaciones:
--Listar todos los torneos disputados en el hemisferio sur (latitud < 0) 
--junto con el nombre del ganador.
SELECT p.nombre, t.nombre FROM torneos t 
JOIN personajes p ON t.id_ganador = p.id 
JOIN ubicaciones u ON t.id_ubicacion = u.id 
WHERE u.latitud < 0;

--Consulta sobre esferas del dragón:
--Obtener el número de esferas del dragón que cada personaje ha encontrado, 
--ordenando el resultado de forma descendente por cantidad de esferas encontradas.

SELECT p.nombre, count(*) as esferas_encontradas FROM esferas_del_dragon ed 
JOIN personajes p ON ed.encontrada_por = p.id 
GROUP BY p.id, p.nombre
ORDER BY esferas_encontradas DESC;

--Consulta combinada de varias tablas:
--Listar los nombres de los personajes y el nombre de los torneos en los que participaron y ganaron,
--considerando solo torneos con más de 10 concursantes.
SELECT p.nombre, t.nombre FROM torneos t 
JOIN personajes p ON t.id_ganador = p.id 
WHERE t.max_concursantes > 10
GROUP BY p.id, p.nombre;

--Consulta con condiciones complejas:
--Mostrar el nombre, la raza y el ki de todos los personajes que han encontrado
--al menos dos esferas del dragón y no tienen ataque secundario.

SELECT p.nombre, p.raza, p.ki, count(*) as cant_esferas_encontradas from esferas_del_dragon ed 
JOIN personajes p ON ed.encontrada_por = p.id 
WHERE p.ataque_secundario is NULL
GROUP BY p.id, p.nombre
HAVING count(*) >= 2
ORDER BY p.ki DESC;

--Mostrar la suma de los ki de todos los personajes que han ganado algún torneo.

SELECT sum(p.ki) FROM personajes p 
JOIN torneos t on p.id = t.id_ganador;

-- Listar todos los torneos que se disputaron al norte del ecuador (latitud 0) y 
--fueron ganados por personajes que no tienen ataque secundario
SELECT t.nombre FROM torneos t 
JOIN personajes p ON t.id_ganador = p.id 
JOIN ubicaciones u ON t.id_ubicaciones = u.id 
WHERE u.latitud > 0 AND p.ataque_secundario IS NULL; 

--Listar nombre, ataque principal y ki de los primeros 10 personajes que tienen más de 7000 de ki, 
--ganaron al menos 1 torneo y encontraron al menos una esfera del dragón, ordenados descendentemente por ki.

SELECT DISTINCT p.nombre, p.ki, p.ataque_principal FROM personajes p 
JOIN torneos t on p.id = t.id_ganador
JOIN esferas_del_dragon ed ON p.id = ed.encontrada_por
WHERE p.ki > 7000
ORDER BY p.ki DESC
--LIMIT 10;

--Listar los nombres de todos los personajes que solo encontraron esferas del dragón pares (2, 4, 6) y cuántas en total. 
--El resultado debe estar ordenado descendentemente por la cantidad de esferas encontradas.
SELECT p.nombre, count(*) AS cant_encontradas FROM esferas_del_dragon ed 
JOIN personajes p ON ed_encontrada_por = p.id
GROUP BY p.id, p.nombre
HAVING count(CASE WHEN ed.numero % 2 != 0 THEN 1 END) = 0
ORDER BY cant_encontradas;

--Listar el nombre de cada personaje, su raza, y el número total de esferas del dragón que encontraron. 
--Solo incluye a los personajes que encontraron más de 3 esferas. 
--Ordena el resultado por el número total de esferas encontradas de forma descendente.

SELECT p.nombre, p.raza, count(*) as encontradas FROM personajes p 
JOIN esferas_del_dragon ed ON p.id = ed.encontrada_por
GROUP BY p.id, p.nombre
HAVING count(*) > 3
ORDER BY encontradas DESC;   

--Encontrar el nombre de los torneos que tienen un premio de más de $5000
--y que se disputaron en una ubicación con longitud positiva (este del meridiano de Greenwich), 
--pero que no han sido ganados por ningún personaje con un ki menor a 10000.

SELECT t.nombre FROM torneos t 
JOIN personajes p ON t.id_ganador = p.id 
JOIN ubicaciones u ON t.id_ubicacion = u.id 
WHERE p.ki >= 10000 AND u.longitud > 0 AND t.premio > 5000;

--Listar los nombres de los personajes que encontraron esferas del dragón, pero que nunca ganaron un torneo. 
--Muestra el nombre del personaje y la cantidad de esferas del dragón que encontraron. 
--Ordena por la cantidad de esferas encontradas de forma descendente."

SELECT p.nombre, count(*) AS encontradas FROM  personajes p
JOIN esferas_del_dragon ed ON p.id = ed.encontrada_por 
LEFT JOIN torneos t ON  p.id = t.id_ganador
WHERE t.id_ganador IS NULL
GROUP BY p.id, p.nombre
ORDER BY encontradas DESC;

--Encontrar el nombre de los personajes que tienen un ki superior al promedio de ki de todos los personajes. 
--Muestra el nombre del personaje y su ki 

SELECT p.nombre, p.ki FROM personajes p 
WHERE p.ki > (SELECT avg(ki) FROM personajes); 


--Listar los nombres de los torneos que fueron ganados por personajes de raza 'Saiyajin' y que se disputaron en ubicaciones con latitud negativa (hemisferio sur). 
--Además, el premio del torneo debe ser superior al promedio de premios de todos los torneos

SELECT t.nombre FROM torneos t 
JOIN personajes p ON t.id_ganador = p.id  
JOIN ubicaciones u ON t.id_ubicaciones = u.id 
WHERE raza = 'Saiyajin' AND u.latitud < 0 and t.premio > (SELECT avg(premio) FROM torneos)

--Mostrar el nombre de las ubicaciones donde se han encontrado esferas del dragón, pero en las cuales no se ha disputado ningún torneo.

SELECT u.nombre FROM  ubicaciones u
JOIN esferas_del_dragon ed ON u.id = ed.id_ubicacion 
LEFT JOIN torneos t ON u.id = t.id_ubicacion
WHERE t.id IS NULL;

--Para cada raza, calcular la suma total de ki de sus personajes. 
--Solo incluye las razas cuya suma total de ki supere los 100000. 
--Ordena los resultados por la suma de ki de forma descendente.

SELECT p.raza, sum(p.ki) AS suma_kis FROM personajes p 
GROUP BY p.raza 
HAVING sum(p.ki) > 100000
ORDER BY suma_kis DESC;

--Listar el nombre de los personajes que tienen un ki superior al ki promedio de su propia raza. 
--Muestra el nombre del personaje, su raza y su ki. 
--Ordena el resultado por raza y luego por ki descendente.

SELECT p.nombre, p.raza, p.ki FROM personajes p 
WHERE p.ki > (SELECT avg(ki) FROM personajes where raza = p.raza)
ORDER BY p.raza, p.ki DESC;

--Encontrar el nombre de los torneos que fueron ganados por un personaje cuya raza sea 'Humano' o 'Namekiano', 
--y cuyo ki del ganador sea superior al promedio de ki de todos los ganadores de torneos. Muestra el nombre del torneo y el ki del ganador.

SELECT t.nombre, p.ki FROM torneos t 
JOIN personajes p ON t.id_ganador = p.id 
WHERE (p.raza = 'Humano' OR p.raza = 'Namekiano') AND p.ki > (SELECT avg(p.ki) FROM personajes p
JOIN torneos t ON p.id = t.id_ganador);

--Mostrar el nombre de las ubicaciones que tienen asociada al menos una esfera del dragón de número par (2, 4, 6), 
--y donde el promedio de ki de los personajes que encontraron esferas en esa ubicación sea superior a 50000.

SELECT u.nombre, count (*) AS encontradas, avg(p.ki) AS promedio_ki FROM esferas_del_dragon ed 
JOIN personajes p ON ed.encontrada_por = p.id 
JOIN ubicaciones u ON ed.id_ubicacion = u.id 
GROUP BY u.nombre
HAVING avg(p.ki) > 50000 AND count(case when ed.numero % 2 = 0 then 1 end) >= 1;

--Listar el nombre de los personajes que han encontrado esferas del dragón en ubicaciones 
--donde no se ha ganado ningún torneo por personajes de raza 'Majin'. Muestra el nombre del personaje y la cantidad total de esferas que ha encontrado. 
--Ordena por la cantidad de esferas de forma descendente. 

SELECT p.nombre, count(*) AS encontradas FROM esferas_del_dragon ed 
JOIN personajes p ON ed.encontrada_por = p.id 
JOIN ubicaciones u ON ed.id_ubicacion = u.id 
WHERE u.id not in (SELECT t.id_ubicacion FROM torneos t 
JOIN personajes p on t.id_ganador = p.id
WHERE p.raza = 'Majin')
GROUP BY p.nombre
ORDER BY encontradas;
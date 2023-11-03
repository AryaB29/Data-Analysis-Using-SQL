WITH data_hire AS(
SELECT 
	*
FROM
	`bigquery-public-data.london_bicycles.cycle_hire`
WHERE end_station_id IS NOT NULL AND end_station_id IS NOT NULL),

data_stations AS (
SELECT 
	*
FROM
	`bigquery-public-data.london_bicycles.cycle_stations`),

data_join_start AS(
SELECT
	rental_id,
	start_date,
	start_station_id,
	bikes_count,
	docks_count
FROM
	data_hire dh
JOIN data_stations ds 
ON ds.id = dh.start_station_id 
),

data_join_end AS(
SELECT
	rental_id as id_rental,
	id as id_station,
	end_date,
	end_station_id,
	latitude,
	longitude
FROM
	data_hire dh
JOIN data_stations ds 
ON ds.id = dh.end_station_id ),

data_join_all AS(
SELECT 
	id_rental,
	start_station_id,
	start_date,
	end_date,
	bikes_count,
	docks_count,
	latitude,
	longitude
FROM data_join_end dje
INNER JOIN data_join_start djs 
ON djs.rental_id = dje.id_rental
ORDER BY start_date DESC),

data_calculated_duration AS(
SELECT 
	start_station_id,
	start_date,
	end_date,
	TIMESTAMP_DIFF(end_date,start_date,MINUTE) AS Duration,
	bikes_count,
	docks_count,
	latitude,
	longitude
FROM
	data_join_all
where
	TIMESTAMP_DIFF(start_date,end_date,MINUTE) IS NOT NULL
ORDER BY 1 DESC)

SELECT 
	*
FROM data_calculated_duration
ORDER BY 2 DESC,4 DESC
LIMIT 2000;


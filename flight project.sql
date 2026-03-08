select *
from flights_cleaned;

/* Indexing */
CREATE INDEX idx_origin ON flights_cleaned(origin(10));
CREATE INDEX idx_destination ON flights_cleaned(destination(10));
CREATE INDEX idx_airline ON flights_cleaned(airline(10));
CREATE INDEX idx_delay ON flights_cleaned(delayminutes);
CREATE INDEX idx_departure_time ON flights_cleaned(scheduleddeparture);

/* View table - airline, route, time */
create view airline_performances as
select
	airline,
	count(*) as total_flights,
	avg(delayminutes) as avg_delay,
	sum(cancelled) as total_cancelled_flights,
	sum(diverted) as total_diverted_flights,
	sum(Early_flag) as total_early_arrivals
from flights_cleaned
group by airline; 

create view routes_performance as
select origin,
		destination,
        count(*) as total_flights,
        avg(delayminutes) as avg_delay,
        sum(cancelled) as total_cancelled_flights
from flights_cleaned
group by origin,destination;

create view time_performance as
select count(*) as total_flights,
		HOUR(scheduleddeparture) AS hour_bucket,
        avg(delayminutes) as avg_delay
from flights_cleaned
group by HOUR(scheduleddeparture);
drop view time_performance;
/* KPI table */
create table kpi_summary as
select
    count(*) as total_flights,
    avg(delayminutes) as avg_delayedmin,
    sum(cancelled) as total_cancelled,
    sum(diverted) as total_diverted,
    sum(Early_flag) as total_early_arrivals
from flights_cleaned;

DROP TABLE IF EXISTS kpi_summary;

create table kpi_summary(
	total_flights INT,
    avg_delayedmin DOUBLE,
    total_cancelled INT,
    total_diverted INT,
    total_early_arrivals INT
);

insert into kpi_summary
select
    count(*) as total_flights,
    CAST(avg(delayminutes) as DOUBLE) as avg_delayedmin,
    sum(cancelled) as total_cancelled,
    sum(diverted) as total_diverted,
    sum(Early_flag) as total_early_arrivals
from flights_cleaned;

/* EDA */
/* 1. avg delay per airline */
select airline, avg(delayminutes) as avg_delay_per_airline
from flights_cleaned
group by airline
order by avg_delay_per_airline desc;

/* 2. most delay reasons */
select delayreason, count(delayreason) as mostly_delayreason
from flights_cleaned
group by delayreason
order by mostly_delayreason desc;

/* 3. peak delays by hours */
select hour(scheduleddeparture), avg(delayminutes)
from flights_cleaned
group by hour(scheduleddeparture)
order by avg(delayminutes) desc;

/* 4. early arrivals by hours */
select hour(scheduleddeparture), sum(Early_flag)
from flights_cleaned
group by hour(scheduleddeparture)
order by sum(Early_flag);

/* 5. aircraft type with most delays*/
select aircrafttype, count(delayminutes) as total_delays
from flights_cleaned
group by aircrafttype;

/* 6. total cancelled and diverted per airline*/
select airline ,sum(cancelled) as total_Cancelled, sum(diverted) as total_diverted
from flights_cleaned
group by airline;

/* 7. flights per origin airport*/
select origin, destination, count(flightid) as total_flights
from flights_cleaned
group by origin,destination
order by count(flightid) desc;

/*Business KPI's*/
/*1. Airline Reliability Score*/
create view airline_realiability_Scores as
select airline,
	round(
		(
        (sum(Early_flag)/count(*) * 100 ) * 0.3 
        +
        (sum(delayminutes <= 15)/count(*) * 100 ) * 0.5
        +
        (100 - (sum(cancelled)/count(*)* 100)) * 0.1 
        +
       (100 - (sum(Diverted)/count(*) * 100)) * 0.1
       ) 
        ,2) as airline_realiability_Score
from flights_cleaned
group by airline
order by airline_realiability_Score desc;

select * from airline_realiability_Scores;

/* 2. Delay Risk Index*/
create view delay_risk_view as
select airline,
			(sum(
            case when delayminutes>60 then 3
				when delayminutes between 16 and 60 then 2
                when delayminutes between 1 and 15 then 1
                else 0 end)
                )/count(*)
		 as delay_risk_index
from flights_cleaned
group by airline
order by delay_risk_index desc;

/* 3. Aircraft Reliability Index */
create view aircraft_reliability_view as
select
    aircrafttype,
    round(
        (
            (sum(Early_flag) / count(*) * 100) * 0.3
            + (sum(delayminutes <= 15)/ count(*) * 100) * 0.5
            +(100 - (sum(cancelled)/ count(*) * 100)) * 0.1
            +(100 - (sum(diverted)/ count(*) * 100)) * 0.1
        ) 
    , 2) as aircraft_reliability_index
from flights_cleaned
group by aircrafttype
order by aircraft_reliability_index DESC;

/* 4. Airport Congestion Index */
create view airport_congestion_view as
select origin as airport,
		round(
        (count(*) * avg(delayminutes)) / 100
        ,2) as airport_congestion_index
from flights_cleaned
group by origin
order by airport_congestion_index desc;

/* 5. Route Stability Score */
create view route_stability_view as
select 
    origin,
    destination,
    round(
        (
            (sum(delayminutes <= 15) / count(*) * 100)* 0.5
            - (sum(cancelled) / count(*) * 100) *0.1
            - (sum(diverted) / count(*) * 100) *0.1
        ) 
    , 2) as route_stability_score
from flights_cleaned
group by origin, destination
order by route_stability_score DESC;

CREATE OR REPLACE VIEW airline_reliability_scores AS 
SELECT 
    airline,
    ROUND(
        (
            (SUM(Early_flag) * 1.0 / COUNT(*) * 100) * 0.3
            +
            (SUM(CASE WHEN delayminutes <= 15 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100) * 0.5
            +
            (100 - (SUM(cancelled) * 1.0 / COUNT(*) * 100)) * 0.1
            +
            (100 - (SUM(diverted) * 1.0 / COUNT(*) * 100)) * 0.1
        )
    , 2) AS airline_reliability_score
FROM flights_cleaned
GROUP BY airline;

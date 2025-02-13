show databases;
create database highcloud_airlines;
use highcloud_airlines;
show tables;
select * from maindata;


ALTER TABLE `highcloud_airlines`.`maindata` 
CHANGE COLUMN `%Airline ID` `Airline_ID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Carrier Group ID` `Carrier_Group_ID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Unique Carrier Code` `Unique_Carrier_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `%Unique Carrier Entity Code` `Unique_Carrier_Entity_Code` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Region Code` `Region_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `%Origin Airport ID` `Origin_Airport_ID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Origin Airport Sequence ID` `Origin_Airport_Sequence_ID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Origin Airport Market ID` `Origin_Airport_MarketID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Origin World Area Code` `Origin_World_Area_Code` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Destination Airport ID` `Destination_AirportID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Destination Airport Sequence ID` `Destination_Airport_Sequence_ID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Destination Airport Market ID` `Destination_Airport_MarketID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Destination World Area Code` `Destination_World_Area_Code` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Aircraft Group ID` `Aircraft_GroupID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Aircraft Type ID` `Aircraft_TypeID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Aircraft Configuration ID` `Aircraft_ConfigurationID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Distance Group ID` `Distance_GroupID` INT NULL DEFAULT NULL ,
CHANGE COLUMN `%Service Class ID` `Service_Class_ID` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `%Datasource ID` `Datasource_ID` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `# Departures Scheduled` `Departures_Scheduled` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Departures Performed` `Departures_Performed` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Payload` `Payload` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Available Seats` `Available_Seats` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Transported Passengers` `Transported_Passengers` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Transported Freight` `Transported_Freight` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Transported Mail` `Transported_Mail` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Ramp-To-Ramp Time` `Ramp_To_Ramp_Time` INT NULL DEFAULT NULL ,
CHANGE COLUMN `# Air Time` `Air_Time` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Unique Carrier` `Unique_Carrier` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Carrier Code` `Carrier_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Carrier Name` `Carrier_Name` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Origin Airport Code` `Origin_Airport_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Origin City` `Origin_City` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Origin State Code` `Origin_State_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Origin State FIPS` `Origin_State_FIPS` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Origin State` `Origin_State` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Origin Country Code` `Origin_Country_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Origin Country` `Origin_Country` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Destination Airport Code` `Destination_Airport_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Destination City` `Destination_City` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Destination State Code` `Destination_State_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Destination State FIPS` `Destination_State_FIPS` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Destination State` `Destination_State` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Destination Country Code` `Destination_Country_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Destination Country` `Destination_Country` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Year` `Year_num` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Month (#)` `Month_num` INT NULL DEFAULT NULL ,
CHANGE COLUMN `Day` `Day_num` INT NULL DEFAULT NULL ,
CHANGE COLUMN `From - To Airport Code` `From_To_Airport_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `From - To Airport ID` `From_To_Airport_ID` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `From - To City` `From_To_City` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `From - To State Code` `From_To_State_Code` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `From - To State` `From_To_State` TEXT NULL DEFAULT NULL ;

select * from maindata;

create view date_field as
select
concat(year_num,'-',month_num,'-',day_num) as order_date,
year_num,
month_num,
Transported_Passengers,
Available_Seats,
carrier_name,
From_To_City,
Distance_GroupID
from maindata ;




create view kpi1 as
 select *,
monthname(order_date) as month_name,
concat("Q",quarter(order_date)) as Quarter_num,
concat(year_num,"-",month_num) as yearmonth,
case
when weekday(order_date) in (5,6) then "weekend"
when weekday(order_date) in (0,1,2,3,4) then "weekday"
end as Weekend_weekday,
weekday(order_date) as weekdaynum,
dayname(order_date) as day_name,
case
when month(order_date) = 1 then 10
when month(order_date) = 2 then 11
when month(order_date) = 3 then 12
when month(order_date) = 4 then 1
when month(order_date) = 5 then 2
when month(order_date) = 6 then 3
when month(order_date) = 7 then 4
when month(order_date) = 8 then 5
when month(order_date) = 9 then 6
when month(order_date) = 10 then 7
when month(order_date) = 11 then 8
when month(order_date) = 12 then 9
end as financial_month,
case 
when quarter(order_date) = 1 then "Q4"
when quarter(order_date) = 2 then "Q1"
when quarter(order_date) = 3 then "Q2" 
when quarter(order_date) = 4 then "Q3"
end as financial_quarter
from date_field;

#Q1 Date field
select * from kpi1;


#Year Wise Load Factor#
select year_num,concat(round(sum(transported_passengers)/sum(available_seats)*100,2),"%") as "Load factor %"
from kpi1
group by year_num ;


#Quarter wise Load Factor#
select quarter_num,concat(round(sum(transported_passengers)/sum(available_seats)*100,2),"%") as "Load factor %"
from kpi1
group by quarter_num ;


#Month wise Load factor#
select month_name,concat(round(sum(transported_passengers)/sum(available_seats)*100,2),"%") as "Load factor %"
from kpi1
group by month_name;


#Carrier name wise load factor
select carrier_name, concat(round(sum(transported_passengers)/sum(available_seats)*100,2),"%") as Load_Factor
from kpi1
group by carrier_name
order by load_factor
 desc;

#Top 10 carriers based on passenger prefernce
select carrier_name,sum(transported_passengers) as "Passenger Preference"
from kpi1
group by carrier_name
order by sum(transported_passengers) desc
limit 10;

#Tp routes based on number of flights
select from_to_city,count(from_to_city) as "Nummber of flights" from kpi1
group by from_to_city
order by count(from_to_city) desc
limit 10;

#Load factor % on Weekends and Weekdays
select weekend_weekday,concat(round(sum(transported_passengers)/sum(available_seats)*100,2),"%") as "Load factor %"
from kpi1
group by weekend_weekday;


#Distance groups based on Number of flights
select distance_groupid,count(distance_groupid) as "Number of flights"
from kpi1
group by distance_groupid;


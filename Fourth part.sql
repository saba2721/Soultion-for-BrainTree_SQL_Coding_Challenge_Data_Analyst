/*4a. What is the count of countries and sum of their related gdp_per_capita values for the year 2007 
where the string 'an' (case insensitive) appears anywhere in the country name?
4b. Repeat question 4a, but this time make the query case sensitive.*/

with cte as (select cm.*, co.continent_name,cn.Country_name, cp.year,cp.gdp_per_capita from continent_map cm
join continent co
on cm.continent_code = co.continent_code
join countries cn 
on cm.country_code = cn.Country_code
join per_capita as cp
on cm.country_code = cp.country_code
where cp.year = 2007
and cn.Country_name like '%An%'
order by co.continent_name)
select count(Country_name), sum(gdp_per_capita)
from cte;

/*5. Find the sum of gpd_per_capita by year and the count of countries for each year
 that have non-null gdp_per_capita where (i) the year is before 2012 and (ii) the country has 
 a null gdp_per_capita in 2012. Your result should have the columns:
year
country_count
total*/

select t1.year, count(Country_name) as country_count, round(sum(gdp_per_capita),2) as Total
from
(select cm.*, co.continent_name,cn.Country_name, cp.year,cp.gdp_per_capita from continent_map cm
join continent co
on cm.continent_code = co.continent_code
join countries cn 
on cm.country_code = cn.Country_code
join per_capita as cp
on cm.country_code = cp.country_code) as t1
where t1.gdp_per_capita is not null
and t1.year < 2012
group by t1.year;


select t1.year, count(Country_name) as country_count, round(sum(gdp_per_capita),2) as Total
from
(select cm.*, co.continent_name,cn.Country_name, cp.year,cp.gdp_per_capita from continent_map cm
join continent co
on cm.continent_code = co.continent_code
join countries cn 
on cm.country_code = cn.Country_code
join per_capita as cp
on cm.country_code = cp.country_code) as t1
where t1.gdp_per_capita is null
and t1.year = 2012
group by t1.year;

/* 7. Find the country with the highest average gdp_per_capita for each continent 
for all years. Now compare your list to the following data set.
 Please describe any and all mistakes that you can find with the data set below. 
 Include any code that you use to help detect these mistakes.*/
 
with cte1 as (with cte as (select t1.continent_name, t1.country_code, t1.Country_name, avg(t1.gdp_per_capita) as avg_gdp_per_capita
from
(select cm.*, co.continent_name,cn.Country_name, cp.year,cp.gdp_per_capita from continent_map cm
join continent co
on cm.continent_code = co.continent_code
join countries cn 
on cm.country_code = cn.Country_code
join per_capita as cp
on cm.country_code = cp.country_code) as t1
group by t1.continent_name,t1.country_code, t1.Country_name
order by t1.continent_name,avg(t1.gdp_per_capita))
select *, rank() over (partition by continent_name order by avg_gdp_per_capita desc) as Rank_GDP
from cte)
select * from cte1
where Rank_GDP = 1;


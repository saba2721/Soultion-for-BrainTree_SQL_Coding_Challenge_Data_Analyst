/* 2. List the countries ranked 10-12 in each continent by the percent of year-over-year growth descending from 2011 to 2012.
The percent of growth should be calculated as: ((2012 gdp - 2011 gdp) / 2011 gdp)
The list should include the columns:
rank
continent_name
country_code
country_name
growth_percent

All answers that return money values should be rounded to 2 decimal points and preceded by the "$" symbol (e.g. "$1432.10").
All answers that return percent values should be between -100.00 to 100.00, rounded to 2 decimal points and followed by the "%" symbol 
(e.g. "58.30%").
*/
USE braintree;
select * from continent;
select * from continent_map;
select * from countries;

with cte as (select t3.*, dense_rank() over (partition by t3.continent_name order by t3.Growth_percent desc) as RNK from 
(select t2.*, (case when t2.Lead_gdp IS NULL then null else concat(round(((t2.Lead_gdp - t2.gdp_per_capita)*100/t2.gdp_per_capita),2),'%') end ) as Growth_percent
from
(select t1.*, lead(t1.year) over (partition by t1.continent_code, t1.country_code order by t1.year) as Lead_year,
 lead(t1.gdp_per_capita) over (partition by t1.continent_code, t1.country_code order by t1.year) as Lead_gdp
from 
(select cm.*, co.continent_name,cn.Country_name, cp.year,cp.gdp_per_capita from continent_map cm
join continent co
on cm.continent_code = co.continent_code
join countries cn 
on cm.country_code = cn.Country_code
join per_capita as cp
on cm.country_code = cp.country_code
where cp.year between 2011 and 2012) as t1) as t2
where t2.Lead_gdp is not NUlL) as t3)
select RNK as 'Rank', continent_name, country_code, Country_name,Growth_percent
from cte
where RNK between 10 and 12 ;

with cte as (select *, 
(case when t2.continent_name = 'Asia' then t2.GDP_Continent*100/t2.TTL_GDP
when t2.continent_name = 'Europe' then t2.GDP_Continent*100/t2.TTL_GDP
else 0
end) as Final
from 
(select t1.*,
Round(sum(t1.gdp_per_capita) over (partition by t1.continent_name),2) as GDP_Continent,
Round(sum(t1.gdp_per_capita) over (),2) as TTL_GDP
from
(select cm.*, co.continent_name,cn.Country_name, cp.year,cp.gdp_per_capita from continent_map cm
join continent co
on cm.continent_code = co.continent_code
join countries cn 
on cm.country_code = cn.Country_code
join per_capita as cp
on cm.country_code = cp.country_code
where cp.year = 2012) as t1) as t2)
select distinct(continent_name), Final from cte;

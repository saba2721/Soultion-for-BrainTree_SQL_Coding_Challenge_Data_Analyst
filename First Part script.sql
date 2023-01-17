select * from continent;
select * from continent_map;
select * from countries;
select * from per_capita;
#Alphabetically list all of the country codes in the continent_map table that appear more than once. 
#Display any values where country_code is null as country_code = "FOO" and make this row appear first in the list,
 #even though it should alphabetically sort to the middle. Provide the results of this query as your answer.---#
Update continent_map
Set country_code = Null where length(country_code) = 0;

select distinct(t1.country_code) from 
(select coalesce(country_code, 'FOO') as country_code, row_number() over (partition by country_code order by country_code) as Row_s
from continent_map) as t1
where Row_s >1 ;

/*For all countries that have multiple rows in the continent_map table, 
delete all multiple records leaving only the 1 record per country. 
The record that you keep should be the first one when sorted by the continent_code alphabetically ascending. 
Provide the query/ies and explanation of step(s) that you follow to delete these records.*/

with cte as (select *, row_number() over (partition by country_code order by continent_code) as Row_s
from continent_map)
select * from cte
where Row_s = 1;
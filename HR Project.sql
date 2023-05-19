CREATE DATABASE projects;
USE projects;
SELECT * FROM hr;
alter table hr change column ï»¿id emp_id varchar(20) null;
describe hr;
select birthdate from hr;
update hr 
set birthdate = case
 when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
 when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
 else null
end;

alter table hr modify column birthdate date;

update hr 
set hire_date = case
 when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
 when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
 else null
end;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SET sql_mode = 'ALLOW_INVALID_DATES';
 
ALTER TABLE hr
MODIFY COLUMN termdate DATE;

alter table hr add column age int;

update hr 
set age = timestampdiff(YEAR, birthdate, CURDATE());

select birthdate,age from hr;

select 
min(age) as youngest,
max(age) as oldest from hr;

select count(*) from hr where age < 18;


#--Questions---

#--1.what is the gender breakdown of employee in the company?

select gender,count(*) as count from hr 
where age >= 18 and termdate = '0000-00-00'
 group by gender;
 
 #---2. what is the race/ethinicity breakdown of employee in the company??
 
 select race, count(*) as count from hr
 where age >= 18 and termdate = '0000-00-00'
 group by race
 order by count(*) desc;
 
 #--3.what is the age distribution of employees in the company??
 
 select 
 min(age) as youngest,
 max(age) as oldest
 from hr 
 where age >= 18 and termdate = '0000-00-00';
 
 select 
 case
  when age >= 18 and age <= 24 then '18-24'
  when age >= 25 and age <= 34 then '25-34'
  when age >= 35 and age <= 44 then '35-44'
  when age >= 45 and age <= 54 then '45-54'
  when age >= 55 and age <= 64 then '55-64'
  else '65+'
 end as age_group,gender,
  count(*) as count 
  from hr 
  where age >= 18 and termdate = '0000-00-00'
  group by age_group,gender
  order by age_group,gender;
 
#--4.How many employees work at headquarters verses remote locations?

select location,count(*) as count from hr
where age >= 18 and termdate = '0000-00-00'
group by location;

#--5.what is the average length of employement for employees who has been terminated??

select round(avg(datediff(termdate,hire_date))/365,0) as avg_length_employement
from hr
where termdate<= curdate() and termdate <> '0000-00-00' and age >= 18;

#--6.how does the gender distribution vary across departments and job titles??

select department,gender,count(*) as count from hr
where age >= 18 and termdate = '0000-00-00'
group by department, gender
order by department;


#--7.what is the distribution of job titles across the company??

select jobtitle, count(*) as count from hr
where age >= 18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;

#--8.which department has highest turnover rate??
select department,
total_count,
terminated_count,
terminated_count/total_count as termination_rate
from(
select department,
count(*) as total_count,
sum(case when termdate<> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr 
where age >= 18
group by department
) as subquery
order by termination_rate desc;

#--9.what is the distribution employees across locations by city and state???

select location_state,count(*) as count from hr 
where age >= 18 and termdate = '0000-00-00'
group by location_state
order by count desc;

#--10.How was the company's employee count changed over time based on hire and term date??

select 
year,
hires,
terminations,
hires-terminations as net_change,
round((hires-terminations)/hires*100,2) as net_change_percent
from(
select
 YEAR(hire_date) as year,
 count(*) as hires,
 sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
 from hr 
 where age >= 18
 group by year(hire_date)
 ) as subquery
 order by year asc;

#--11.what is the tenure distribution for each department

select department, round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr 
where termdate <= curdate() and termdate <> '0000-00-00' and age >= 18
group by department;








/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

copy company_dim 
from 'E:\Data Analytics\SQL lesson\SQL learning\csv_files\company_dim.csv'
delimiter ',' CSV HEADER;
copy job_postings_fact
from 'E:\Data Analytics\SQL lesson\SQL learning\csv_files\job_postings_fact.csv'
delimiter ',' CSV HEADER;
copy skills_dim 
from 'E:\Data Analytics\SQL lesson\SQL learning\csv_files\skills_dim.csv'
delimiter ',' CSV HEADER;
copy skills_job_dim 
from 'E:\Data Analytics\SQL lesson\SQL learning\csv_files\skills_job_dim.csv'
delimiter ',' CSV HEADER;


SELECT *
FROM job_postings_fact
LIMIT 100;

SELECT 
    count(job_id),
    extract(month from job_posted_date) as month
FROM 
    job_postings_fact 
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    month
ORDER BY 
    count(job_id) DESC;

-- 1
SELECT 
    job_schedule_type,
    avg(salary_year_avg) AS yearly_average_salary,
    avg(salary_hour_avg) AS hourly_average_salary
    
FROM 
    job_postings_fact
WHERE
    job_schedule_type <> 'NULL' AND
    job_posted_date > '2023-06-01'
    
GROUP BY 
    job_schedule_type
ORDER BY 
    yearly_average_salary;

-- 2
SELECT 
    -- job_posted_date at time zone 'UTC' at time zone 'America/New_York',
    extract(MONTH FROM job_posted_date) AS month,
    count(job_id) as job_count
FROM
    job_postings_fact
GROUP BY
    month
ORDER BY
    month;

-- 3
SELECT 
    company_dim.company_id,
    company_dim.name AS company_name,
    EXTRACT(MONTH from job_postings_fact.job_posted_date) as month,
    job_postings_fact.job_health_insurance AS health_insurance
FROM 
    job_postings_fact
INNER JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    EXTRACT(MONTH from job_postings_fact.job_posted_date) between 4 and 6 AND
    job_postings_fact.job_health_insurance = TRUE 
ORDER BY
    month ;

-- practice problem

-- january table
create table january_jobs AS
    SELECT 
        *
    FROM 
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 1;

-- february table
create table february_jobs AS
    SELECT 
        *
    FROM 
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 2;

-- march table   
create table march_jobs AS
    SELECT *
    FROM 
        job_postings_fact
    WHERE 
        EXTRACT(MONTH FROM job_posted_date) = 3;

drop table march_jobs
drop table january_jobs

-- case expression 
SELECT 
    count(job_id),
    case 
        when job_location = 'Anywhere' then 'Remote Job'
        when job_location = 'New York' then 'Local'
        else 
            'Onsite'
    end as location_category
    
    
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;

-- practice problem 

SELECT 
    salary_year_avg,
    case
        when salary_year_avg <> null and salary_year_avg < 40000 then 'Low' 
        when salary_year_avg <> null and salary_year_avg < 50000 then 'Standard'
        else 'High'
    end as salary_range
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
ORDER BY salary_range DESC;






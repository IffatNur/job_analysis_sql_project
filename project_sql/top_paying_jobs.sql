-- 1) what are the top paying job for data analyst role

SELECT 
    job_postings_fact.job_id,
    job_postings_fact.job_title AS job_role,
    company_dim.name AS company,
    job_postings_fact.job_location,
    job_postings_fact.job_schedule_type AS schedule,
    job_postings_fact.salary_year_avg ,
    job_postings_fact.job_posted_date::date
FROM job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE salary_year_avg IS NOT NULL AND 
    job_title_short = 'Data Analyst'  AND
    job_work_from_home = TRUE
ORDER BY salary_year_avg DESC
LIMIT 10;

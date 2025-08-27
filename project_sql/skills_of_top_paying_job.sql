-- 2) what are the skills required for these top paying role 

WITH job_with_skills  AS( 
    SELECT *
    FROM skills_dim
    INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
)

SELECT 
    job_postings_fact.job_id,
    job_postings_fact.job_title AS job_role,
    company_dim.name AS company,
    job_with_skills.skills,
    job_postings_fact.job_location,
    job_postings_fact.job_schedule_type AS schedule,
    job_postings_fact.salary_year_avg ,
    job_postings_fact.job_posted_date::date
FROM job_postings_fact
INNER JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
INNER JOIN job_with_skills ON job_with_skills.job_id = job_postings_fact.job_id
WHERE job_postings_fact.salary_year_avg IS NOT NULL AND 
    job_postings_fact.job_title_short = 'Data Analyst'  AND
    job_postings_fact.job_work_from_home = TRUE AND
    job_with_skills.skills IS NOT NULL
ORDER BY salary_year_avg DESC;
    
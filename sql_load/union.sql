-- practice : find the corresponding skill and skill_type for each job posting of Q1 
--  - include those without any skill 
--  - look at the skills and type for each job in the Q1 that has salary > 70k



WITH january_jobs_with_skills AS (
    SELECT 
        skills_job_dim.job_id,
        EXTRACT(MONTH FROM job_postings_fact.job_posted_date) as month,
        job_postings_fact.salary_year_avg AS salary,
        skills_dim.skills,
        skills_dim.type as skill_type
    FROM skills_job_dim
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 1
)
WITH february_jobs_with_skills AS (
    SELECT 
        skills_job_dim.job_id,
        EXTRACT(MONTH FROM job_postings_fact.job_posted_date) as month,
        job_postings_fact.salary_year_avg AS salary,
        skills_dim.skills,
        skills_dim.type as skill_type
    FROM skills_job_dim
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 2
)
WITH march_jobs_with_skills AS (
    SELECT 
        skills_job_dim.job_id,
        EXTRACT(MONTH FROM job_postings_fact.job_posted_date) as month,
        job_postings_fact.salary_year_avg AS salary,
        skills_dim.skills,
        skills_dim.type as skill_type
    FROM skills_job_dim
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE EXTRACT(MONTH FROM job_postings_fact.job_posted_date) = 3
)
SELECT *
FROM (
    january_jobs_with_skills
    UNION ALL
    february_jobs_with_skills
    UNION ALL
    march_jobs_with_skills
)
WHERE salary > 70000

-- practice: 2

SELECT 
    job_id,
    job_title_short,
    job_location,
    job_country
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS Q1_table
WHERE salary_year_avg > 70000 AND job_title_short = 'Data Analyst'
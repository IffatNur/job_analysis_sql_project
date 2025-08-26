-- 1) what are the top paying job for my role

SELECT 
    job_title_short AS job_role,
    salary_year_avg AS salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL and job_title_short = 'Data Analyst'  
ORDER BY salary_year_avg DESC
LIMIT 10;

-- 2) what are the skills required for these top paying role 

SELECT 
    job_with_skills.job_id,
    job_postings_fact.salary_year_avg,
    job_with_skills.skills
FROM (
        SELECT
            skills_job_dim.job_id as job_id,
            skills_job_dim.skill_id as skill_id,
            skills_dim.skills
        FROM skills_dim 
        INNER JOIN skills_job_dim ON skills_job_dim.skill_id = skills_dim.skill_id
        ORDER BY skills_job_dim.skill_id
    ) as job_with_skills
INNER JOIN job_postings_fact ON job_with_skills.job_id = job_postings_fact.job_id
WHERE job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY job_postings_fact.salary_year_avg DESC
    
-- 3) what are the most in demand skills for my role

with skills_type as(
    SELECT 
        skill_id,
        skills
    FROM skills_dim
)

SELECT 
    skills_job_dim.skill_id,
    skills_type.skills,
    job_postings_fact.job_title_short,
    count(job_postings_fact.job_id) AS job_count
FROM skills_job_dim
INNER JOIN job_postings_fact on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_type ON skills_job_dim.skill_id = skills_type.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' 
GROUP BY skills_job_dim.skill_id, job_postings_fact.job_title_short,skills_type.skills
ORDER BY job_count DESC

-- 4) what are the top skills based on salary for my role
-- 5) what are the most optimal skills to learn 
--     - high demanding and high paying
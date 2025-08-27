-- 4) what are the top skills based on salary for data analyst role
WITH skills_type as(
    SELECT 
        skill_id,
        skills
    FROM skills_dim
)

SELECT 
    skills_job_dim.skill_id,
    skills_type.skills,
    job_postings_fact.job_title_short,
    round(avg(job_postings_fact.salary_year_avg),0)  AS avg_salary
FROM skills_job_dim
INNER JOIN job_postings_fact on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_type ON skills_job_dim.skill_id = skills_type.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_job_dim.skill_id, job_postings_fact.job_title_short,skills_type.skills
ORDER BY avg_salary DESC
LIMIT 25;

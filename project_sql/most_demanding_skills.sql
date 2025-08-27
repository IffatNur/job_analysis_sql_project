-- 3) what are the most in demand skills for data analyst role

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
    count(job_postings_fact.job_id) AS job_count
FROM skills_job_dim
INNER JOIN job_postings_fact on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_type ON skills_job_dim.skill_id = skills_type.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' 
GROUP BY skills_job_dim.skill_id, job_postings_fact.job_title_short,skills_type.skills
ORDER BY job_count DESC
LIMIT 5;

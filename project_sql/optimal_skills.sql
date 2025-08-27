-- 5) what are the most optimal skills to learn 
--     - high demanding and high paying

SELECT 
    skills_job_dim.skill_id,
    skills_dim.skills,
    job_postings_fact.job_title_short,
    count(job_postings_fact.job_id) AS job_count,
    round(avg(job_postings_fact.salary_year_avg),0)  AS avg_salary
FROM skills_job_dim
INNER JOIN job_postings_fact on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE AND
    job_postings_fact.salary_year_avg is NOT NULL
GROUP BY skills_job_dim.skill_id, job_postings_fact.job_title_short,skills_dim.skills
ORDER BY job_count DESC,avg_salary DESC
LIMIT 25;


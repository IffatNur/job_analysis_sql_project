-- subqueries 

SELECT *
FROM (
    select * -- subquery definition starts here
    from job_postings_fact
    where EXTRACT(MONTH from job_posted_date) = 1
) AS january_jobs; -- subquery definition ends here

SELECT 
    company_id,
    name as company_name
FROM company_dim
WHERE company_id in(
    SELECT 
        company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = TRUE
)


-- CTE

WITH march_job_list AS ( -- CTE definition starts here
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
) -- CTE definition ends here

SELECT *
FROM march_job_list;

-- problem: finding total job postings per company

WITH total_job_count as (
SELECT 
    company_id,
    count(job_id) as total_count
FROM job_postings_fact
GROUP BY company_id
)

SELECT 
    company_dim.name,
    total_job_count. total_count
FROM company_dim
left join total_job_count 
on company_dim.company_id = total_job_count.company_id
ORDER BY total_job_count.total_count desc;

-- practice: find top 5 skills which are frequently required in job postings

SELECT 
    skills_count.skill_id,  
    skills_dim.skills,
    skills_count.job_count
FROM (
    SELECT 
        skill_id,
        count(job_id) as job_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY job_count desc
    limit 5
) AS skills_count
left join skills_dim 
on skills_count.skill_id = skills_dim.skill_id;

-- practice :

SELECT *,
    case
        when total_post < 10 then 'Small'
        when total_post between 10 and 50 then 'Medium'
        when total_post > 50 then 'Large'
    end AS Company_category
FROM (
    SELECT 
        company_id,
        count(job_id) AS total_post
    FROM job_postings_fact
    GROUP BY company_id
) AS job_count ;


-- practice: 5 most demanding skills which are included in remote jobs
-- (SOLVED USING SUBQUERIES)

SELECT 
    skills_job_dim.skill_id,
    skills_dim.skills,
    count(skills_job_dim.job_id) AS total_job
FROM skills_job_dim
inner join skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE skills_job_dim.job_id in (
    SELECT 
        job_id
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
    )
GROUP BY skills_job_dim.skill_id,skills_dim.skills
ORDER BY total_job DESC
LIMIT 5

-- practice: 5 most demanding skills which are included in remote jobs
-- (SOLVED USING CTE)

WITH job_per_skill_count AS (
    SELECT 
        skills_job_dim.skill_id,
        count(job_postings_fact.job_id) AS total_job
    FROM job_postings_fact
    INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    WHERE job_work_from_home = TRUE
    GROUP BY skills_job_dim.skill_id
)
SELECT 
    job_per_skill_count.skill_id,
    skills_dim.skills,
    job_per_skill_count.total_job
FROM skills_dim
INNER JOIN job_per_skill_count on skills_dim.skill_id = job_per_skill_count.skill_id
ORDER BY job_per_skill_count.total_job DESC
LIMIT 5
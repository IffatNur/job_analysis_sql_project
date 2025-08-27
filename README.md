# Introduction
This project analyzes job postings data to explore job market trends of Data Analyst role. 
This project explores top paying jobs, most demanding skills for top paying jobs, in demand jobs and where high demands meet high salary in data analytics.

SQL queries : [project_sql folder](/project_sql/)
# Background
The dataset comes from job postings in the tech sector. With the rising demand for data skills, understanding which skills are most valuable can help professionals plan their learning path.

### The question I wanted to answer SQL queries were : 
1) what are the top paying job for data analyst role? 
2) what are the skills required for these top paying role?
3) what are the most in demand skills for data analyst role?
4) what are the top skills based on salary for data analyst role?
5) what are the most optimal skills to learn based on : 
    - high demanding and 
    - high paying

# Tools I used
**SQL:** 
Used for querying, cleaning, and analyzing structured data. It helped extract insights from large datasets efficiently.

**PostgreSQL:** The relational database management system (RDBMS) I used to store and process data. PostgreSQL’s advanced features (window functions, CTEs, aggregation) were useful for complex analysis.

**Visual Studio Code:** My go to code editor to write SQL scripts and manage project files. Its extensions and integrated terminal made development smoother.

**Git and GitHub:** Used for version control and project collaboration. Git tracked changes to my queries and documentation, while GitHub allowed me to share the project and keep everything organized.
# The analysis
Each query for this project aimed at investigating specific aspect of data analyst job market. 
Here's how approached each quetions: 

- The top paying job for data analyst role 

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
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
```

- The skills required for these top paying role

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
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
```

- The most in demand skills for data analyst role

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand. The job posting count against each skill helped me to find most demanding skills for the role.

```sql
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
```

- The top skills based on salary for data analyst role

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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
```

- The most optimal skills to learn 

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
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
```

# What I learned

- Complex Query : I have got to learn about advanced SQL, merging tables and CTE as temp table.

- Data Aggregation: In almost all the queries I used GROUP BY and aggregate functions like COUNT() and AVG() into my data summarization.

- Analytical Enhancement: Leveled up my real world analytical problems, turning questions into actionable, insightful SQL queries.

# Conclusions

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.


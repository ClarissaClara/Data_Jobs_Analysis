/*
Question: What are the top-paying jobs for Data Analysts?
- Identify the top 10 highest-paying roles for Data Analysts that are available remotely.
- Focuses on job postings with specified salary information, ensuring that there are no null values in the salary field.
Purpose: Highlight the most lucrative remote job opportunities for Data Analysts, providing insights into the current job market.
*/

SELECT
    jpf.job_id,
    jpf.job_title,
    cd.name AS company_name,
    jpf.job_location,
    jpf.job_schedule_type,
    jpf.salary_year_avg,
    jpf.job_posted_date
FROM
    job_postings_fact jpf
LEFT JOIN company_dim cd ON jpf.company_id = cd.company_id
WHERE
    jpf.job_title_short = 'Data Analyst' AND 
    jpf.job_location = 'Anywhere' AND 
    jpf.salary_year_avg IS NOT NULL
ORDER BY
    jpf.salary_year_avg DESC
LIMIT 10;
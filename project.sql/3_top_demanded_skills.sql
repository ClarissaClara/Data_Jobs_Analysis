/*
Question: What skills are most in demand for Data Analyst jobs?
- Count the occurrences of each skill in the job postings.
- Order the results by the count in descending order.
Purpose: Provide insights into the key skills that are in demand for Data Analyst positions, 
helping job seekers understand what qualifications they need to focus on.
*/

SELECT
    sd.skills,
    COUNT(sjd.job_id) AS demand_count
FROM
    job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst' AND
    jpf.job_location = 'Anywhere'
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 10;
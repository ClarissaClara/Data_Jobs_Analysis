# Introduction
This project analyzes data from various job-seeking platforms to uncover insights into top-paying data analyst roles, in-demand skills, and the intersection of high-paying and high-demand skills. It is designed for individuals interested in entering the field, helping them identify which skills to focus on for career growth.

SQL queries: [click here](/project.sql/)
# Background
As an aspiring data analyst, I researched how to secure a good internship to kickstart my career as a second-year Information Technology student. I found that Excel, SQL, Python, and Power BI are among the most recommended skills to master in order to gain an advantage in a competitive job market.

While revisiting SQL, I came across a YouTube tutorial, and the course project aligned perfectly with what I was studying at the time.

The dataset used in this project is from Luke Barousse, and most of the queries are based on his course, with a few additional modifications and improvements that I implemented.

### The Questions for the SQL queries:
1. What are the top-paying jobs for Data Analysts?
2. What skills are associated with the top-paying jobs for Data Analysts?
3.  What skills are most in demand for Data Analyst jobs?
4. What are the top skills based on salary for Data Analysts looking for remote opportunities?
5. What are the most optimal skills that are high demand and high paying?
# Tools Used
For this project, 4 main tools are used, among those:
1. **SQL**: The backbone of the analysis, allows querying of the database to gain insights.
2. **PostgreSQL**: Chosen database management system to handle the data.
3. **Visual Studio Code**: Used for database management and queries.
4. **Git & Github**: Version control and sharing of SQL scripts and analysis.
# The Analysis
### Top Paying Data Analyst Jobs
This analysis identifies the top 10 highest-paying remote Data Analyst roles by focusing on job postings with specified salary information (excluding null values), with the goal of highlighting the most lucrative opportunities and providing insights into the current job market.
```sql
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
```
Here is the breakdown based on the query above:
- Salaries range from ~$184K to $650K, with one unusually high outlier, indicating that most high-paying roles cluster between ~$180K–$300K.
- Senior roles dominate top pay, Positions like Director and Principal Data Analyst make up most of the highest-paying jobs, showing that experience significantly impacts salary.
- All roles are listed as “Anywhere,” confirming that fully remote Data Analyst positions can offer highly competitive salaries across top companies.

### Top Paying Job's Associated Skills
This analysis examines the skills associated with the top 10 highest-paying remote Data Analyst roles by identifying the key tools and technologies required for these positions, providing insight into the most valuable skills job seekers should focus on to qualify for high-paying opportunities. This query uses the previous query as a CTE to simplify the process of extracting useful insights.
```sql
WITH top_paying_jobs AS (
    SELECT
        jpf.job_id,
        jpf.job_title,
        cd.name AS company_name,
        jpf.salary_year_avg
    FROM
        job_postings_fact jpf
    LEFT JOIN company_dim cd ON jpf.company_id = cd.company_id
    WHERE
        jpf.job_title_short = 'Data Analyst' AND 
        jpf.job_location = 'Anywhere' AND 
        jpf.salary_year_avg IS NOT NULL
    ORDER BY
        jpf.salary_year_avg DESC
    LIMIT 10
)

SELECT
    tpj.*,
    sd.skills
FROM
    top_paying_jobs tpj
INNER JOIN skills_job_dim sjd ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
ORDER BY
    tpj.salary_year_avg DESC;
```
Insights:
- To become a high-paid data analyst, focus on:
1. SQL + Python (core)
2. Tableau or Power BI
3. Cloud (AWS/Azure)
4. Big data tools (optional but powerful)

### Top Demanded Skills
This analysis identifies the most in-demand skills for Data Analyst roles by counting the frequency of each skill across job postings and ranking them in descending order, providing valuable insights into the key qualifications job seekers should prioritize.
```sql
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
```
Insights:
* **SQL is the most essential skill**
  , with the highest demand by a large margin, SQL stands out as the core skill required for Data Analyst roles.

* **Data visualization and spreadsheet tools remain highly relevant**
  , tools like Excel, Tableau, and Power BI rank among the top, highlighting the importance of data reporting and visualization.

* **Programming skills are increasingly important**
  , Python and R show strong demand, indicating a growing need for analysts to perform advanced data analysis beyond basic tools.
### Top Paying Skills
This analysis identifies the top-paying skills for remote Data Analyst roles by calculating the average salary associated with each skill and ranking them in descending order, providing insights into which qualifications are linked to higher compensation and should be prioritized by job seekers.
```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM
    job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills  
ORDER BY
    average_salary DESC
LIMIT 25;
```
Insights:
- Highest pay = Big Data + Cloud skills
  Tools like PySpark, Databricks, Airflow, GCP drive top salaries because they handle large-scale data.
- High-paying roles expect more than analysis**
  Skills in Python (pandas, numpy), ML tools, and DevOps (Git, CI/CD) show companies want hybrid analyst + engineer roles.
- Basic tools don’t pay top salaries
  Common skills (Excel, Tableau) are baseline — higher pay comes from advanced, less common tools + system-level knowledge.

### Most Optimal Skills
This analysis identifies the most optimal skills for remote Data Analyst roles by focusing on those that appear in both high-demand and high-paying categories, providing insights into the qualifications that offer the best combination of strong demand and competitive salaries for job seekers.
```sql
SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) AS demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS average_salary
FROM
    job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Analyst' AND
    jpf.job_location = 'Anywhere' AND
    jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skill_id
HAVING
    COUNT(sjd.job_id) > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;
```
* **Cloud & data engineering skills offer the best balance**
  Tools like *Snowflake, Azure, AWS,* and *BigQuery* show strong demand with high salaries, making them highly optimal skills.

* **Core tools remain highly demanded but slightly lower paying**
  Skills like *Python, Tableau,* and *R* have very high demand but slightly lower average salaries, indicating they are essential but more common.

* **Niche & technical skills command higher pay with lower demand**
  Skills like *Go, Hadoop,* and *Confluence* offer higher salaries but appear less frequently, suggesting specialization can lead to better compensation.

# Lesson Learned
This is my first SQL project outside of coursework. Throughout this project, I became familiar with several new concepts and techniques, including:

1. Using GROUP BY and HAVING to analyze and extract insights from specific categories of data.

2. Applying CTEs and subqueries to create temporary result sets for more complex queries.

3. Combining data from multiple tables using LEFT JOIN and INNER JOIN.
# Conclusions

This project provided valuable insights into the data analyst job market, particularly in identifying high-paying roles, in-demand skills, and the overlap between demand and compensation. The analysis shows that while foundational skills like SQL, Python, and data visualization tools are essential, higher-paying opportunities often require additional expertise in cloud platforms, big data technologies, and more advanced technical tools.

Overall, this project highlights the importance of building a well-rounded skill set that combines core analytical abilities with more specialized, high-value skills to stay competitive in the evolving data industry.

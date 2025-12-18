-- TABLE CREATION

CREATE TABLE AI_Jobs (
    job_id VARCHAR PRIMARY KEY,
    job_title VARCHAR,
    salary_usd INT,
    salary_currency VARCHAR,
    experience_level VARCHAR,
    employment_type VARCHAR,
    company_location VARCHAR,
    company_size VARCHAR,
    employee_residence VARCHAR,
    remote_ratio INT,
    required_skills TEXT,
    education_required VARCHAR,
    years_experience INT,
    industry VARCHAR,
    posting_date DATE,
    application_deadline DATE,
    job_description_length INT,
    benefits_score FLOAT,
    company_name VARCHAR
);

SELECT * FROM AI_Jobs;

-- DATA VALIDATION

-- Check for nulls in critical columns
SELECT
    COUNT(*) FILTER (WHERE job_title IS NULL) AS Missing_Job_Title,
    COUNT(*) FILTER (WHERE salary_usd IS NULL) AS Missing_Salary,
    COUNT(*) FILTER (WHERE company_name IS NULL) AS Missing_Company
FROM AI_Jobs;

-- Check for impossible salary values
SELECT *
FROM AI_Jobs
WHERE salary_usd <= 0;

-- GENERAL OVERVIEW

-- Total number of job postings
SELECT COUNT(*) AS Total_Jobs
FROM AI_Jobs;

-- Number of job postings per experience level
SELECT experience_level,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY experience_level
ORDER BY Total_Jobs DESC;

-- Number of job postings per company location (country)
SELECT company_location,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY company_location
ORDER BY Total_Jobs DESC;

-- Number of job postings per industry
SELECT industry,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY industry
ORDER BY Total_Jobs DESC;

-- Number of postings per employment type
SELECT employment_type,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY employment_type
ORDER BY Total_Jobs DESC;

-- SALARY ANALYSIS

-- Average, minimum, and maximum salary overall
SELECT AVG(salary_usd) AS Average_Salary,
       MIN(salary_usd) AS Minimum_Salary,
       MAX(salary_usd) AS Maximum_Salary
FROM AI_Jobs;

-- Average, minimum, and maximum salary per experience level
SELECT experience_level,
       AVG(salary_usd) AS Average_Salary,
       MIN(salary_usd) AS Minimum_Salary,
       MAX(salary_usd) AS Maximum_Salary,
       COUNT(*) AS Total_Jobs
FROM AI_Jobs
GROUP BY experience_level
ORDER BY Average_Salary DESC;

-- Average salary per company size
SELECT company_size,
       AVG(salary_usd) AS Average_Salary,
       COUNT(*) AS Total_Jobs
FROM AI_Jobs
GROUP BY company_size
ORDER BY Average_Salary DESC;

-- Average salary per industry
SELECT industry,
       AVG(salary_usd) AS Average_Salary,
       COUNT(*) AS Total_Jobs
FROM AI_Jobs
GROUP BY industry
ORDER BY Average_Salary DESC;

-- Top 5 highest paying companies
SELECT company_name,
       AVG(salary_usd) AS Average_Salary,
       COUNT(*) AS Total_Jobs
FROM AI_Jobs
GROUP BY company_name
ORDER BY Average_Salary DESC
LIMIT 5;

-- EXPERIENCE & EDUCATION-

-- Average years of experience required per experience level
SELECT experience_level,
       AVG(years_experience) AS Avg_Years_Experience,
       COUNT(*) AS Total_Jobs
FROM AI_Jobs
GROUP BY experience_level
ORDER BY Avg_Years_Experience DESC;

-- Most common education levels
SELECT education_required,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY education_required
ORDER BY Total_Jobs DESC;

-- Education level by experience level
SELECT experience_level, education_required,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY experience_level, education_required
ORDER BY experience_level, Total_Jobs DESC;

-- COMPANY INSIGHTS

-- Top 5 companies with most job postings
SELECT company_name,
       COUNT(*) AS Total_Jobs
FROM AI_Jobs
GROUP BY company_name
ORDER BY Total_Jobs DESC
LIMIT 5;

-- Job postings per company size
SELECT company_size,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY company_size
ORDER BY Total_Jobs DESC;

-- Job postings by employee residence vs company location
SELECT company_location, employee_residence,
       COUNT(*) AS Total_Jobs,
       ROUND( (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs)), 2) AS Percentage
FROM AI_Jobs
GROUP BY company_location, employee_residence
ORDER BY Total_Jobs DESC;

-- SKILLS & POSTING TIMELINE

-- Top 10 most frequently required skills
SELECT TRIM(skill) AS Skill, COUNT(*) AS Frequency
FROM AI_Jobs,
     UNNEST(STRING_TO_ARRAY(required_skills, ',')) AS skill
GROUP BY Skill
ORDER BY Frequency DESC
LIMIT 10;

-- Average job description length per experience level
SELECT experience_level,
       AVG(job_description_length) AS Avg_Job_Desc_Length,
       MIN(job_description_length) AS Min_Job_Desc_Length,
       MAX(job_description_length) AS Max_Job_Desc_Length,
       COUNT(*) AS Total_Jobs
FROM AI_Jobs
GROUP BY experience_level
ORDER BY Avg_Job_Desc_Length DESC;

-- Job postings per month
SELECT 
    TRIM(TO_CHAR(Posted_date::date, 'Month')) AS Month,
    COUNT(*) AS Total_Jobs,
	ROUND(CAST (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM AI_Jobs) AS Decimal),2) AS Percentage
FROM Dubia_Properties
GROUP BY TRIM(TO_CHAR(Posted_date::date, 'Month')), EXTRACT(MONTH FROM Posted_date::date)
ORDER BY EXTRACT(MONTH FROM Posted_date::date);

-- Average application window (days between posting and deadline)
SELECT AVG(application_deadline - posting_date) AS Avg_Application_Window_Days
FROM AI_Jobs;


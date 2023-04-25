SELECT * FROM dbo.parental_leave;

-- Finding industries with the most weeks paid maternity leave

SELECT industry, ROUND(AVG(paid_maternity_leave),0) AS avg_paid_maternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A'
GROUP BY industry
ORDER BY avg_paid_maternity_leave_industry DESC;

-- Finding industries with the least weeks paid maternity leave

SELECT industry, ROUND(AVG(paid_maternity_leave),0) AS avg_paid_maternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A'
GROUP BY industry
ORDER BY avg_paid_maternity_leave_industry ASC;

-- Finding industries with the most weeks unpaid maternity leave

SELECT industry, ROUND(AVG(unpaid_maternity_leave),0) AS avg_unpaid_maternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A'
GROUP BY industry
ORDER BY avg_unpaid_maternity_leave_industry DESC;

-- Finding industries with the least weeks unpaid maternity leave

SELECT industry, ROUND(AVG(unpaid_maternity_leave),0) AS avg_unpaid_maternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A' AND unpaid_maternity_leave IS NOT NULL
GROUP BY industry
ORDER BY avg_unpaid_maternity_leave_industry ASC;

-- Finding industries with the most weeks paid paternity leave

SELECT industry, ROUND(AVG(paid_paternity_leave),0) AS avg_paid_paternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A'
GROUP BY industry
ORDER BY avg_paid_paternity_leave_industry DESC;

-- Finding industries with the least weeks paid paternity leave

SELECT industry, ROUND(AVG(paid_paternity_leave),0) AS avg_paid_paternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A' AND paid_paternity_leave IS NOT NULL
GROUP BY industry
ORDER BY avg_paid_paternity_leave_industry ASC;

-- Finding industries with the most weeks unpaid paternity leave

SELECT industry, ROUND(AVG(unpaid_paternity_leave),0) AS avg_unpaid_paternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A'
GROUP BY industry
ORDER BY avg_unpaid_paternity_leave_industry DESC;

-- Finding industries with the least weeks unpaid paternity leave

SELECT industry, ROUND(AVG(unpaid_paternity_leave),0) AS avg_unpaid_paternity_leave_industry FROM dbo.parental_leave
WHERE industry != 'N/A' AND unpaid_paternity_leave IS NOT NULL
GROUP BY industry
ORDER BY avg_unpaid_paternity_leave_industry ASC;

-- Companies with less than 2 weeks paid maternity leave

SELECT company, industry, paid_maternity_leave FROM dbo.parental_leave
WHERE paid_maternity_leave < 2
ORDER BY paid_maternity_leave DESC;

-- Number of companies with less than 2 weeks paid_maternity_leave

SELECT COUNT(company) AS num_companies_less_than_2_weeks FROM dbo.parental_leave
WHERE paid_maternity_leave < 2;

-- Number of companies with less than 6 weeks paid_maternity_leave

SELECT COUNT(company) AS num_companies_less_than_6_weeks FROM dbo.parental_leave
WHERE paid_maternity_leave < 6;

-- Number of companies with a year of paid maternal leave

SELECT COUNT(company) AS num_companies_one_year FROM dbo.parental_leave
WHERE paid_maternity_leave >= 52;

-- Companies with a year of paid maternal leave

SELECT company, paid_maternity_leave AS companies_one_year FROM dbo.parental_leave
WHERE paid_maternity_leave >= 52;

-- Companies with the highest paid_maternity_leave

SELECT company, paid_maternity_leave FROM dbo.parental_leave
ORDER BY paid_maternity_leave DESC;

-- Companies with 6+ months paid_maternity_leave and under 1 year

SELECT company, paid_maternity_leave AS companies_one_year FROM dbo.parental_leave
WHERE paid_maternity_leave >= 24 AND paid_maternity_leave < 52 
ORDER BY paid_maternity_leave DESC;




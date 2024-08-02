select * from bank_loan_data

--- Total Loan Applications ---
select count(id) as Total_Loan_Application from bank_loan_data

select count(id) as MTD_Total_Loan_Application from bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

select count(id) as PMTD_Total_Loan_Application from bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--(MTD - PMTD)/PMTD--
SELECT 
    ((CAST(MTD_Total_Loan_Application AS DECIMAL) - CAST(PMTD_Total_Loan_Application AS DECIMAL)) / 
    CAST(PMTD_Total_Loan_Application AS DECIMAL)) * 100 AS Percentage_Change
FROM 
    (
        SELECT 
            (SELECT COUNT(id) 
             FROM bank_loan_data 
             WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021) AS MTD_Total_Loan_Application,
            (SELECT COUNT(id) 
             FROM bank_loan_data 
             WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021) AS PMTD_Total_Loan_Application
    ) AS subquery;

--- Total Funded Amount ---
SELECT SUM(loan_amount) as Total_Funded_Amount FROM bank_loan_data

SELECT SUM(loan_amount) as MTD_Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT SUM(loan_amount) as PMTD_Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--- Total Amount Received ---
SELECT SUM(total_payment) as Total_Amount_Received FROM bank_loan_data

SELECT SUM(total_payment) as MTD_Total_Amount_Received FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT SUM(total_payment) as PMTD_Total_Amount_Received FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--- Average Interest Rate ---
SELECT ROUND(AVG(int_rate), 4) * 100 as Avg_Interest_Rate FROM bank_loan_data

SELECT ROUND(AVG(int_rate), 4) * 100 as MTD_Avg_Interest_Rate FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT ROUND(AVG(int_rate), 4) * 100 as PMTD_Avg_Interest_Rate FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--- Average Debt-to-Income Ratio (DTI) ---
SELECT ROUND(AVG(dti), 4) * 100 as Avg_DTI FROM bank_loan_data

SELECT ROUND(AVG(dti), 4) * 100 as MTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT ROUND(AVG(dti), 4) * 100 as PMTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--- Bank Loan Status ---
SELECT loan_status FROM bank_loan_data

--- Good Loan v Bad Loan KPIs ---
--- Good Loan Application Percentage ---
SELECT 
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
	/
	COUNT(id) as Good_loan_Percentage
FROM bank_loan_data

--- Good Loan Applications ---
SELECT COUNT(id) as Good_loan_Applications FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--- Good Loan Funded Amount ---
SELECT SUM(loan_amount) as Good_loan_Funded_Amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--- Good Loan Total Received Amount ---
SELECT SUM(total_payment) as Good_loan_Recieved_Amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

--- Bad Loan Application Percentage ---
SELECT 
	(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0)
	/
	COUNT(id) as Bad_loan_Percentage
FROM bank_loan_data

--- Bad Loan Applications ---
SELECT COUNT(id) as Bad_loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--- Bad Loan Funded Amount ---
SELECT SUM(loan_amount) as Bad_loan_Funded_Amount FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--- Bad Loan Total Received Amount ---
SELECT SUM(total_payment) as Bad_loan_Recieved_Amount FROM bank_loan_data
WHERE loan_status = 'Charged Off'

--- Loan Status ---
SELECT
        loan_status,
        COUNT(id) AS Total_Loan_Applications,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        bank_loan_data
    GROUP BY
        loan_status

-- Monthly Loan Status --
SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status

--- BANK LOAN REPORT | OVERVIEW ---
--- MONTH ---
SELECT 
	MONTH(issue_date) AS Month_No, 
	DATENAME(MONTH, issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)

--- STATE ---
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY Total_Funded_Amount DESC

--- TERM ---
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term

--- EMPLOYEE LENGTH ---
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC

--- PURPOSE ---
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY Total_Loan_Applications DESC

--- HOME OWNERSHIP ---
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY Total_Loan_Applications DESC

--- See the results when we hit the Grade A in the filters for dashboards. ---
SELECT 
	home_ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A' AND address_state = 'CA'
GROUP BY home_ownership
ORDER BY Total_Loan_Applications DESC










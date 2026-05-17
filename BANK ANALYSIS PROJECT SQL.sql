                             # BANK ANALYSIS 
                             #   TEAM - 5
	#Year wise loan amount Stats
    
SELECT
issue_year as loan_year,
count(*) as total_loans,
sum(funded_amnt) as Total_loan_amount
from data_2
group by issue_year
UNION ALL
select 
"Total" as loan_year,
count(*)as total_loans,
sum(funded_amnt) as Total_loan_amount
from data_2
order by loan_year;


#Grade and sub grade wise revol_bal


SELECT
GRADE,
SUB_GRADE,
SUM(REVOL_BAL) AS TOTAL_REVOL_BAL
FROM DATA_2
group by GRADE,SUB_GRADE
order by GRADE,SUB_GRADE;



#Total Payment for Verified Status Vs Total Payment for Non Verified Status



SELECT 
verification_status,
SUM(funded_amnt) AS TOTAL_PAYMENT
FROM DATA_2
group by verification_status;



#State wise and month wise loan status


SELECT 
addr_state,
date_format(issue_D,'%M') AS Months,
loan_status,
COUNT(*) AS TOTAL_LOANS
FROM DATA_2
GROUP BY addr_state,months,loan_status
ORDER BY addr_state,months,loan_status;




#Home ownership Vs last payment date stats



SELECT
    c.home_ownership,
    COUNT(*) AS total_customers,
    MIN(p.last_pymnt_d) AS earliest_payment,
    MAX(p.last_pymnt_d) AS latest_payment,
    COALESCE(TIMESTAMPDIFF(MONTH, MIN(p.last_pymnt_d), MAX(p.last_pymnt_d)), 0) AS months_between_earliest_and_latest
FROM data_2 AS c
 JOIN data_3 AS p
    ON c.id = p.id
GROUP BY c.home_ownership
ORDER BY total_customers DESC;












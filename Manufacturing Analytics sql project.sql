Create Database Manufacturing;
Use `Manufacturing`;
 -- 1. Manufactured Qty and Rejected Qty
Select sum(`Manufactured Qty`) as`Manufactured Qty`,
sum(`Rejected Qty`) as`Rejected Qty`
from `manufacturing analysis`;

-- Rounding Up
SELECT 
    CONCAT(ROUND(SUM(`Manufactured Qty`) / 1000000, 2), ' M') AS `Manufactured Qty`,
    CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K')     AS `Rejected Qty`
FROM `manufacturing analysis`;

-- 2. Wastage Qty %
select concat(Round((Sum(`Rejected Qty`)/SUM(`Processed Qty`)*100),2), "%") 
as `Wastage Qty`
from `manufacturing analysis`;

-- 3. Total Employees and Machines
select count(DISTINCT `Emp Name`) as `Total No of Employees`, 
count(DISTINCT `Machine Name`) as `Total No of Machines` 
from `manufacturing analysis`;

-- 4. Top 10 Employees wise Rejected Qty
Drop view RejectedQty_wise_Top_10_Employees;
create view RejectedQty_wise_Top_10_Employees as
Select `Emp Name`, CONCAT(ROUND(SUM(`Rejected Qty`)/1000 , 2),"K") as`Rejected Qty`
from `manufacturing analysis`
group by `Emp Name`
order by `Rejected Qty` desc
limit 10;

Select * from RejectedQty_wise_Top_10_Employees;


select `Emp Name`, Total_rejected from 
(select `Emp Name`, SUM(`Rejected Qty`) AS Total_rejected,
Dense_Rank() over(order by SUM(`Rejected Qty`) desc) as rnk
from `manufacturing analysis`
group by `Emp Name`) t
where rnk < 10;

-- 5. View - Top 10 Machines Rejected Qty
SELECT `Machine Name`,
       CONCAT(ROUND(total_rejected / 1000, 2), ' K') AS `Rejected Qty`
FROM (
    SELECT `Machine Name`,
           SUM(`Rejected Qty`) AS total_rejected,
           DENSE_RANK() OVER (ORDER BY SUM(`Rejected Qty`) DESC) AS rnk
    FROM `manufacturing analysis`
    GROUP BY `Machine Name`
) t
WHERE rnk <= 10
ORDER BY total_rejected DESC;


-- 6. Department wise Manufactured Qty & Rejected Qty
select `Department Name`, CONCAT(ROUND(SUM(`Manufactured Qty`) / 1000000, 2), ' M') as`Manufactured Qty`,
CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K') as`Rejected Qty`
From `manufacturing analysis`
group by `Department Name`;

-- 7. Date wise Manufactured Qty & Rejected Qty
select `Doc Date` as Date , 
CONCAT(ROUND(SUM(`Manufactured Qty`) / 1000000, 2), ' M') as`Manufactured Qty`,
CONCAT(ROUND(SUM(`Rejected Qty`) / 1000, 2), ' K') as`Rejected Qty`
From `manufacturing analysis`
group by `Date`
order by `Date`;

-- 8. Count of Rejected Qty & Unrejected Qty  
 select    
    case 
        when `Rejected Qty` > 0 then 'Rejected QTY'
        else 'Unrejected QTY'
    end AS Rejection_status,
    count(`Emp Name`) `No of Qty`
from `manufacturing analysis`
group by rejection_status;

-- 9. Create Store Procedure - 
DELIMITER $$
USE `manufacturing`$$
CREATE PROCEDURE `EmployeeDetails` (`Employee Name` varchar(50) )
BEGIN
select *from `manufacturing analysis`
where `Emp name` = `Employee Name`;
END$$

-- call EmployeeDetails ( 'raj kumar');



-- 10. index


CREATE INDEX cust_code
ON `manufacturing analysis` (`Cust Code`(10));



SELECT `Cust Code`,`Cust Name`, `Buyer`, `Department Name`
FROM `manufacturing analysis`
WHERE `Cust Code` = 'C000589';


-- 11. after insert tigger
DELIMITER $$

CREATE TRIGGER manufacturing_analysis_after_insert
AFTER INSERT ON `manufacturing analysis`
FOR EACH ROW
BEGIN

INSERT INTO insert_log(cust_code, cust_name, inserted_at)
VALUES (NEW.`Cust Code`, NEW.`Cust Name`, NOW());

END $$

DELIMITER ;

CREATE TABLE IF NOT EXISTS insert_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cust_code VARCHAR(50),
    cust_name VARCHAR(255),
    inserted_at DATETIME
);

INSERT INTO `manufacturing analysis` (`Cust Code`, `Cust Name`)
VALUES ('C000999', 'Mitesh');
select * from Insert_log;














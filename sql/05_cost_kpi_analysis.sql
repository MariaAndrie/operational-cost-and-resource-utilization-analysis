--- =========================================================
-- project 2: operational cost & resource utilization analysis
-- file: 05_cost_kpi_analysis.sql
-- purpose: provide reference kpi checks for power bi measures
-- =========================================================


-- =========================================================
-- 1. 2025 executive kpi summary
-- =========================================================

select sum(c.budget) as total_budget,
sum(c.actual_cost) as total_actual_cost,
sum(c.actual_cost) - sum(c.budget) as total_budget_variance,
round((sum(c.actual_cost) - sum(c.budget)) / sum(c.budget),4) as budget_variance_rate,
sum(cap.available_hours) as total_available_hours,
sum(cap.worked_hours) as total_worked_hours,
round(sum(cap.worked_hours) / sum(cap.available_hours),4) as utilization_rate,
sum(cap.overtime_hours) as total_overtime_hours,
round(sum(cap.overtime_hours) / sum(cap.worked_hours),4) as overtime_rate,
round(avg(cap.fte),2) as avg_fte
from fact_costs c
join fact_capacity cap on c.month_start = cap.month_start and c.team_id = cap.team_id and c.region_id = cap.region_id
where year(c.month_start) = 2025;

/*
total_budget	total_actual_cost	total_budget_variance	budget_variance_rate	total_available_hours	total_worked_hours	utilization_rate	total_overtime_hours	overtime_rate	avg_fte
38734608.06		40205676.44			1471068.38				0.0380					897200.0				91359.2				0.8820				8736.6					0.0110			23.36
*/

-- =========================================================
-- 2. yearly kpi comparison
-- =========================================================

select year(c.month_start) as year, 
sum(c.budget) as total_budget,
sum(c.actual_cost) as total_actual_cost,
sum(c.actual_cost) - sum(c.budget) as total_budget_variance,
round((sum(c.actual_cost) - sum(c.budget)) / sum(c.budget),4) as budget_variance_rate,
sum(cap.available_hours) as total_available_hours,
sum(cap.worked_hours) as total_worked_hours,
round(sum(cap.worked_hours) / sum(cap.available_hours),4) as utilization_rate,
sum(cap.overtime_hours) as total_overtime_hours,
round(sum(cap.overtime_hours) / sum(cap.worked_hours),4) as overtime_rate,
round(avg(cap.fte),2) as avg_fte
from fact_costs c
join fact_capacity cap on c.month_start = cap.month_start and c.team_id = cap.team_id and c.region_id = cap.region_id
group by year
order by year;

/*
year	total_budget	total_actual_cost	total_budget_variance	budget_variance_rate	total_available_hours	total_worked_hours	utilization_rate	total_overtime_hours	overtime_rate	avg_fte
2024	38615641.03		39025931.25			410290.22				0.0106					897376.0				787681.8			0.8778				1917.1					0.0024			23.37
2025	38734608.06		40205676.44			1471068.38				0.0380					897200.0				91359.2				0.8820				8736.6					0.0110			23.36
*/

-- =========================================================
-- 3. 2025 cost category summary
-- =========================================================

select cost_category, sum(budget_amount) as total_budget, 
sum(actual_amount) as total_actual_cost, 
sum(actual_amount) - sum(budget_amount) as budget_variance,
round((sum(actual_amount) - sum(budget_amount)) / sum(budget_amount),4) as budget_variance_rate
from fact_cost_details
where year(month_start) = 2025
group by cost_category
order by budget_variance desc; 

/*
cost_category	total_budget	total_actual_cost	budget_variance	budget_variance_rate
salary			27082368.22		27983720.69			901352.47		0.0333
contractors		5826804.29		6114490.84			287686.55		0.0494
software		3114366.59		3298936.84			184570.25		0.0593
training		1545375.26		1598108.20			52732.94		0.0341
travel			1165693.70		1210419.87			44726.17		0.03847
*/

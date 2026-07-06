-- =========================================================
-- project: operational cost & resource utilization analysis
-- file: 04_business_logic_validation.sql
-- purpose: validate business scenarios for cost and resource analysis
-- =========================================================
use operations_analytics_db;
-- =========================================================
-- 1. validate monthly cost and utilization ranges
-- =========================================================


select c.month_start, c.team_id, t.team_name, c.region_id, r.region_name, c.budget, c.actual_cost, 
round(c.actual_cost - c.budget,2) as budget_variance, 
round((c.actual_cost - c.budget) / c.budget,4) as budget_variance_rate, cap.fte, cap.available_hours, 
cap.worked_hours, cap.overtime_hours, 
round(cap.worked_hours / cap.available_hours, 4) as utilization_rate, 
round(cap.overtime_hours / cap.worked_hours, 4) as overtime_rate 
from fact_costs c
join fact_capacity cap on c.month_start = cap.month_start and c.team_id = cap.team_id and c.region_id = cap.region_id
join dim_team t on c.team_id = t.team_id
join dim_region r on c.region_id = r.region_id
order by month_start,team_id, region_id; 



/*
month_start		team_id	team_name				region_id	region_name		budget		actual_cost	budget_variance	budget_variance_rate	fte		available_hours	worked_hours	overtime_hours	utilization_rate	overtime_rate  
2024-01-01		1		IT Service Desk			1			Nordics			174660.60	170886.97	-3773.63		-0.0216					28.1	4496.0			4154.6			0.0				0.9241				0.0000
2024-01-01		1		IT Service Desk			2			Western Europe	300848.16	299693.14	-1155.02		-0.0038					47.9	7664.0			6668.2			0.0				0.8701				0.0000
2024-01-01		1		IT Service Desk			3			Central Europe	232566.00	234987.31	2421.31			0.0104					39.2	6272.0			5700.5			0.0				0.9089				0.0000
2024-01-01		1		IT Service Desk			4			UK & Ireland	164888.32	164292.11	-596.21			-0.0036					25.9	4144.0			3474.1			0.0				0.8383				0.0000
2024-01-01		2		Application Support		1			Nordics			163021.60	153088.90	-9932.70		-0.0609					22.6	3616.0			2669.0			0.0				0.7381				0.0000
2024-01-01		2		Application Support		2			Western Europe	229564.66	236159.58	6594.92			0.0287					31.9	5104.0			4627.2			0.0				0.9066				0.0000
2024-01-01		2		Application Support		3			Central Europe	212060.96	212580.23	519.27			0.0024					29.3	4688.0			4054.5			0.0				0.8649				0.0000
2024-01-01		2		Application Support		4			UK & Ireland	140248.69	142842.20	2593.51			0.0185					19.4	3104.0			2663.3			0.0				0.8580				0.0000
...
*/

-- =========================================================
-- 2. identify months with both overspend and high utilization
-- =========================================================


select c.month_start, c.team_id, t.team_name, c.region_id, r.region_name, c.budget, c.actual_cost, 
round(c.actual_cost - c.budget,2) as budget_variance, 
round((c.actual_cost - c.budget) / c.budget,4) as budget_variance_rate, 
cap.fte, cap.available_hours, cap.worked_hours, cap.overtime_hours, 
round(cap.worked_hours / cap.available_hours, 4) as utilization_rate, 
round(cap.overtime_hours / cap.worked_hours, 4) as overtime_rate 
from fact_costs c
join fact_capacity cap on c.month_start = cap.month_start and c.team_id = cap.team_id and c.region_id = cap.region_id
join dim_team t on c.team_id = t.team_id
join dim_region r on c.region_id = r.region_id
where cap.worked_hours > cap.available_hours and c.actual_cost > c.budget
order by budget_variance desc; 

/*
month_start		team_id	team_name				region_id			region_name		budget		actual_cost	budget_variance	budget_variance_rate	fte		available_hours	worked_hours	overtime_hours	utilization_rate	overtime_rate  
2025-05-01		4		Network Operations				2			Western Europe 	177065.77	219137.56	42071.79		0.2376					22.5	3600.0			4404.7			804.7			1.2235				0.1827
2025-08-01		4		Network Operations				2			Western Europe	186486.01	220205.04	33719.03		0.1808					22.9	3664.0			4175.8			511.8			1.1397				0.1226
2025-08-01		4		Network Operations				3			Central Europe	160522.64	193358.37	32835.73		0.2046					20.6	3296.0			3717.9			421.9			1.1280				0.1135
2025-07-01		4		Network Operations				3			Central Europe	184641.31	217413.44	32772.13		0.1775					22.7	3632.0			4173.2			541.2			1.1490				0.1297
2025-06-01		4		Network Operations				3			Central Europe	165647.78	197051.20	31403.42		0.1896					21.0	3360.0			3940.5			580.5			1.1728				0.1473
2025-07-01		4		Network Operations				1			Nordics			120619.99	149124.58	28504.59		0.2363					15.1	2416.0			2767.6			351.6			1.1455				0.1270
2025-07-01		4		Network Operations				2			Western Europe	176126.07	203551.48	27425.41		0.1557					22.6	3616.0			3810.5			194.5			1.0538				0.0510
2025-06-01		4		Network Operations				4			UK & Ireland	104466.66	130046.24	25579.58		0.2449					13.4	2144.0			2691.0			547.0			1.2551				0.2033
2025-08-01		4		Network Operations				4			UK & Ireland	105585.52	130273.64	24688.12		0.2338					13.6	2176.0			2531.3			355.3			1.1633				0.1404
...

*/


-- =========================================================
-- 3. summarize overspend and overload by team
-- =========================================================

select c.team_id, t.team_name, count(*) as overloaded_overspend_months,
round(sum(c.actual_cost - c.budget),2) as total_budget_variance,
round(avg((c.actual_cost - c.budget) / c.budget),4) as avg_budget_variance_rate,
round(avg(cap.worked_hours / cap.available_hours),4) as avg_utilization_rate,
round(sum(cap.overtime_hours),2) as total_overtime_hours
from fact_costs c
join dim_team t on c.team_id = t.team_id
join fact_capacity cap on c.team_id = cap.team_id and c.region_id = cap.region_id and c.month_start = cap.month_start
where c.actual_cost > c.budget and cap.worked_hours > cap.available_hours
group by c.team_id, t.team_name
order by total_budget_variance desc;

/*
team_id	team_name					overloaded_overspend_months	total_budget_variance	avg_budget_variance_rate	avg_utilization_rate	total_overtime_hours
4		Network Operations			19							455120.43				0.1654						1.1419					7859.6
1		IT Service Desk				4							52003.30				0.0507						1.0400					1021.7
3		Infrastructure Operations	4							51384.71				0.0789						1.0749					922.8
2		Application Support			2							24685.73				0.0566						1.0350					273.4
5		Workplace Support			3							5660.18					0.0193						1.0193					123.1
    
*/

-- =========================================================
-- 4. summarize overspend and overload by region
-- =========================================================

select c.region_id, r.region_name, count(*) as overloaded_overspend_months,
round(sum(c.actual_cost - c.budget),2) as total_budget_variance,
round(avg((c.actual_cost - c.budget) / c.budget),4) as avg_budget_variance_rate,
round(avg(cap.worked_hours / cap.available_hours),4) as avg_utilization_rate,
round(sum(cap.overtime_hours),2) as total_overtime_hours
from fact_costs c
join dim_region r on c.region_id = r.region_id
join fact_capacity cap on c.team_id = cap.team_id and c.region_id = cap.region_id and c.month_start = cap.month_start
where c.actual_cost > c.budget and cap.worked_hours > cap.available_hours
group by c.region_id, r.region_name
order by total_budget_variance desc;


/*
region_id	region_name		overloaded_overspend_months	total_budget_variance	avg_budget_variance_rate	avg_utilization_rate	total_overtime_hours
3			Central Europe	12							228806.58				0.1067						1.0795					3655.8
2			Western Europe 	7							163465.52				0.1209						1.0939					2556.7
4			UK & Ireland	8							113466.74				0.1275						1.1166					2193.0
1			Nordics			5							83115.51				0.1370						1.1477					1795.1
*/

-- =========================================================
-- 5. summarize budget variance by cost category
-- =========================================================

select cost_category, 
round(sum(budget_amount),2) as total_budget,
round(sum(actual_amount),2) as total_actual_cost,
round(sum(actual_amount - budget_amount),2) as total_budget_variance,
round((sum(actual_amount - budget_amount))/sum(budget_amount),4) as budget_variance_rate
from fact_cost_details
group by cost_category
order by total_budget_variance desc;


/*
cost_category	total_budget	total_actual_cost	total_budget_variance	budget_variance_rate
salary			54116553.43		55283010.60			1166457.17				0.0216
contractors		11617481.32		11958891.09			341409.77				0.0294
software		6205737.95		6469376.97			263639.02				0.0425
training		3087571.57		3149373.42			61801.85				0.0200
travel			2322904.82		2370955.61			48050.79				0.0207
*/

-- =========================================================
-- 6. identify contractor cost overruns
-- =========================================================

select cd.month_start, cd.team_id, t.team_name, cd.region_id, r.region_name,
cd.budget_amount as contractor_budget,
cd.actual_amount as contractor_actual_cost,
round(cd.actual_amount - cd.budget_amount,2) as contractor_variance,
round((cd.actual_amount - cd.budget_amount) / cd.budget_amount,4) as contractor_variance_rate
from fact_cost_details cd
join dim_team t on cd.team_id = t.team_id
join dim_region r on cd.region_id = r.region_id
where cd.cost_category = 'contractors' and cd.actual_amount > cd.budget_amount
order by contractor_variance desc;

/*
month_start		team_id	team_name				region_id	region_name		contractor_budget	contractor_actual_cost	contractor_variance	contractor_variance_rate
2025-05-01		4		Network Operations		2			Western Europe	26830.24			1013.68					14183.44			0.5286
2025-05-01		4		Network Operations		3			Central Europe	25427.08			37614.25				12187.17			0.4793
2025-08-01		4		Network Operations		3			Central Europe	23957.46			35656.82				11699.36			0.4883
2025-06-01		4		Network Operations		2			Western Europe	27930.53			39249.27				11318.74			0.4052
2025-07-01		4		Network Operations		1			Nordics			18467.14			28417.39				9950.25				0.5388
2025-06-01		4		Network Operations		3			Central Europe	24667.44			33851.73				9184.29				0.3723
2025-08-01		4		Network Operations		2			Western Europe	26041.61			35192.99				9151.38				0.3514
    ...
*/


-- =========================================================
-- 7. validate yearly cost and utilization comparison
-- =========================================================

select year(cap.month_start) as year, 
round(sum(c.budget),2) as total_budget,
round(sum(c.actual_cost),2) as total_actual_cost, 
round(sum(c.actual_cost - c.budget),2) as total_budget_variance,
round(sum(c.actual_cost - c.budget) / sum(c.budget),4) as budget_variance_rate,
round(sum(cap.worked_hours) / sum(cap.available_hours),4) as utilization_rate,
round(sum(cap.overtime_hours),2) as total_overtime_hours,
round(sum(cap.overtime_hours)/sum(cap.worked_hours),4) as overtime_rate
from fact_capacity cap
join fact_costs c on cap.month_start = c.month_start and cap.team_id = c.team_id and cap.region_id = c.region_id
group by year
order by year;


/*
year	total_budget	total_actual_cost	total_budget_variance	budget_variance_rate	utilization_rate	total_overtime_hours	overtime_rate
2024	38615641.03		39025931.25			410290.22				0.0106					0.8778				1917.1					0.0024
2025	38734608.06		40205676.44			1471068.38				0.0380					0.8820				8736.6					0.0110
*/


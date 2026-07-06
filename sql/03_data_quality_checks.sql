-- =========================================================
-- Project: Operational Cost & Resource Utilization Analysis
-- File: 03_data_quality_checks.sql
-- Purpose: Validate cost and capacity data before KPI analysis
-- =========================================================
 use operations_analytics_db;

-- =========================================================
-- 1. Check row counts for Project core tables
-- =========================================================
select 'fact_capacity' as table_name, count(*) as row_count
from fact_capacity

union all

select 'fact_costs' as table_name, count(*) as row_count
from fact_costs

union all

select 'fact_cost_details' as table_name, count(*) as row_count
from fact_cost_details

union all

select 'fact_tickets' as table_name, count(*) as row_count
from fact_tickets;

/*
table_name			row_count
fact_capacity		480
fact_costs			480
fact_cost_details	2400
fact_tickets		121557
*/


-- =========================================================
-- 2. check uniqueness of monthly team-region grain
-- =========================================================

select 'fact_capacity' as table_name, month_start, team_id, region_id, count(*) as row_count
from fact_capacity
group by month_start, team_id, region_id
having count(*) > 1

union all

select 'fact_costs' as table_name, month_start, team_id, region_id, count(*) as row_count
from fact_costs
group by month_start, team_id, region_id 
having count(*) > 1;

/*
table_name	month_start	team_id	region_id	row_count
*/
 
-- =========================================================
-- 3. check cost category completeness
-- =========================================================

select month_start, team_id, region_id, count(*) as category_row_count
from fact_cost_details
group by month_start, team_id, region_id 
having count(*) <> 5
or count(distinct cost_category) <> 5;

/*
month_start	team_id	region_id	category_row_count
*/

-- =========================================================
-- 4. check cost detail totals against fact_costs
-- =========================================================

select d.month_start, d.team_id, d.region_id, 
round(sum(budget_amount)-c.budget,2) as budget_delta, 
round(sum(actual_amount)-c.actual_cost,2) as actual_cost_delta
from fact_cost_details d
join fact_costs c
on d.month_start = c.month_start and d.team_id = c.team_id and d.region_id = c.region_id
group by d.month_start, d.team_id, d.region_id,c.budget, c.actual_cost
having budget_delta <> 0 or actual_cost_delta <> 0;

/*
month_start	team_id	region_id	budget_delta	actual_cost_delta
*/

-- =========================================================
-- 5. check capacity value validity
-- =========================================================

select * from fact_capacity
where fte <0 or available_hours < 0 or worked_hours < 0 or overtime_hours < 0 or worked_hours > (available_hours + overtime_hours);

/*
month_start	team_id	region_id fte	available_hours	worked_hours	overtime_hours
*/




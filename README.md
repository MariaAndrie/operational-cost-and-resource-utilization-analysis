# Operational Cost & Resource Utilization Analysis

## Overview

This project analyzes operational cost, budget variance, resource utilization, overtime, and cost drivers in an IT Operations environment.

The goal is to show how SQL and Power BI can support cost control, capacity planning, and operational efficiency decisions.

**Status:** SQL analysis completed. Power BI dashboard in progress.

## Business Questions

- Are teams operating within budget?
- Which cost categories are driving cost overruns?
- How did 2025 performance compare with 2024?
- Are higher costs connected to resource pressure and overtime?
- Where should management focus cost control and capacity planning?

## Tools

- MySQL
- SQL
- Power BI

## Data Model

Main tables used:

- `fact_costs`
- `fact_cost_details`
- `fact_capacity`
- `fact_tickets`
- `dim_team`
- `dim_region`
- `dim_date`

The dataset covers **2024–2025** and represents a synthetic IT Operations environment.

## SQL Work Completed

Files:

- `sql/03_data_quality_checks.sql`
- `sql/04_business_logic_validation.sql`
- `sql/05_cost_kpi_analysis.sql`

Completed SQL work includes:

- Data quality checks
- Cost and capacity validation
- Budget vs actual analysis
- Resource utilization checks
- Overtime analysis
- Cost category analysis
- 2025 vs 2024 KPI comparison

## Key KPIs

- Total Budget
- Total Actual Cost
- Budget Variance
- Budget Variance Rate
- Resource Utilization Rate
- Overtime Hours
- Overtime Rate
- Average FTE
- Cost Category Variance

## Key Findings from SQL Analysis

| KPI | 2024 | 2025 |
|---|---:|---:|
| Total Budget | 38.62M | 38.73M |
| Total Actual Cost | 39.03M | 40.21M |
| Budget Variance | 410.29K | 1.47M |
| Budget Variance Rate | 1.06% | 3.80% |
| Utilization Rate | 87.78% | 88.20% |
| Overtime Hours | 1,917.1 | 8,736.6 |
| Overtime Rate | 0.24% | 1.10% |

Main observations:

- 2025 shows significantly higher cost pressure than 2024.
- Budget variance increased from **410.29K** to **1.47M**.
- Overtime hours increased more than four times while average FTE stayed almost flat.
- Salary was the largest absolute cost variance driver.
- Software had the highest relative variance rate in 2025.
- Contractor costs were the second-largest cost variance driver.

## 2025 Cost Category Summary

| Cost Category | Budget Variance | Variance Rate |
|---|---:|---:|
| Salary | 901.35K | 3.33% |
| Contractors | 287.69K | 4.94% |
| Software | 184.57K | 5.93% |
| Training | 52.73K | 3.41% |
| Travel | 44.73K | 3.84% |

## Power BI Dashboard

Power BI dashboard is currently in progress.

Planned pages:

1. Executive Cost Overview
2. Resource Utilization
3. Cost Drivers
4. Team / Region Efficiency

## Project Structure

```text
operational-cost-resource-utilization-analysis/
│
├── data/
│   ├── dim_date.csv
│   ├── fact_tickets.csv
│   ├── fact_csat.csv
│   └── ...
│
├── sql/
│   ├── 03_data_quality_checks.sql
│   ├── 04_business_logic_validation.sql
│   └── 05_cost_kpi_analysis.sql
│
├── powerbi/
│   └── Operational_Cost_Resource_Utilization.pbix
│
├── images/
│   ├── one.png
│   └── two.png
│
└── README.md
```

## Project Purpose

This project demonstrates practical Operations Analytics skills:

- SQL-based data validation
- Cost control analysis
- Budget variance analysis
- Resource utilization analysis
- Capacity and overtime analysis
- KPI preparation for Power BI reporting

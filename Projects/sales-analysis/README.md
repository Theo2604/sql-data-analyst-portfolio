# Sales & Revenue Analysis

## Overview
This project analyzes sales performance using PostgreSQL and visualizes key business insights in Power BI.  
The goal is to understand revenue trends, growth patterns, and key revenue drivers.

## Tools & Technologies
- PostgreSQL (CTEs, JOINs, subqueries, window functions)
- Power BI (dashboards and KPI visualization)
- GitHub (project versioning and documentation)

## Key Analyses
- Monthly revenue trends and month-over-month growth
- Revenue breakdown by region, product, and customer
- Average Order Value (AOV)

## Data Workflow
1. Sales data analyzed in PostgreSQL using advanced SQL techniques
2. Final analytical tables exported to CSV
3. Dashboards built in Power BI using the exported datasets

## Key SQL Techniques Used
- Common Table Expressions (CTEs)
- Window functions (`LAG`)
- Multi-table JOINs
- Aggregations and subqueries

## Dashboard Preview
![Sales Dashboard](<img width="922" height="447" alt="page_1_sales_performance_overview" src="https://github.com/user-attachments/assets/8fbc4551-a3ff-45d2-9df3-c3741951313c" />
)

## Repository Structure

<pre>
sales-analysis/
├── sql/
│   ├── sales_analysis.sql
│   ├── schema.sql
│   └── sample_data.sql
├── data/
│   ├── monthly_revenue_metrics.csv
│   ├── dimension_revenue_metrics.csv
│   └── kpi_metrics.csv
├── powerbi/
│   ├── sales_dashboard.pbix
│   └── dashboard_preview.png
└── README.md
</pre>

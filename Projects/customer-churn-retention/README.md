# Customer Churn & Retention Analysis

## Overview
This project focuses on customer retention and churn behavior using transactional data.
The analysis identifies retention trends, churn levels, and overall customer stability over time.

## Tools & Technologies
- PostgreSQL (CTEs, window functions, date logic)
- Power BI (retention and churn dashboards)
- GitHub (documentation and portfolio presentation)

## Key Analyses
- Monthly active customers and retained customers
- Customer churn identification based on inactivity
- Churn rate as a key performance indicator

## Data Workflow
1. Customer activity analyzed in PostgreSQL
2. Retention and churn metrics calculated using CTEs and window functions
3. Final datasets exported to CSV
4. Power BI used for trend and KPI visualization

## Key SQL Techniques Used
- Common Table Expressions (CTEs)
- Window functions (`LAG`)
- Date-based filtering
- Subqueries for churn calculations

## Dashboard Preview
![Churn Dashboard](powerbi/dashboard_preview.png)

## Repository Structure

<pre>
project-1-sales-analysis/
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

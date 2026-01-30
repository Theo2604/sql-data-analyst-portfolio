# Funnel & Conversion Analysis

## Overview
This project analyzes user behavior through a multi-step funnel to identify drop-off points
and measure conversion efficiency across different stages.

## Tools & Technologies
- PostgreSQL (CTEs, window functions, funnel logic)
- Power BI (funnel and conversion dashboards)
- GitHub (project documentation)

## Key Analyses
- User counts per funnel step
- Conversion rates between funnel stages
- Overall conversion rate from visit to purchase

## Data Workflow
1. User event data analyzed in PostgreSQL
2. Funnel metrics calculated using CTEs and window functions
3. Final funnel datasets exported to CSV
4. Power BI used to visualize funnel performance and KPIs

## Key SQL Techniques Used
- Common Table Expressions (CTEs)
- Window functions (`LAG`)
- Funnel analysis logic
- Aggregations and conditional calculations

## Dashboard Preview
![Funnel Dashboard](powerbi/dashboard_preview.png)

## Repository Structure

<pre>
funnel-conversion-analysis/
├── sql/
│   ├── funnel_conversion_analysis.sql
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

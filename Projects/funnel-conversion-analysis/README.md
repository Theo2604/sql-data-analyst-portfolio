# Funnel & Conversion Analysis (PostgreSQL)

## Objective
Analyze user behavior through a conversion funnel to identify drop-off points and conversion rates.

## Funnel Steps
1. Signup
2. View Product
3. Add to Cart
4. Purchase

## Business Questions
- How many users complete each funnel step?
- Where do users drop off?
- What are the conversion rates between steps?
- How long does it take users to convert?

## Tools
- PostgreSQL
- SQL (CTEs, subqueries, aggregations, filters)

## Key Metrics
- Funnel conversion rates
- Drop-off counts
- Time to purchase

## Techniques Used
- Common Table Expressions (CTEs)
- Conditional aggregation
- FILTER clause
- Date arithmetic

## Insights
- Largest drop-off occurs between product view and add to cart
- Users who add items to cart have high purchase intent
- Faster purchases correlate with higher funnel completion

## Next Steps
- Segment funnel by signup month
- Analyze funnel by traffic source
- Visualize funnel in BI tools


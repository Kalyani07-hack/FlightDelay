# Flight Price & Operations Analysis — End-to-End Project
### Python → SQL → Power BI

A complete end-to-end data analytics project analyzing **300,000+ Indian flight records** — from raw data cleaning in Python, structured querying 
and KPI engineering in SQL, to an interactive Power BI dashboard.

Project Overview

This project analyzes Indian domestic flight data covering 6 airlines, 6 source cities, and 6 destination cities to uncover pricing patterns, 
delay trends, airline reliability, route performance, and airport congestion — delivering actionable business intelligence through custom-built KPI scores.

End-to-End Pipeline
```
Raw CSV Data
    ↓
Python (Data Cleaning & Preprocessing)
    ↓
MySQL (EDA + Views + Custom KPI Engineering)
    ↓
Power BI (Interactive Dashboard & Visualization)
```

Custom Business KPIs Engineered

### 1. Airline Reliability Score
Weighted formula combining early arrivals (30%), on-time rate 
(50%), cancellation rate (10%), and diversion rate (10%):

### 2. Delay Risk Index
Weighted scoring — severe delays (>60 min) score 3, moderate (16–60 min) score 2, minor (1–15 min) score 1, on-time scores 0.

### 3. Aircraft Reliability Index
Same weighted formula as Airline Reliability Score applied at the aircraft type level.

### 4. Airport Congestion Index
Combines flight volume with average delay to measure how congested each origin airport is.

### 5. Route Stability Score
Weighted formula penalizing cancellations and diversions while rewarding on-time departures per route.

 Skills Demonstrated

- End-to-End Data Pipeline (Python → SQL → Power BI)
- Data Cleaning & Preprocessing (Python/Pandas)
- SQL Indexing for Query Optimization
- View & Table Creation in MySQL
- Advanced Aggregations & CASE WHEN logic
- Custom Business KPI Engineering
- Interactive Dashboard Design (Power BI)
- Data Storytelling & Business Insight Generation

ub.com/your-username)

# SME Consulting Services Dataset – Insight Summary

## Overview

This analysis evaluates the operational and financial performance of a service-based SME using a consulting services dataset. The focus is on revenue generation, efficiency, and cash flow risk.

---

## Key Observations

### 1. Revenue Performance

* Total revenue generated: **R11,804,850**
* **Data Analysis** is the highest revenue-generating service, indicating it is the most commercially valuable offering.

---

### 2. Service Efficiency

* Revenue per hour varies significantly across services
* This suggests:

  * Inconsistent pricing strategies, OR
  * Differences in operational efficiency

---

### 3. Cash Flow Risk

* Average payment delay: **~90 days**
* This indicates:

  * Significant cash flow pressure
  * Potential liquidity risks for the business

---

### 4. Client Risk Segmentation

* Certain clients have significantly higher payment delays
* These clients represent **high-risk accounts** that may negatively impact financial stability

---

### 5. Geographic Performance

* Revenue varies by city
* **Cape Town** contributes the highest share of revenue

**Insight:**

* Demand is geographically concentrated
* Opportunity exists for targeted expansion strategies

---

### 6. Data Quality Issues

* The `HoursWorked` field contained:

  * Non-numeric values
  * Text-based entries
  * Ranges and mixed formats

**Impact:**

* Inaccurate billing
* Unreliable performance measurement

---

### 7. Data Cleaning Solution

* A custom parsing function was developed to:

  * Convert text-based and inconsistent entries into numeric values
  * Standardize time data across the dataset

**Result:**

* Improved data quality
* Enabled accurate calculation of efficiency metrics

---

### 8. Consultant Performance

* Revenue per hour varies across consultants
* Indicates:

  * Differences in productivity
  * Potential inefficiencies in resource allocation

---

### 9. Invoice Status & Financial Health

* A portion of invoices remain:

  * Pending
  * Overdue

**Insight:**

* Reinforces existing cash flow challenges
* Highlights need for improved receivables management

---

## 🧠 Conclusion

The business demonstrates strong revenue generation but faces key operational and financial challenges:

* Inefficient pricing and service delivery
* Poor data quality impacting decision-making
* Significant cash flow risk due to delayed payments

Addressing these issues can improve:

* Profitability
* Cash flow stability
* Operational efficiency

---

## 🚀 Business Implication

This analysis highlights the importance of:

* Accurate operational data
* Monitoring revenue efficiency (revenue per hour)
* Managing client payment behavior proactively

These insights form a foundation for building financial intelligence systems for SMEs.

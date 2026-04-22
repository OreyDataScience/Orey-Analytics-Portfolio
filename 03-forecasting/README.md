# Orey Analytics – Financial Forecasting & Risk Intelligence Project

## 1. Project Overview
This project addresses a critical problem faced by many SMEs:
> **Strong revenue growth does not always translate into healthy cash flow or financial stability.**

Businesses often:
- Rely on **historical revenue trends** without forward visibility  
- Lack **predictive insights** for planning  
- Underestimate **cash flow risk from delayed payments**  
- Fail to detect **early signs of margin pressure**

### Objective:
To build a **data-driven financial intelligence solution** that:
- Forecasts **revenue, profit, and payment delays**
- Quantifies **forecast uncertainty (confidence intervals)**
- Identifies **client-level payment risk**
- Translates analytics into **actionable business insights**

---

## 2. Approach

### Data Preparation
- Cleaned and transformed raw transactional data using **R (tidyverse)**
- Standardized:
  - Numeric financial fields (Revenue, Cost, Profit)
  - Categorical variables (Customer, Segment, Channel)
- Converted daily transactions into **monthly aggregated time series**
- Engineered key features:
  - Revenue growth rate  
  - 3-month moving average (trend smoothing)  
  - Average payment delay  

---

### Time Series Modeling

#### Model Used:
- **Seasonal ARIMA (Auto ARIMA)** from the `forecast` package

#### Why ARIMA?
- Captures:
  - **Trend**
  - **Seasonality**
  - **Autocorrelation structure**
- Automatically selects optimal parameters → efficient & robust
- Suitable for **financial time series with recurring patterns**

---

### Statistical Validation

The model was rigorously tested using:

- **Train/Test Split (last 3 months as test set)**
- **ACF/PACF analysis** → to understand lag relationships  
- **Stationarity testing (Phillips-Perron Test)**  
- **Residual diagnostics (Ljung-Box test)**  

Result: Residuals showed **no autocorrelation**, confirming model validity  

---

### Forecasting Outputs

Generated:
- **Revenue Forecast (3 months ahead)**
- **Profit Forecast**
- **Payment Delay Forecast**
- **95% Confidence Intervals**

---

### Risk Modeling (Key Differentiator)

Developed a **Client Risk Segmentation Model**:

Clients classified into:
- Low Risk  
- Moderate Risk  
- High Risk  

Based on:
- Average payment delay  
- Late payment behavior  
- Revenue contribution  

Also calculated:
- Revenue exposure by risk tier  
- Client distribution by risk  

---

### Dashboard Integration (Power BI)

Built an executive dashboard featuring:

- Revenue vs Forecast (with confidence intervals)
- Payment Delay Trend with risk thresholds
- Risk Distribution (client & revenue exposure)
- Key Risks & Strategic Recommendations
- KPI cards (Growth, Delay, Forecast Accuracy)

---

## 3. Key Results

### Revenue Performance
- Sustained **~9.2% monthly growth**
- Forecasted revenue:
  - **R8.1M – R8.9M per month**
- Confidence Interval:
  - **R7.6M – R9.4M**

---

### Model Accuracy
- **MAPE:** ~2.7% (high accuracy)
- **RMSE:** ~R300K  
- **Theil’s U:** 0.42  
- **Ljung-Box p-value:** 0.29 (no autocorrelation)

Indicates **strong predictive reliability**

---

### Trend & Seasonality
- Stable long-term trend
- Seasonal variation of **±R500K**
- Short-term sensitivity requires adaptive planning

---

### Cash Flow Risk Insights
- **62% of revenue** tied to moderate-to-high risk clients  
  - 52.1% Moderate Risk  
  - 9.9% High Risk  
- Average payment delay:
  - **~12 days (persistent structural issue)**

---

### ⚠ Profitability Signal
- Profit stable at **~R3.6M/month**
- Not scaling with revenue → **early margin pressure**

---

## 4. Business Impact

### Key Insight:
> **Revenue growth is strong, but cash flow quality is weakening.**

---

### Risks Identified
- Cash flow compression  
- Seasonal volatility (±R500K)  
- Client concentration risk  
- Margin lag vs revenue growth  
- Forecast overestimation bias (~6%)  

---

### Strategic Value Delivered

This solution enables businesses to:

#### 1. Improve Cash Flow Management
- Identify high-risk clients early  
- Implement risk-based credit policies  
- Reduce delayed payments  

#### 2. Make Better Financial Decisions
- Use forecasts for:
  - Budgeting  
  - Hiring  
  - Inventory planning  

#### 3. Reduce Risk Exposure
- Rebalance customer portfolio  
- Prioritize low-risk, high-value clients  

#### 4. Enhance Financial Stability
- Align cost structure with revenue volatility  
- Prepare for seasonal fluctuations  

---

### Dashboard Impact (Orey Analytics Product Vision)

The dashboard transforms raw data into:

- **Predictive insights**
- **Risk visibility**
- **Executive decision support**

Moving SMEs from:
> “What happened?”  

To:
> “What will happen — and what should we do about it?”

---

## Final Summary

This project demonstrates how **advanced time series forecasting + risk analytics** can bridge the gap between:

Revenue growth  
Cash flow reality  

By combining:
- Forecasting  
- Risk segmentation  
- Executive dashboards  

It delivers a **practical financial intelligence system** aligned with the vision of **Orey Analytics**.

---

## Next Steps

- Extend forecast horizon (6–12 months)  
- Introduce **machine learning models (XGBoost, Prophet)**  
- Build **real-time data pipelines**  
- Develop **SME Financial Health Index (Orey Analytics product)**  

## Author

Oreneile Katlego Ncaba – Orey Analytics

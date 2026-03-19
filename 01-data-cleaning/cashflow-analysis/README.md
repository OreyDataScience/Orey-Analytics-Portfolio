# Cashflow Analysis – SME Financial Data

## Problem

Small and medium enterprises (SMEs) often struggle with cashflow visibility due to messy and unstructured financial data.

## Objective

To clean and analyze SME cashflow data and extract meaningful financial insights that support better decision-making.

## Tools Used

* R (tidyverse, dplyr, lubridate)
* Data cleaning techniques
* Financial analysis

## Approach

* Converted inconsistent date formats into a standard format
* Standardized categorical variables (City, Payment Method, Description)
* Created a monthly variable for time-based analysis
* Aggregated data to calculate:

  * Monthly net cashflow
  * Income vs expenses
  * Category-level performance
  * City-level performance

## Key Insights

* Business operated at an overall **net loss (-364,735)** over 3 months
* Cashflow was negative in January and February, with recovery in March
* High operational costs across multiple categories, especially consulting and travel
* Some high-revenue categories are still unprofitable
* Cape Town is both the highest revenue generator and highest cost center

## Project Structure

* `data/raw/` → Original dataset
* `data/cleaned/` → Cleaned dataset
* `scripts/` → R analysis script
* `outputs/` → Insight summary

## Outcome

This project demonstrates the ability to transform raw financial data into structured insights, forming the foundation for SME financial intelligence systems.


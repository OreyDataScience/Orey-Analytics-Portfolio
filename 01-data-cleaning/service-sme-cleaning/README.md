# Service-based SME Analysis – Consulting Dataset

## Problem

Service-based SMEs often struggle with inconsistent operational data, delayed payments, and limited visibility into service profitability and consultant performance.

## Objective

To clean and analyze a consulting services dataset in order to uncover insights related to revenue generation, operational efficiency, and cash flow risks.

## Tools Used

* R (tidyverse, dplyr, stringr)
* Data cleaning and transformation techniques
* Custom parsing functions for inconsistent data

## Approach

* Cleaned and standardized inconsistent data formats, particularly in the `HoursWorked` field
* Converted mixed-format time entries into numeric values using a custom parsing function
* Analyzed:

  * Total revenue and revenue by service
  * Revenue per hour (efficiency metric)
  * Payment delays and invoice status
  * Client-level payment behavior
  * Geographic revenue distribution
  * Consultant performance

## Key Insights

* Data Analysis is the highest revenue-generating service
* Significant variation exists in revenue per hour across services
* Average payment delay is approximately 90 days, creating cash flow pressure
* Certain clients exhibit high payment delays, posing financial risk
* Consultant productivity varies significantly based on revenue per hour

## Project Structure

* `data/raw/` → Original consulting dataset
* `data/cleaned/` → Cleaned and standardized dataset
* `scripts/` → R scripts used for cleaning and analysis
* `outputs/` → Insight summary and results

## Outcome

This project demonstrates the ability to clean complex operational data and extract insights that highlight inefficiencies, financial risks, and opportunities for improving SME performance.


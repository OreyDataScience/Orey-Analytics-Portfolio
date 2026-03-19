###############################################################################
#Orey Analytics
#Mini Project 3: Messy Cashflow Ledger Dataset
###############################################################################
setwd("E:/Business/Orey Analytics/Operations/Data Cleaning Mastery/Raw Data")

library(tidyverse)
library(lubridate)

# 1. Loading the dataset
cashflow <- read_csv("SME Cashflow Ledger.csv")

# 2. Inspecting dataset
glimpse(cashflow)
summary(cashflow)

# 3. Fixing data types and standardizing casing
cashflow <- cashflow %>%
  mutate(
    Date = parse_date_time(Date, orders = c("d b Y", "Y-m-d", "d/m/Y")),
    City = str_to_title(City),
    PaymentMethod = str_to_title(PaymentMethod),
    Description = str_to_title(Description)
  )

# 4. Checking for missing values
colSums(is.na(cashflow))

# 5. Creating a useful column
cashflow <- cashflow %>%
  mutate(
    Month = format(Date, "%Y-%m")
  )

# 6. Cashflow Metrics
 # 6.1. Monthly Net Cashflow
 MonthlyCF <- cashflow %>%
   group_by(Month) %>%
   summarise(NetCF = sum(Amount))

 # 6.2. Net cashflow per Category
 cashflow %>%
   group_by(Category) %>%
   summarise(Total = sum(Amount)) %>%
   arrange(desc(Total))
 
 # 6.3. Top expenses
 cashflow %>%
   group_by(Category) %>%
   filter(Type == "Expense") %>%
   summarise(Total = sum(Amount)) %>%
   arrange(desc(Total))

 # 6.4. Top income generators
 cashflow %>%
   filter(Type == "Income") %>%
   group_by(Category) %>%
   summarise(Total = sum(Amount)) %>%
   arrange(desc(Total))
 
 # 6.5. Income vs Expenses
 cashflow %>%
   group_by(Type) %>%
   summarise(Total = sum(Amount))
 
# 7. City metrics
 # 7.1. Income generated per City
 cashflow %>%
   group_by(City) %>%
   filter(Type == "Income") %>%
   summarise(Total = sum(Amount)) %>%
   arrange(desc(Total))
 
 # 7.2. Expenses per City
 cashflow %>%
   group_by(City) %>%
   filter(Type == "Expense") %>%
   summarise(Total = sum(Amount)) %>%
   arrange(desc(Total))
 
# 8. Exporting clean dataset
 write_csv(cashflow, "Clean SME Cashflow Ledger.csv")

# 9. Insight Summary
summary_text <- "
SME Cashflow Ledger - Insight Summary

Dataset overview
The analysis covers a 3-month period (January–March) of SME transactional cashflow data.


Key observations
1. The business experienced 2 consecutive months of negative cashflow before recovering in March this indicates 
   early liquidity pressure, possible seasonality or delayed revenue inflows.

2. The business is operating at a net loss over the period. Despite a strong March, it did not fully recover prior
   losses. Could be a temporary recovery masking underlying structural inefficiency.

3. Expenses are highly distributed across categories (not just one driver) indicating a broad operational cost base 
   and potential lack of cost control across multiple areas.

4. Only 1 category (Marketing) is meaningfully profitable. Core operational categories (Consulting, Travel, Software) 
   are destroying value and the business is spending heavily in areas that are not generating proportional returns.

5. Revenue is well-distributed (diversified) but high revenue does not equal high profitability as high-income 
   categories are still net negative, for example, Consulting generates high income but is still the biggest 
   loss-maker.

6. Cape Town is the largest revenue generator but also the largest cost center. It may be the main operational hub 
   but is potentially inefficient or expensive to run.


Key Risk Indicators
1. Sustained negative cashflow (2 out of 3 months are negative)

2. Structural loss (Overall net loss despite strong revenue)

3. Inefficient cost allocation (High spending in low-return categories)

4. Geographic cost pressure (Cape Town heavily impacting profitability)

Strategic Interpretation
The business is not suffering from a lack of revenue but it is suffering from inefficiency in converting revenue 
into profit.

This suggests:
1. Weak cost management
2. Poor ROI tracking per category
3. Possible over-investment in operations


Conclusion
The SME shows strong revenue-generating capability but lacks financial efficiency and cost discipline, resulting 
in an overall loss position.

Without intervention:
1. Continued losses are likely
2. Cashflow instability may persist
"
writeLines(summary_text, "SME Cashflow Ledger Insight Summary.txt")  

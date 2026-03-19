###############################################################################
#Orey Analytics
#Mini Project 1: Messy Retail Dataset
###############################################################################
setwd("E:/Business/Orey Analytics/Operations/Data Cleaning Mastery/Raw Data")

library(tidyverse)
library(lubridate)

# 1. Import data
retail <- read_csv("SME POS Sales.csv")

# 2. Inspecting the dataset
glimpse(retail)
summary(retail)

# 3. Fixing incorrect data types
retail <- retail %>%
  mutate(
    #Converting Date
    Date = parse_date_time(Date, orders = c("d b Y", "Y-m-d", "d/m/Y")),
    
    #Converting categorical variables
    City = as.factor(City),
    Product = as.factor(Product),
    Category = as.factor(Category),
    PaymentMethod = as.factor(PaymentMethod),
    Cashier = as.factor(Cashier),
    
    #Converting ID variables to factors
    TransactionID = as.factor(TransactionID),
    StoreID = as.factor(StoreID),
    ProductID = as.factor(ProductID),
    CustomerID = as.factor(CustomerID)
  )
 
# 4. Cleaning text columns by standardizing casing
retail <- retail %>%
  mutate(
    City = str_to_title(City),
    Product = str_to_title(Product),
    Category = str_to_title(Category),
    PaymentMethod = str_to_title(PaymentMethod),
    Cashier = str_to_title(Cashier)
  )

# 5. Re-inspecting structure
glimpse(retail)

# 6. Checking for missing values
colSums(is.na(retail))

# 7. Checking for duplicates across all columns
sum(duplicated(retail))

# 8. Validating revenue calculation
 #Create Exepected Revenue Column
 retail$ExpectedRevenue <- retail$Price * retail$Quantity * (1 - retail$Discount/100)

 #Comparing with stated Revenue and finding mismatches
 summary(retail$ExpectedRevenue)
 summary(retail$Revenue)
 
 retail[retail$Revenue != retail$ExpectedRevenue, ] 
 
# 9. Checking for outliers
retail[retail$Revenue > quantile(retail$Revenue, 0.99), ] 
retail[retail$Revenue < quantile(retail$Revenue, 0.01), ] 

# 10. Quick Distributions
table(retail$StoreID)
table(retail$Quantity)
table(retail$Discount)
table(retail$PaymentMethod)

# 11. Quick Exploratory Statistics
aggregate(Revenue ~ City, retail, sum)
aggregate(Revenue ~ StoreID, retail, sum)
aggregate(Revenue ~ Product, retail, sum)

# 12. Exporting Cleaned dataset
write_csv(retail, "Clean SME POS Sales.csv")

###############################################################
#Creating the Insight Summary
###############################################################

# 1. Loading the Cleaned dataset
clean_retail <- read_csv("Clean SME POS Sales.csv")

 str(clean_retail)
 summary(clean_retail)
 #Cleaned dataset contains 2000 transactions across 15 variables
 #Representing retail POS sales activity
 
# 2. Calculating total revenue
 sum(clean_retail$Revenue) 
 #The dataset records R2,186,028 in total retail sales revenue

# 3. Identifying top categories
library(dplyr)
 
 clean_retail %>%
   group_by(Category) %>%
   summarise(total_revenue = sum(Revenue)) %>%
   arrange(desc(total_revenue))
 #Electronics generated the highest revenue among all categories.
 #Responsible for 95.28% of the total 
 
# 4. Identifying top Cities
 clean_retail %>%
   group_by(City) %>%
   summarise(total_revenue = sum(Revenue)) %>%
   arrange(desc(total_revenue))
 #Cape Town generated the highest revenue amongst all cities.
 #Accounts for 39.52% of the total revenue
 #JHB, PTA and Durban all generated similar revenue. 
 
# 5. Identifying most common payment method
 clean_retail %>%
   count(PaymentMethod)
 #Card and EFT were the most frequently used payment methods
 #They account for 40.1% and 39.85% of payment methods used respectively 
 #Cash was the least used payment method accounting for 20.05%
 
# 6. Checking busiest sale periods
 clean_retail %>%
   group_by(Date) %>%
   summarise(daily_sales = sum(Revenue))
 #Sales activity varied across the dataset, with several peak transaction days
 
# 7. Creating Insight Summary
summary_text <- "
Retail SME POS Sales Dataset - Insight Summary

Dataset Overview
The Cleaned dataset contains retail POS transactions ready for analysis

Key Observations
- Total revenue calculated from transactions
- City generating most revenue identified
- Top sellling category identified
- Most common payment method identified
- Sales activity across sales period identified

Conclusion
The dataset is now clean, consistent and ready for further analysis
"

writeLines(summary_text, "Retail SME Insight Summary.txt")  
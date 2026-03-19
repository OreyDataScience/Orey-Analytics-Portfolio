###############################################################################
#Orey Analytics
#Mini Project 2: Messy Consulting Services Dataset
###############################################################################
setwd("E:/Business/Orey Analytics/Operations/Data Cleaning Mastery/Raw Data")


library(tidyverse)
library(lubridate)

# 1. Importing data
services <- read_csv("SME Consulting Services.csv")

# 2. Inspecting data
glimpse(services)
summary(services)

# 3. Fixing HoursWorked Column
# 3.1. Words to number
words_to_num <- c(
  "zero"=0,"one"=1,"two"=2,"three"=3,"four"=4,"five"=5,
  "six"=6,"seven"=7,"eight"=8,"nine"=9,"ten"=10,
  "eleven"=11,"twelve"=12,"thirteen"=13,"fourteen"=14,
  "fifteen"=15,"sixteen"=16,"seventeen"=17,"eighteen"=18,
  "nineteen"=19,"twenty"=20
)

# 3.2. Function to convert words inside text
replace_words <- function(text) {
  text <- str_to_lower(text)
  
  for (w in names(words_to_num)) {
    text <- str_replace_all(text, paste0("\\b", w, "\\b"), as.character(words_to_num[[w]]))
  }
  return(text)
}

# 3.3. Main parsing function
parse_hours <- function(x) {
  
  if (is.na(x) || str_trim(x) == "" || str_to_lower(x) %in% 
      c("na", "n/a", "none")) {
    return(NA_real_)
  }
  
  x_clean <- replace_words(x)
  x_clean <- str_to_lower(x_clean)
  
  # Handle fractions
  x_clean <- str_replace_all(x_clean, "\\bhalf\\b", "0.5")
  x_clean <- str_replace_all(x_clean, "\\bquarter\\b", "0.25")
  
  # Case 1: Ranges
  if (str_detect(x_clean, "\\d+\\.?\\d*\\s*(-|to)\\s*\\d+\\.?\\d*")) {
    nums <- str_extract_all(x_clean, "\\d+\\.?\\d*")[[1]]
    return(mean(as.numeric(nums), na.rm = TRUE))
  }
  
  # Case 2: Any numbers present
  nums <- str_extract_all(x_clean, "\\d+\\.?\\d*")[[1]]
  
  if (length(nums) > 1) {
    return(mean(as.numeric(nums), na.rm = TRUE))
  }
  
  if (length(nums) == 1) {
    return(as.numeric(nums))
  }
  
  return(NA_real_)
}
  
# 3.4. Applying to HoursWorked
services$HoursWorked <- sapply(services$HoursWorked, parse_hours)

 #Checking for any missing values
sum(is.na(services$HoursWorked))

# 4. Fixing data types
services <- services %>%
  mutate(
    # 4.1. Fixing dates
    DueDate = parse_date_time(DueDate, orders = c("d b Y", "Y-m-d", "d/m/Y")),
    InvoiceDate = parse_date_time(InvoiceDate, orders = c("d b Y", "Y-m-d", "d/m/Y")),
    
    # 4.2. Standardizing
    City = str_to_title(City),
    PaymentStatus = str_to_title(PaymentStatus),
    Consultant = str_to_title(Consultant),
    Industry = str_to_title(Industry),
    ServiceType = str_to_title(ServiceType)
  )

# 5. Checking for missing values
colSums(is.na(services))

# 6. Checking for duplicates across all columns
sum(duplicated(services))

# 7. Business Metrics
 # 7.1. Revenue Metrics
  #Total Revenue 
  sum(services$InvoiceAmount) 
  
  #Revenue per hour
  services <- services %>%
    mutate(RevenuePerHour = as.numeric(InvoiceAmount/HoursWorked))
 
  #Revenue by City
  services %>%
    group_by(City) %>%
    summarise(TotalRevenue = sum(InvoiceAmount))

  #Revenue by ServiceType
  services %>%
   group_by(ServiceType) %>%
   summarise(TotalRevenue = sum(InvoiceAmount)) %>%
   arrange(desc(TotalRevenue))
 
  #Revenue by Industry
  services %>%
   group_by(Industry) %>%
   summarise(TotalRevenue = sum(InvoiceAmount))
 
 # 7.2. Consumer & Employee Metrics  
  #Top Clients
  services %>%
   group_by(ClientName) %>%
   summarise(TotalRevenue = sum(InvoiceAmount)) %>%
   arrange(desc(TotalRevenue))
 
  #Consultant Performance
  services %>%
   group_by(Consultant) %>%
   summarise(
     TotalRevenue = sum(InvoiceAmount),
     AvgEfficiency = mean(RevenuePerHour, na.rm = TRUE))

 # 7.3. Payment Metrics
  #Payment Delays
  services <- services %>%
    mutate(PaymentDelay = as.numeric(DueDate - InvoiceDate))

  #Payment Behaviors
  services %>%
   group_by(PaymentStatus) %>%
   summarise(count = n())
 
  services %>%
   summarise(AvgDelay = mean(PaymentDelay, na.rm = TRUE))
 
  #High-Risk Clients (Late Payers)
  services %>%
    group_by(ClientName) %>%
    summarise(AvgDelay = mean(PaymentDelay, na.rm = TRUE)) %>%
    arrange(desc(AvgDelay))
 
# 8. Exporting Cleaned dataset
write_csv(services, "Clean SME Consulting Services.csv")
    
# 9. Insight Summary
summary_text <- "
SME Consulting Services Dataset - Insight Summary

Key Observations

1. Total revenue generated was R11,804,850, with Data Analysis contributing the largest share,
   indicating it is the most commercially valuable service offering.

2. Revenue per hour varied across services, suggesting potential inconsistencies in pricing 
   strategies or differences in operational efficiency.

3. The average payment delay was approximately 90 days, highlighting significant cash flow 
   challenges and potential risks to financial stability.
   
4. Certain clients exhibit significantly higher payment delays than others, identifying them 
   as high-risk accounts that may negatively impact cash flow.   

5. Revenue generation varied across cities, with Cape Town contributing the highest share. 
   This indicates geographic concentration of demand and presents opportunities for targeted 
   business expansion.

6. Inconsistencies were identified in the HoursWorked field, including non-numeric and 
   mixed-format entries. This reflects weak operational data capture, which can lead to 
   inaccurate billing and unreliable performance tracking.

7. A custom parsing function was developed to standardise inconsistent time entries, including
   text-based inputs, ranges, and mixed formats. This significantly improved data quality and 
   enabled accurate calculation of key performance metrics.
   
8. Consultant performance varied when measured by revenue generated per hour, indicating 
   differences in productivity and potential inefficiencies in resource allocation.
   
9. A portion of invoices remain in pending or overdue status, further highlighting cash flow 
   management challenges within the business. 
"

writeLines(summary_text, "Consulting Service SME Insight Summary.txt") 

###################################
#Orey Analytics
#Visualization & Storytelling: Cashflow Analysis
###################################
setwd("E:/Business/Orey Analytics/Operations/Data Cleaning Mastery/Clean Data")

#Loading libraries
library(tidyverse)
library(lubridate)
library(scales)

#Import clean data
cashflow <- read_csv("Clean SME Cashflow Ledger (Corrected).csv")

#Creating revenue and expense columns
cashflow <- cashflow %>%
  mutate(
    Revenue = ifelse(Type == "Income", Amount, 0),
    Expense = ifelse(Type == "Expense", abs(Amount), 0)
  )

#Aggregate by date
cashflow_daily <- cashflow %>%
  group_by(Date) %>%
  summarise(
    Revenue = sum(Revenue, na.rm = TRUE),
    Expense = sum(Expense, na.rm = TRUE)
  ) %>%
  mutate(Profit = Revenue - Expense)

#Revenue vs Expenses over time
cashflow_daily %>%
  pivot_longer(cols = c(Revenue, Expense),
               names_to = "Type",
               values_to = "Amount") %>%
  ggplot(aes(x = Date, y = Amount, color = Type)) +
  geom_line(linewidth = 1.2) +
  labs(
    title = "Revenue vs Expenses Over Time",
    x = "Date",
    y = "Amount (R)"
  ) +
  scale_y_continuous(labels = scales::label_comma(prefix = "R")) +
  scale_color_manual(values = c("Revenue" = "blue", "Expense" = "red")) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.title = element_blank()
  )

#Profit trend overtime
ggplot(cashflow_daily, aes(x = Date, y = Profit)) +
  geom_line(color = "darkgreen", linewidth = 1.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Profit Trend Over Time",
    x = "Date",
    y = "Profit (R)"
  ) +
  scale_y_continuous(labels = scales::label_comma(prefix = "R")) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

#Monthly growth %
monthly <- cashflow_daily %>% 
  mutate(Month = floor_date(Date, "month")) %>% 
  group_by(Month) %>% 
  summarise(Revenue = sum(Revenue)) %>% 
  arrange(Month) %>% 
  mutate(Growth = (Revenue - lag(Revenue)) / lag(Revenue))

ggplot(monthly %>% filter(!is.na(Growth)), aes(x = Month, y = Growth)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = scales::percent(Growth, accuracy = 0.1)),
            vjust = -0.5, size = 3) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_date(
    limits = c(as.Date("2026-01-15"), as.Date("2026-03-31")),
    date_breaks = "1 month",
    date_labels = "%b"
  ) +
  labs(
    title = "Monthly Revenue Growth (%)",
    x = "Month",
    y = "Growth"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 10))

#Top 5 Categories
top_products <- cashflow %>% 
  group_by(Category) %>% 
  summarise(Total_Revenue = sum(Revenue, na.rm = TRUE)) %>% 
  arrange(desc(Total_Revenue)) %>% 
  slice_head(n = 5)

ggplot(top_products, aes(x = reorder(Category, Total_Revenue), y = Total_Revenue)) +
  geom_col(fill = "darkgreen") +
  geom_text(aes(label = scales::label_comma(prefix = "R")(Total_Revenue)),
            vjust = -0.5, hjust = 0.5, size = 3) +
  labs(
    title = "Top 5 Revenue-Generating Categories",
    x = "Category",
    y = "Total Revenue (R)"
  ) +
  scale_y_continuous(labels = scales::label_comma(prefix = "R")) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 14)
  )

#Profit margin by Category
profit_margin <- cashflow %>% 
  group_by(Category) %>% 
  summarise( 
    Revenue = sum(Revenue, na.rm = TRUE), 
    Expense = sum(Expense, na.rm = TRUE) 
    ) %>% 
  mutate( 
    Profit = Revenue - Expense, 
    Profit_Margin = Profit / Revenue 
    )

ggplot(profit_margin, aes(x = reorder(Category, Profit_Margin), y = Profit_Margin)) +
  geom_col(fill = "purple") +
  geom_text(aes(label = scales::percent(Profit_Margin, accuracy = 0.1)),
            vjust = -0.5, hjust = 0.5, size = 3) +
  labs(
    title = "Profit Margin by Category",
    x = "Category",
    y = "Profit Margin"
  ) +
  scale_y_continuous(labels = scales::percent) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 14)
  )

#Expense breakdown
cashflow %>%
  filter(Type == "Expense") %>%
  group_by(Category) %>%
  summarise(Total = sum(Expense)) %>%
  ggplot(aes(x = reorder(Category, Total), y = Total)) +
  geom_col(fill = "red") +
  geom_text(aes(label = scales::label_comma(prefix = "R")(Total)),
            vjust = -0.5, hjust = 0.5, size = 2) +
  labs(
    title = "Expense Breakdown by Category",
    x = "Category",
    y = "Total Expenses (R)"
  ) +
  scale_y_continuous(labels = scales::label_comma(prefix = "R")) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold", size = 14)
  )

#Insight summary
summary_text <- "
Cashflow Analysis Visualizations - Insight Summary

Revenue vs Expenses Over Yime
1. What is happening
Revenue and expenses remain close throughout the period, with expenses exceeding revenue in January and February, 
resulting in losses. In March, revenue surpasses expenses, indicating a shift toward profitability.

2. Why this matters
This shows that the business was operating on a loss initially but has started to recover. The narrowing gap between 
between revenue and expenses suggests improving financial efficiency or increased income generation.

3. Decision
Focus on sustaining the March performance by reinforcing revenue drivers and maintaining control over expenses to 
to ensure continued profitability.


Profit Trend Over Time
1. What is happening
The business recorded consistent losses in January (-R448120) and February (-R302172), followed by a significant profit 
in March (+R385557), indicating a strong upward trend.

2. Why it matters
This trend signals a potential turning point in the business. The reduction in losses followed by profitability 
suggests that recent changes (cost control or increased sales) are working.

3. Decision
Identify and replicate the factors that drove March profitability (Marketing, reduced expenses) to maintain and scale 
positive performance.


Monthly Growth (%)
1. What is happening
Revenue growth is undefined for January (baseline), followed by a 6.2% decline in February and a strong increase of 12.1% 
in March, indicating accelerating revenue performance.

2. Why it matters
The February decline signals a short-term contraction in revenue, which may point to demand fluctuations, operational 
inefficiencies, or external factors affecting sales. However, the strong rebound in March suggests the business was able 
to recover quickly, indicating resilience and the presence of effective revenue drivers.

3. Decision
Investigate the cause of the February decline to prevent recurrence, while identifying and reinforcing the factors that 
drove March growth (high-performing categories or improved sales activity) to sustain and scale revenue momentum.


Top 5 Revenue Generating Categories and Profit Margins by Categories
1. What is happening
Revenue is diversified across several categories but despite them generating high revenues some are still unprofitable 
with Marketing being the only meaningfully profitable one.

2. Why it matters
This indicates that revenue alone is not translating into profitability, not all revenue is valuable. High-revenue but 
low-margin (or loss-making) categories may be consuming significant resources, ultimately contributing to the overall 
net loss. Relying on such categories can create the illusion of growth while weakening financial health.

3. Decision
Priotitize and scale the Marketing category due to its strong profitability, while conducting a cost and pricing review 
of the other categories. 
Actions should include: 
- Reducing costs in underperforming categories
- Adjusting pricing strategies
- Potentially discontinuing consistently unprofitable segments


Expenses Breakdown by Category
1. Expenses are spread across multiple categories, with most categories exhibiting disproportionately high costs relative 
to the revenue they generate, indicating inefficient cost allocation and potential overspending in underperforming areas.

2. Why it matters
This imbalance directly impacts profitability, as excessive spending in low-return categories erodes margins and contributes 
to overall financial losses. If left unaddressed, it can strain cash flow, limit reinvestment into high-performing areas, 
and reduce the business’s ability to scale sustainably.

3. Decision
Investigate and optimize high-expense categories by:
- Reducing unnecessary spending
- Improving operational efficiency
- Renegotiating service costs


Final Summary Insight
The business experienced early stage losses but shows clear signs of recovery, with March making a shift to profitability.
Revenue growth and improving profit trends suggest positive momentum, but cost management and category-level profitability 
remain critical to sustaining long-term financial health.
"

writeLines(summary_text, "Cashflow Analysis Insight Summary.txt")  

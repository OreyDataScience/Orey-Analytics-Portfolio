###############################################################################
#Orey Analytics
#Forecasting: Sales dataset
###############################################################################
library(tidyverse)
library(lubridate)
library(forecast)

setwd("E:/Business/Orey Analytics/Portfolio Building/Forecasting/Clean Data")
sales <- read_csv("Sales Dataset.csv")

#Fix date format
sales$Date <- as.Date(sales$Date)

#Formatting columns for PowerBI (Encountered Errors when dashboarding)
sales <- sales %>%
  mutate(
    #Converting numerical values to numeric
    Revenue = as.numeric(Revenue),
    Cost = as.numeric(Cost),
    Profit = as.numeric(Profit),
    Invoice_Amount = as.numeric(Invoice_Amount),
    Discount = as.numeric(Discount),
    Tax = as.numeric(Tax),
    
    #Converting ID & Categorical variables to factors
    Transaction_ID = as.factor(Transaction_ID),
    Product_Category = as.factor(Product_Category),
    Payment_Method = as.factor(Payment_Method),
    Customer_ID = as.factor(Customer_ID),
    Customer_Segment = as.factor(Customer_Segment),
    Sales_Rep = as.factor(Sales_Rep),
    Channel = as.factor(Channel)
  )

#Aggregate data to monthly
monthly_data <- sales %>%
  mutate(Month = floor_date(Date, "month")) %>%
  group_by(Month) %>%
  summarise(
    Revenue = sum(Revenue),
    Profit = sum(Profit),
    Avg_Delay = mean(Payment_Delay_Days)
  ) %>%
  arrange(Month)

#Time series object
ts_revenue <- ts(monthly_data$Revenue,
                 start = c(year(min(monthly_data$Month)),
                           month(min(monthly_data$Month))),
                 frequency = 12)

#Visualizing the time series
plot(ts_revenue,
     main = "Monthly Revenue Time Series",
     ylab = "Revenue",
     xlab = "Time")

#Adding trend (moving average)
monthly_data <- monthly_data %>%
  mutate(MA_3 = sapply(seq_along(Revenue), function(i) {
    if (i < 3) NA else mean(Revenue[(i-2):i])
  }))

plot(monthly_data$Month, monthly_data$Revenue, type = "l")
lines(monthly_data$Month, monthly_data$MA_3, col = "blue", lwd = 2)

#Growth rate
monthly_data <- monthly_data %>%
  mutate(Growth = (Revenue / lag(Revenue)) - 1)

#Decomposition
stl_decomp <- stl(ts_revenue, s.window = "periodic")
plot(stl_decomp)

#Stationarity test
PP.test(ts_revenue)

#ACF/PACF
par(mfrow = c(1,2))
acf(ts_revenue, main = "ACF - Revenue")
pacf(ts_revenue, main = "PACF - Revenue")
par(mfrow = c(1,1))

#Train/Test Split
n <- length(ts_revenue)
test_size <- 3
train_end <- n - test_size

ts_train <- window(ts_revenue, end = time(ts_revenue)[train_end])
ts_test  <- window(ts_revenue, start = time(ts_revenue)[train_end + 1])

#Model (Train)
model <- auto.arima(ts_train, seasonal = TRUE)
summary(model)

#Residual Diagnostics
checkresiduals(model)

#Forecast on Test set
fc_test <- forecast(model, h = test_size)

#Accuracy
acc <- accuracy(fc_test, ts_test)

#Final model on full data
model_full <- auto.arima(ts_revenue, seasonal = TRUE)
summary(model_full)

#Forecast
forecast_values <- forecast(model_full, h = 3)
plot(forecast_values)

#Profit forecast
ts_profit <- ts(monthly_data$Profit,
                start = c(year(min(monthly_data$Month)),
                          month(min(monthly_data$Month))),
                frequency = 12)

profit_model <- auto.arima(ts_profit, seasonal = TRUE)
profit_forecast <- forecast(profit_model, h = 3)

plot(profit_forecast,
     main = "Profit Forecast",
     ylab = "Profit",
     xlab = "Time")

#Client payment delay risk
client_risk <- sales %>%
  group_by(Customer_ID) %>%
  summarise(
    Avg_Delay = mean(Payment_Delay_Days),
    Max_Delay = max(Payment_Delay_Days),
    Late_Payment_Rate = mean(Payment_Delay_Days > 0),
    Total_Revenue = sum(Revenue)
  ) %>%
  mutate(
    Risk_Flag = case_when(
      Avg_Delay > 20 ~ "High Risk",
      Avg_Delay > 10 ~ "Moderate Risk",
      TRUE ~ "Low Risk"
    )
  )

#Grouping by risk
risk_data <- sales %>%
  left_join(client_risk, by = "Customer_ID")

risk_data %>%
  group_by(Risk_Flag) %>%
  summarise(
    Revenue = sum(Revenue),
    Avg_Delay = mean(Payment_Delay_Days)
  )

#Forecasting payment delays
ts_delay <- ts(monthly_data$Avg_Delay,
               start = c(year(min(monthly_data$Month)),
                         month(min(monthly_data$Month))),
               frequency = 12)

delay_model <- auto.arima(ts_delay)
delay_forecast <- forecast(delay_model, h = 3)

plot(delay_forecast)

write_csv(sales, "Sales (Corrected).csv")

###############################################################################
# Forecasting Output Extraction Script (Did this just for a clean layout)
###############################################################################

# 1. Forecast Outputs
forecast_df <- data.frame(forecast_values)
print(forecast_df)

profit_df <- data.frame(profit_forecast)
print(profit_forecast)

delay_df <- data.frame(delay_forecast)
print(delay_df)

# 2. Growth and Trend Insights
latest_growth <- tail(monthly_data$Growth, 1)
print(latest_growth)

recent_trend <- tail(monthly_data$MA_3, 6)
print(recent_trend)

# 3. Seasonality insight (STL Decomposition)
print(stl_decomp$time.series)

# 4. Client risk distribution
risk_clients <- client_risk %>%
  count(Risk_Flag) %>%
  mutate(Percentage = n / sum(n) * 100)
print(risk_clients)

risk_revenue <- client_risk %>%
  group_by(Risk_Flag) %>%
  summarise(Total_Revenue = sum(Total_Revenue)) %>%
  mutate(Revenue_Share = Total_Revenue / sum(Total_Revenue) * 100)
print(risk_revenue)

# 5. Model performance metrics
acc <- accuracy(fc_test, ts_test)
print(acc)

checkresiduals(model)

# 6. Forecast vs Actual Comparison
comparison <- data.frame(
  Actual = as.numeric(ts_test),
  Forecast = as.numeric(fc_test$mean)
)

comparison <- comparison %>%
  mutate(
    Error = Actual - Forecast,
    Error_Percent = Error / Actual * 100
  )

print(comparison)

# 7. ACF/PACF Analysis
acf_values <- acf(ts_revenue, plot = FALSE)
pacf_values <- pacf(ts_revenue, plot = FALSE)

print(head(acf_values$acf, 10))
print(head(pacf_values$acf, 10))
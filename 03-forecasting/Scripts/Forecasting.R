###############################################################################
#Orey Analytics
#Forecasting: Sales dataset
###############################################################################
library(tidyverse)
library(lubridate)

setwd("E:/Business/Orey Analytics/Portfolio Building/Forecasting/Clean Data")
sales <- read_csv("Sales Dataset.csv")

#Fix date format
sales$Date <- as.Date(sales$Date)

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

#Forecasting model
library(forecast)

model <- auto.arima(ts_revenue, seasonal = TRUE)
summary(model)

#Forecast
forecast_values <- forecast(model, h = 3)
plot(forecast_values)

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

###############################################################################
#Extracting Information cleanly (Not necessary)
###############################################################################
# Forecast
forecast_df <- data.frame(forecast_values)

# Growth
latest_growth <- tail(monthly_data$Growth, 1)

# Trend
recent_trend <- tail(monthly_data$MA_3, 6)
view(recent_trend)

#Seasonality Insight (STL decomposition)
stl_decomp$time.series

# Risk distribution (clients)
risk_clients <- client_risk %>%
  count(Risk_Flag) %>%
  mutate(Percentage = n / sum(n) * 100)

# Risk distribution (revenue)
risk_revenue <- client_risk %>%
  group_by(Risk_Flag) %>%
  summarise(Total_Revenue = sum(Total_Revenue)) %>%
  mutate(Revenue_Share = Total_Revenue / sum(Total_Revenue) * 100)

# Delay forecast
delay_df <- data.frame(delay_forecast)
view(delay_df)

# Show outputs
forecast_df
latest_growth
risk_clients
risk_revenue
delay_df

###############################################################################
#Insight Summary Notes
###############################################################################
summary_text <- "
Forecasting Sales - Insight Summary

Overview
Built a mini financial intelligence system:

1. Descriptive layer: Revenue, profit, delays and Monthly aggregation
2. Diagnostic layer: Growth rates Trend and seasonality
3. Predictive layer: Revenue forecasts and Delay forecasts
4. Risk layer: Customer risk scoring and Revenue exposure to risk

Notes
- Preparing raw transaction data to become time intelligence → the foundation of forecasting.
- Transformed transaction data into Monthly financial performance view.
- Turned revenue into something that can predict the future not just describing the past.
- Visualized the time series and added a moving average trend to smooth out the noise and create a true revenue trend signal.
- Calculated the month-over-month growth rate.
- Broke revenue into trend, seasonality and residual.
- Tested if the series is stationary because the ARIMA model requires stationarity. Allows me to test if data is stable enough trust predictions.
- Built a time-series forecasting model (ARIMA) whichis my core predictive engine.
- Predicted the next 3 months for cashflow management and short-term planning such as hiring, budgeting and risk anticipation.
- Created a customer risk scoring model based on payment behavior with the following metrics built, Average and Max delay, revenue contribution and late payment rate.
- Grouped by risk enabling smarter credit policies and client prioritization.
- Created a time series for payment delays and forecasted it predicting future cashflow risk.

Conclusion
Built a mini fiancial intelligence system that helps SMEs predict revenue, detect risk, and prevent cash flow failure (Forecasting, Risk modeling and Business Insights)
"

writeLines(summary_text, "Sales Forecasting Insight Summary.txt") 

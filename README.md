# Time Series-Based Forecasting Methods to Predict Rice Prices
Overview
This repository contains the implementation of various time series-based forecasting methods to predict the monthly rice prices at the milling level in Indonesia. Rice is a staple food, and understanding price trends is crucial for ensuring market stability. This project compares six forecasting methods and aims to identify the best method for predicting rice prices using historical data.

The forecasting methods compared in this study include:

Naive Method
Double Moving Average
Double Exponential Smoothing
Time Series Regression
Autoregressive Integrated Moving Average (ARIMA)
Neural Networks
The data used in this analysis was obtained from Badan Pusat Statistik (BPS), covering the period from January 2013 to December 2023.

Methods
1. Naive Method
A simple forecasting method that uses the actual value from the previous period as the forecast for the next period.

2. Double Moving Average
A method that considers trends by using a double-layer moving average. The best results in this study were obtained using a period of 2.

3. Double Exponential Smoothing
This method applies exponential smoothing twice, allowing it to capture trends in time series data. It requires two parameters: alpha (α) and beta (β), which are optimized during the process.

4. Time Series Regression
A regression model that uses time as an independent variable to predict future values based on historical patterns. Different trend models (linear, exponential, quadratic) were tested.

5. ARIMA (Autoregressive Integrated Moving Average)
The ARIMA model combines autoregression, differencing (to achieve stationarity), and a moving average component to make predictions based on past observations. Several ARIMA configurations were tested to identify the best model.

6. Neural Networks
Neural networks, specifically Recurrent Neural Networks (RNNs) and Long Short-Term Memory (LSTM), were used to capture complex non-linear patterns in the time series data. Various architectures were tested, with the best results obtained from an architecture with 3 hidden layers.

Error Metrics
The performance of each model was evaluated using the following metrics:

Mean Absolute Error (MAE)
Root Mean Squared Error (RMSE)
Mean Absolute Percentage Error (MAPE)
Results
The Double Moving Average method with a period of 2 outperformed other models when applied to the test data. This method provided the lowest error values, making it the best choice for forecasting rice prices in this dataset.

Best Model: Double Moving Average (N = 2)
MAE: 1087.85
RMSE: 1422.58
MAPE: 9.06%
Although the Neural Network method performed best on the training data, it did not generalize as well on the test data as the Double Moving Average method.

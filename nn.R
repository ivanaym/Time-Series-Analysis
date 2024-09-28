library(readxl)
dataset <- read_excel("C:/Users/62811/OneDrive - Bina Nusantara/Semester 6/Time Series/AOL/dataset.xlsx")
dataset

library(tseries)
library(car)
library(nortest)
library(lmtest)

#p -value = 0.05

data = ts(dataset[1:132,2], start = 1, frequency = 12)
data

# Calculate the split index
train_size <- floor(0.82 * length(data))
train_data <- data[1:train_size]
test_data <- data[(train_size + 1):length(data)]

library(forecast)
model_nn <- nnetar(train_data, p=3,size = 2)
err_nn = model_nn$residuals

#Model evaluation
print("Train")
accuracy(model_nn)

print("Test")
test_forecasts <- forecast(model_nn, h = length(test_data))

predicted_values <- test_forecasts$mean

# MSE
mse_test <- mean((predicted_values - test_data)^2)
mse_test

# RMSE
rmse_test <- sqrt(mse_test)
rmse_test

# MAPE
mape_test <- mean(abs((predicted_values - test_data) / test_data)) * 100
mape_test

#MAE
mae = mean(abs(predicted_values - test_data))
mae

library(readxl)
aol <- read_excel("C:/Users/62811/OneDrive - Bina Nusantara/Semester 6/Time Series/AOL/aol.xlsx", 
                    +     sheet = "Sheet1")
View(aol)
data = ts(aol[1:24,3], start = 1, frequency = 12)
data
plot(data)

# Buat model neural network
model_nn <- nnetar(data, p = 3, size = 3)

# Prediksi menggunakan model neural network
forecast_nn <- forecast(model_nn, h = 12)
predictions <- forecast_nn
predictions
plot(forecast(model_nn))


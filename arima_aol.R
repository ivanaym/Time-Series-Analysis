library(readxl)
dataset <- read_excel("C:/Users/62811/OneDrive - Bina Nusantara/Semester 6/Time Series/AOL/dataset.xlsx")

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

data = ts(train_data)
length(data)

test = ts(test_data)
length(test_data)

#Plot
plot(data)

#Uji stasioner terhadap varians
power_transform_result <- powerTransform(data)
summary(power_transform_result) #p-value < alpha maka tolak H0 sehingga tidak stasioner terhadap varians

trans = data^lambda
trans
#Maka diambil lambda(0) dan lakukan transformasi
lambda <- power_transform_result$lambda
lambda
data_transformed <- bcPower(data, lambda)
summary(powerTransform(trans)) # stasioner terhadap varians

#Uji stasioner terhadap means
adf.test(data_transformed) #p-value > alpha maka gagal tolak H0, data tidak stasioner terhadap mean

#Lakukan differencing
diff = diff(data_transformed)
adf.test(diff) #p-value < alpha maka tolak H0, data stasioner terhadap varians

acf(diff) # q = 0,1,2,3
pacf(diff) # p = 1,2


model1 = arima(data_transformed, order=c(1,1,1))
coeftest(model1)

model2 = arima(data_transformed, order=c(2,1,1))
coeftest(model2)

model3 = arima(data_transformed, order=c(1,1,2))
coeftest(model3)

model4 = arima(data_transformed, order=c(2,1,2))
coeftest(model4)

model5 = arima(data_transformed, order=c(1,1,3))
coeftest(model5)

model6 = arima(data_transformed, order=c(2,1,3))
coeftest(model6)

model7 = arima(data_transformed, order=c(1,1,0))
coeftest(model7)

model8 = arima(data_transformed, order=c(2,1,0))
coeftest(model8)

#Asumsi White Noise
er2=residuals(model2)
Box.test(er2, type='Ljung-Box')

er3=residuals(model3)
Box.test(er3, type='Ljung-Box')

er7=residuals(model7)
Box.test(er7, type='Ljung-Box')

er8=residuals(model8)
Box.test(er8, type='Ljung-Box')

#Asumsi distribusi normal
lillie.test(er2)
lillie.test(er3)
lillie.test(er7)
lillie.test(er8)


library(forecast)

# Make forecasts for the training data
train_forecasts <- fitted(model2)

# Calculate Mean Absolute Error (MAE) for training data
mae_train <- mean(abs(train_forecasts - train_data))

# Calculate Root Mean Square Error (RMSE) for training data
rmse_train <- sqrt(mean((train_forecasts - train_data)^2))

# Calculate Mean Absolute Percentage Error (MAPE) for training data
mape_train <- mean(abs((train_forecasts - train_data) / train_data)) * 100

# Print the evaluation metrics for training data
cat("Training Data - Mean Absolute Error (MAE):", mae_train, "\n")
cat("Training Data - Root Mean Square Error (RMSE):", rmse_train, "\n")
cat("Training Data - Mean Absolute Percentage Error (MAPE):", mape_train, "\n")

# Make forecasts for the length of the test data
test_forecasts <- forecast(model2, h = length(test_data))

# Extract point forecasts
predicted_values <- test_forecasts$mean

# Calculate Mean Absolute Error (MAE) for testing data
mae_test <- mean(abs(predicted_values - test_data))

# Calculate Root Mean Square Error (RMSE) for testing data
rmse_test <- sqrt(mean((predicted_values - test_data)^2))

# Calculate Mean Absolute Percentage Error (MAPE) for testing data
mape_test <- mean(abs((predicted_values - test_data) / test_data)) * 100

# Print the evaluation metrics for testing data
cat("Testing Data - Mean Absolute Error (MAE):", mae_test, "\n")
cat("Testing Data - Root Mean Square Error (RMSE):", rmse_test, "\n")
cat("Testing Data - Mean Absolute Percentage Error (MAPE):", mape_test, "\n")

# Fit ARIMA model using auto.arima with differencing d = 1
model_arima <- auto.arima(data_transformed, d = 1)

# Ringkasan model
summary(model_arima)


des = holt(data, h = length(test_data))
summary(des)

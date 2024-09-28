library(readxl)
dataset <- read_excel("dataset.xlsx")
View(dataset)

train = dataset[1:108,1:2]
train

# Model 1 (Linear Trend: Yt = a + bt)
# 1. Pembuatan model
model1 = lm(x~t, data=train)

# 2. Uji signifikansi parameter (serentak dan parsial)
summary(model1)

# 3. Uji Asumsi Error IIDN
error1 = residuals(model1)

# 3.1. Uji Independent
# Hipotesis:
# H0: p = 0 (rho = 0) -> residual independent
# H1: p != 0 (rho != 0)
library(lmtest)
dwtest(model1, alternative = "two.sided") #Tolak H0 sehingga tidak ada autokorelasi

# 3.2 Uji Identik
# Hipotesis:
# H0: residual identik (varians konstan)
# H1: residual tidak identik
bptest(model1) #gagal tolak H0 maka variansnya konstan

# 3.3 Uji Distribusi Normal
# Hipotesis:
# H0: reesidual berdistribusi normal
# H1: residual tidak berdistribusi normal
library(nortest)
lillie.test(error1) #gagal tolak H0 maka error berdistribusi normal



# Model 2 (Exponential Trend: Yt = ae^bt)
# Untuk membuat model exponential, kita harus mentransformasikan ke bentuk linear
# Sehingga modelnya menjadi ln(yt) = ln(a) + bt

# 1. Pembuatan model
train$lny = log(train$x)
model2 = lm(lny~t, data=train)

# 2. Uji signifikansi parameter (serentak dan parsial)
summary(model2)
# Notes: untuk pembuatan modelnya bentuknya harus tetap dalam bentuk eksponential
# Karena masih dalam bentuk ln (a) = 7.45 maka diubah dulu
a = exp(model2$coefficients[1])
a
b = model2$coefficients[2]
b
# maka Yt = 1724.425 e^0.088t

# 3. Uji Asumsi Error IIDN
yhat = exp(fitted.values(model2)) #balikkin lagi biar gaada lnnya
error2 = data$x - yhat
error2

# 3.1. Uji Independent
# Hipotesis:
# H0: p = 0 (rho = 0) -> residual independent
# H1: p != 0 (rho != 0)
library(lmtest)
dwtest(model2, alternative = "two.sided") #Terdapat autokorelasi (tidak independent)

# 3.2 Uji Identik
# Hipotesis:
# H0: residual identik (varians konstan)
# H1: residual tidak identik
bptest(model2) #gagal tolak H0 maka variansnya konstan

# 3.3 Uji Distribusi Normal
# Hipotesis:
# H0: reesidual berdistribusi normal
# H1: residual tidak berdistribusi normal
library(nortest)
lillie.test(error2) #gagal tolak H0 maka error berdistribusi normal





# Model 3 (Quadratic Trend: Yt = a+ bt+ ct^2)

# 1. Pembuatan model
train$t2 = (train$t)^2
model3 = lm(x~ t + t2, data=train)

# 2. Uji signifikansi parameter (serentak dan parsial)
summary(model3)

# 3. Uji Asumsi Error IIDN
error3 = residuals(model3)
error3

# 3.1. Uji Independent
# Hipotesis:
# H0: p = 0 (rho = 0) -> residual independent
# H1: p != 0 (rho != 0)
library(lmtest)
dwtest(model3, alternative = "two.sided") #tolak h0 maka terdapat autokorelasi (tidak independent)

# 3.2 Uji Identik
# Hipotesis:
# H0: residual identik (varians konstan)
# H1: residual tidak identik
bptest(model3) #gagal tolak H0 maka variansnya konstan

# 3.3 Uji Distribusi Normal
# Hipotesis:
# H0: residual berdistribusi normal
# H1: residual tidak berdistribusi normal
library(nortest)
lillie.test(error3) #gagal tolak H0 maka error berdistribusi normal

# 4. Hitung Kriteria Kebaikan Model
RMSE3 = sqrt(mean(error3^2))
RMSE3







# Model 4 (Yt = a + bt + cYt-1) *L adalah lag, ini untuk lag 1
# 1. Pembuatan model
yt = train$x[2:108]
yt
t = train$t[2:108]
yt1 = train$x[1:(108-1)]
model4 = lm(yt~t+yt1)

# 2. Uji signifikansi parameter (serentak dan parsial)
summary(model4)

# Modifikasi model (buang yang tidak signifikan: t & intercepts)
model4 = lm(yt~yt1-1)
summary(model4)

# 3. Uji Asumsi Error IIDN
error4 = residuals(model4)
error4

# 3.1. Uji Independent
# Hipotesis:
# H0: p = 0 (rho = 0) -> residual independent
# H1: p != 0 (rho != 0)
library(lmtest)
dwtest(model4, alternative = "two.sided") # gagal tolak h0 maka independent

# 3.2 Uji Identik
# Hipotesis:
# H0: residual identik (varians konstan)
# H1: residual tidak identik
bptest(model4) #tidak bisa karena tidak ada intercept & regressor maka pakai gletser

# 3.3 Uji Distribusi Normal
# Hipotesis:
# H0: residual berdistribusi normal
# H1: residual tidak berdistribusi normal
library(nortest)
lillie.test(error4) #gagal tolak H0 maka error berdistribusi normal

# 4. Hitung Kriteria Kebaikan Model
RMSE4 = sqrt(mean(error4^2))
RMSE4

# Model 5 (Yt = a + bt + cYt-1+ dYt-2) *L adalah lag, ini lag 2
# 1. Pembuatan model
yt = train$x[3:108]
length(yt)
t = train$t[3:108]
yt1 = train$x[2:(108-1)]
yt2 = train$x[1:(108-2)]
model5 = lm(yt~t+yt1+yt2)

# 2. Uji signifikansi parameter (serentak dan parsial)
summary(model5)
# Hasilnya menunjukkan yt2 tidak signifikan maka data ini bagusnya sampe lag 1
# Tidak perlu dilanjutkan karena jika yt2 dihapus akan sama seperti model ke 4

# Regresi linear ini mirip seperti model AR(p), untuk menentukan ordonya kita pakai ACF dan PACF
# ACF dan PACF
# 1. Ubah data ke data time series
datats = ts(data$Strikers)
datats
# pacf(datats, lag.max = 10)
plot.pacf = pacf(datats, lag.max = 10)
plot.pacf
# hasilnya menunjukkan bahwa yang signifikan hanya lag ke - 1

plot.acf = acf(datats, lag.max = 10)
plot.acf
# hasilnya menunjukkan dies down

# regresi bisa akomodir ketika lag signifikan tidak time series (pakai subset)
# ARIMA tidak bisa akomodir ketika lag signifikan tidak time series (ordo 6: harus lag 1-lag 6)

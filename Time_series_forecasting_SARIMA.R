library(tseries)
library(ggplot2)
library(gridExtra)
library(forecast)
library(zoo)
data("USAccDeaths")
Acf(USAccDeaths)
Pacf(USAccDeaths)
plot(USAccDeaths)
ggsubseriesplot(USAccDeaths)
a=decompose(USAccDeaths)
plot(a)
b=USAccDeaths
##Dividing the Dataset into training and Test data
n=length(b)
n_train=floor(0.7 * n)
n_test=n - n_train
train_ts= window(b, end = time(b)[n_train])
test_ts= window(b, start = time(b)[n_train + 1])
adf.test(train_ts)
kpss.test(train_ts)

##Checking Mean and variance to choose appropriate Transformation
roll_mean=rollapply(train_ts, width = 12, mean, align = "right", fill = NA)
roll_var=rollapply(train_ts, width = 12, var,  align = "right", fill = NA)
plot(roll_mean, roll_var,
     xlab = "Rolling Mean",
     ylab = "Rolling Variance",
     main = "Mean–Variance Relationship")

## Modeling fit M1 with no transformation
diff_no_trans_nonseasonal=diff(train_ts, differences = 1)
diff_no_trans_seasonal_combined=diff(diff_no_trans_nonseasonal, lag = 12, differences = 1)
Acf(diff_no_trans_seasonal_combined)
Pacf(diff_no_trans_seasonal_combined)
adf.test(diff_no_trans_seasonal_combined)
kpss.test(diff_no_trans_seasonal_combined)
M_1=Arima(train_ts, order = c(0, 1, 0), seasonal = list(order = c(0, 1, 1), period = 12))
summary(M_1)
checkresiduals(M_1) 

##Forecasting M1
z_1=forecast(M_1, h=length(test_ts))
w_1=z_1$mean
M_1_Prediction=w_1
plot(M_1_Prediction)

## as variance increases sharply we will use log transformation M2
log_transformed=log(train_ts)
Acf(log_transformed)
Pacf(log_transformed)
diff_log_nonseasonal=diff(log_transformed, differences = 1)
diff_log_seasonal_combined=diff(diff_log_nonseasonal, lag = 12, differences = 1)
Acf(diff_log_seasonal_combined)
Pacf(diff_log_seasonal_combined)
adf.test(diff_log_seasonal_combined)
kpss.test(diff_log_seasonal_combined)
M_2=Arima(log_transformed, order = c(0, 1, 0), seasonal = list(order = c(0, 1, 1), period = 12))
summary(M_2)
checkresiduals(M_2) 

##Forecasting M2
z_2=forecast(M_2, h=length(test_ts))
w_2=z_2$mean
M_2_Prediction=exp(w_2)
plot(M_2_Prediction)

##Box-cox transformation and Model Fitting for M3
L=BoxCox.lambda(train_ts)
transformed_b=BoxCox(train_ts,L)
Acf(transformed_b)
Pacf(transformed_b)
diff_b_nonseasonal=diff(transformed_b, differences = 1)
diff_b_seasonal_combined=diff(diff_b_nonseasonal, lag = 12, differences = 1)
Acf(diff_b_seasonal_combined)
Pacf(diff_b_seasonal_combined)
adf.test(diff_b_seasonal_combined)
kpss.test(diff_b_seasonal_combined)
M_3=Arima(transformed_b, order = c(1, 1, 0), seasonal = list(order = c(0, 1, 1), period = 12))
AIC(M_3)
BIC(M_3)
##AICc(M_3)
summary(M_3)
checkresiduals(M_3) 

##Forecasting M3
z_3=forecast(M_3, h=length(test_ts))
w_3=z_3$mean
M_3_Prediction=InvBoxCox(w_3,L)
plot(M_3_Prediction)

## Auto Arima for fitting M4
M_4=auto.arima(transformed_b)
summary(M_4)
checkresiduals(M_4)

##Forecasting M4
z_4=forecast(M_4, h=length(test_ts))
w_4=z_4$mean
M_4_Prediction=InvBoxCox(w_4,L)
plot(M_4_Prediction)

##Binding all data
cbind(test_ts,M_1_Prediction,M_2_Prediction,M_3_Prediction,M_4_Prediction )





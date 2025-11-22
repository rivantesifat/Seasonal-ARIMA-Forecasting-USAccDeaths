# Time Series Forecasting with ARIMA on USAccDeaths

This project is a personal exploration of time-series analysis and forecasting techniques using the
USAccDeaths dataset. The goal is to understand how different transformations and ARIMA
specifications influence model diagnostics, stationarity, and forecasting performance.

---

## 🔍 Dataset Overview

The dataset contains monthly accidental deaths in the United States from 1973 to 1978. The data
shows:

- A strong additive seasonal pattern  
- A nonstationary trend  
- Annual seasonality (period = 12)

---

## ⚙️ Methods and Workflow

### **1. Stationarity Checks**
- ADF and KPSS tests  
- Non-seasonal and seasonal differencing  
- ACF/PACF analysis

### **2. Transformation Experiments**
To stabilize variance and improve stationarity:

- No transformation  
- Log transformation  
- Box–Cox transformation (lambda chosen via maximum likelihood)

### **3. Models Fitted**

| Model | Transformation | Specification |
|-------|----------------|---------------|
| M1 | None | ARIMA(0,1,0)(0,1,1)[12] |
| M2 | Log | ARIMA(0,1,0)(0,1,1)[12] |
| M3 | Box–Cox | ARIMA(1,1,0)(0,1,1)[12] |
| M4 | Box–Cox + auto.arima | ARIMA(0,1,1)(0,1,1)[12] |

---

## 📊 Model Comparison

The models were compared using:

- AIC, BIC, AICc  
- Residual diagnostics (Ljung–Box test)  
- Forecast accuracy (RMSE)  
- Overall residual whiteness  

### Summary of results

| Model | AIC | BIC | AICc | Residual p-value | RMSE |
|------|------|------|--------|----------------|----------|
| M1 | 551.42 | 554.64 | 551.78 | 0.1118 | 289.59 |
| M2 | -117.88 | -114.66 | -117.53 | 0.165 | 0.0326 |
| M3 | -789.33 | -784.50 | -788.61 | 0.9788 | ~5.1e-4 |
| M4 | -794.01 | -789.17 | -793.28 | 0.978 | ~5.1e-4 |

---

## 🏆 Best Model

**M4 — ARIMA(0,1,1)(0,1,1)[12]**  
This model performed best overall, with the lowest AIC/AICc and excellent residual diagnostics.
Forecast accuracy was similar to M3, but M4 offered a simpler and more statistically optimal fit.





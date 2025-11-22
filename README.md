# Time Series Forecasting with ARIMA on USAccDeaths

This project is a personal exploration of time-series analysis and forecasting techniques using the
**USAccDeaths** dataset. I focused on understanding how different transformations and model
specifications affect stationarity, model diagnostics, and predictive performance.

The work includes full preprocessing, visualization, transformation analysis, model fitting, and forecast
evaluation.

---

## 🔍 Dataset Overview

The dataset contains **monthly accidental deaths in the United States** from 1973 to 1978.  
From the visualizations (time plot, decomposition, ACF/PACF, and seasonal subseries), the series
exhibits:

- A clear **additive seasonal pattern**  
- A nonstationary trend  
- Strong annual periodicity (period = 12)

These features can be seen from the seasonal decomposition and ACF/PACF patterns shown in  
pages 2–4 of the document :contentReference[oaicite:1]{index=1}.

---

## ⚙️ Methods and Workflow

The analysis follows a full modeling pipeline:

### **1. Stationarity Checks**
- ADF and KPSS tests  
- Seasonal and non-seasonal differencing  
- Inspection of ACF/PACF after differencing  

Both ADF and KPSS indicated stationarity after applying **d = 1** and **D = 1** (page 4) :contentReference[oaicite:2]{index=2}.

---

### **2. Transformation Experiments**

To stabilize variance and improve stationarity, the following transformations were tested:

- **No Transformation**
- **Log Transformation**
- **Box–Cox Transformation** (λ selected via maximum likelihood)

Rolling mean–variance analysis showed that variance increased with the level, so transformation was needed (page 5) :contentReference[oaicite:3]{index=3}.

---

### **3. Models Evaluated**

Four ARIMA/SARIMA models were fitted:

| Model | Transformation | Specification |
|-------|----------------|---------------|
| **M1** | None | ARIMA(0,1,0)(0,1,1)[12] |
| **M2** | Log | ARIMA(0,1,0)(0,1,1)[12] |
| **M3** | Box–Cox | ARIMA(1,1,0)(0,1,1)[12] |
| **M4** | Box–Cox (auto.arima) | ARIMA(0,1,1)(0,1,1)[12] |

Mathematical forms for each model are included in the document (pages 5–7) :contentReference[oaicite:4]{index=4}.

---

## 📊 Model Comparison

All models were evaluated based on:

- **AIC, BIC, AICc**
- **Residual diagnostics (Ljung–Box test)**
- **Forecast accuracy (RMSE)**
- **Residual white-noise behavior**

Summary (page 7) :contentReference[oaicite:5]{index=5}:

| Model | AIC | BIC | AICc | Residual p-value | RMSE |
|------|------|------|--------|----------------|----------|
| M1 | 551.42 | 554.64 | 551.78 | 0.1118 | 289.59 |
| M2 | -117.88 | -114.66 | -117.53 | 0.165 | 0.0326 |
| **M3** | -789.33 | -784.50 | -788.61 | **0.9788** | **≈ 5.1e-4** |
| **M4** | **-794.01** | **-789.17** | **-793.28** | **0.978** | **≈ 5.1e-4** |

---

## 🏆 Best Model

**M4 — ARIMA(0,1,1)(0,1,1)[12]** emerged as the strongest model, because:

- It had the **best AIC and AICc**
- Residuals behaved as **white noise** (very high Ljung–Box p-value)
- Forecast accuracy was **excellent**, tied with M3
- Model structure is simple and stable
- auto.arima selected a statistically optimal transformation and configuration

M3 was also strong, but slightly behind M4 in information criteria.

---

## 📈 Forecasts

All forecasts were generated on the **original scale** by applying:

- `exp()` for log-transformed models  
- `InvBoxCox()` or `lambda=` parameter inside `forecast()` for Box–Cox models  

Prediction tables and plots for all models are included at the end of the document (page 7) :contentReference[oaicite:6]{index=6}.

---

## 📦 Contents


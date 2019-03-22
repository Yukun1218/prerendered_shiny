---
title: "DCS QA Report Methodology"
output: 
  html_document:
    keep_md: yes
---

> Methods

1. Version Compare

+ <span style="color:grey">Grey</span>: Data Value Updated = Published. No version change (data point falling on diagnal line).
+ <span style="color:orange">Orange</span>: Data Value Updated != Published. Version change detected. Points on upper left side of diagnal line indicates published value is greater than updated value; Otherwise smaller. 
+ <span style="color:red">Red</span>: Data point that are updated but not yet published. 
+ Tooltip available. Please mouse over data point to see the source satellite, country, year and value. 


2. Outlier Detection

+ The 'anomalize' package enables a "tidy" workflow for detecting anomalies in data.
  (Reference: https://cran.r-project.org/web/packages/anomalize/anomalize.pdf)
  
+ The main functions are time_decompose(), anomalize(), and time_recompose(). When combined, it's quite simple to decompose time series, detect anomalies, and create bands separating the "normal" data from the anomalous data at scale (i.e. for multiple time series). 

+ Time series decomposition is used to remove trend and seasonal components via the time_decompose() function and methods used here is seasonal decomposition of time series by one of "stl" or "twitter". The STL method uses seasonal decomposition, and this is the method we're using now. The Twitter method uses trend to remove the trend. Both methods have two tuning params: frequency and trend. <b>For now both params are set to "auto" for robust outlier detection on all indicators.</b>

    + <b>Frequency</b> Controls the seasonal adjustment (removal of seasonality). 
    + <b>Trend</b> Controls the trend component For stl, the trend controls the sensitivity of the lowess smoother, which is used to remove the remainder. For twitter, the trend controls the period width of the median, which are used to remove the trend and center the remainder. The anomalize() function implements two methods for anomaly detection of residuals including using an inner quartile range ("iqr") and generalized extreme studentized deviation ("gesd"). These methods are based on those used in the 'forecast' package and the Twitter 'AnomalyDetection' package.
    
    *Notes on "STL" method: STL stands for "Seasonal and Trend decomposition using Loess" and splits time series into trend, seasonal and remainder component. Loess interpolation (seasonal smoothing) is used to smooth the cyclic sub-series (after removing the current trend estimation) to determine the seasonal component. Next another Loess interpolation (lowpass smoothing) is used to smooth out the estimated seasonal component. In a final step the deseasonalized series is smoothed again (trend smoothing) to find an estimation of the trend component. This process is repeated several times to improve the accuracy of the estimations of the components.*
    
+ In anomalize() part, the outliers are detected using either "GESD" or "IQR" method. We're now using "IQR" (with alpha = 0.01) as it is less sensitive to outlieres. 

    + IQR: The IQR Method uses an innerquartile range of 25 the median. With the default alpha = 0.05, the limits are established by expanding the 25/75 baseline by an IQR Factor of 3 (3X). The IQR Factor = 0.15 / alpha (hense 3X with alpha = 0.05). To increase the IQR Factor controling the limits, decrease the alpha, which makes it more difficult to be an outlier. Increase alpha to make it easier to be an outlier.
    + GESD: As another option, the GESD Method (Generlized Extreme Studentized Deviate Test) progressively eliminates outliers using a Student’s T-Test comparing the test statistic to a critical value. Each time an outlier is removed, the test statistic is updated. Once test statistic drops below the critical value, all outliers are considered removed. Because this method involves continuous updating via a loop, it is slower than the IQR method. However, it tends to be the best performing method for outlier removal.




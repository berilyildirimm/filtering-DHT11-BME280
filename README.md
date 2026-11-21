Digital Filtering and Noise Analysis for DHT11 / BME280 Sensor Data
  
  This project was developed in MATLAB to clean noisy temperature and humidity readings collected from environmental sensors (DHT11 / BME280), which are widely used in embedded systems and IoT applications.

  To suppress high-frequency fluctuations and measurement noise commonly seen in real-world sensor logs, three different digital filtering techniques were implemented and evaluated in terms of Signal-to-Noise Ratio (SNR) improvement.

---

Project Objectives
Raw data gathered from microcontrollers (such as Arduino, STM32, or ESP32) often contains electrical interference and quantization noise. This study focuses on:
1. Parsing raw sensor text logs (`log_temp.csv`) and handling missing values (`NaN`),
2. Implementing "Moving Average", "Low-Pass Filter", and "1D Kalman Filter" algorithms,
3. Quantitatively comparing the noise-reduction performance of each filter.

---
Repository Structure
```text
filtering_DHT11_BME280/
├── log_temp.csv            # Raw temperature and humidity measurement logs
├── load_inspect.m          # Step 1: Data loading and missing value inspection
├── filter_design.m         # Step 2: String parsing and implementation of 3 filters
├── snr_evaluation.m        # Step 3: Residual noise analysis, SNR calculation, and plot export
├── filter_comparison.png   # Time-domain comparison of raw vs. filtered signals
└── snr_analysis.png        # SNR and residual noise performance comparison

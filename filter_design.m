%% ADIM 2: Veri Ayrıştırma (Parsing) ve Dijital Filtre Tasarımı
clear; clc; close all;

% 1. Veriyi oku
rawData = readtable('log_temp.csv');

% 2. 'T=22.0' ve 'H=20.0' metinlerini temizleyip sayısal (double) diziye çevir
temp_str = erase(string(rawData.Var3), "T=");
hum_str  = erase(string(rawData.Var4), "H=");

temp_num = str2double(temp_str);
hum_num  = str2double(hum_str);

% 3. Eksik (NaN) satırları iki sinyalden de eşzamanlı temizle
validIdx   = ~isnan(temp_num) & ~isnan(hum_num);
temp_clean = temp_num(validIdx);
hum_clean  = hum_num(validIdx);
N          = length(temp_clean);
t          = 1:N;

% --- FİLTRE 1: Moving Average (Hareketli Ortalama) ---
windowSize   = 15;
temp_movmean = movmean(temp_clean, windowSize);
hum_movmean  = movmean(hum_clean, windowSize);

% --- FİLTRE 2: Low-Pass Filter (Alçak Geçiren Dijital Filtre) ---
temp_lowpass = lowpass(temp_clean, 0.08);
hum_lowpass  = lowpass(hum_clean, 0.08);

% --- FİLTRE 3: 1D Kalman Filtresi (Sıcaklık İçin) ---
Q_temp = 0.01; % Süreç gürültüsü kovaryansı
R_temp = 0.5;  % Ölçüm gürültüsü kovaryansı
temp_kalman = zeros(N, 1);
x_t = temp_clean(1);
P_t = 1.0;

for k = 1:N
    P_pred = P_t + Q_temp;
    K = P_pred / (P_pred + R_temp);
    x_t = x_t + K * (temp_clean(k) - x_t);
    P_t = (1 - K) * P_pred;
    temp_kalman(k) = x_t;
end

% --- FİLTRE 3: 1D Kalman Filtresi (Nem İçin) ---
Q_hum = 0.05;
R_hum = 2.0;
hum_kalman = zeros(N, 1);
x_h = hum_clean(1);
P_h = 1.0;

for k = 1:N
    P_pred = P_h + Q_hum;
    K = P_pred / (P_pred + R_hum);
    x_h = x_h + K * (hum_clean(k) - x_h);
    P_h = (1 - K) * P_pred;
    hum_kalman(k) = x_h;
end

% 4. Görselleştirme
figure('Name', 'DHT11 / BME280 Filtreleme Karşılaştırması', 'Position', [100, 100, 1000, 650]);

subplot(2, 1, 1);
plot(t, temp_clean, 'Color', [0.75 0.75 0.75], 'DisplayName', 'Ham Sıcaklık'); hold on;
plot(t, temp_movmean, 'b', 'LineWidth', 1.3, 'DisplayName', 'Moving Average');
plot(t, temp_lowpass, 'g', 'LineWidth', 1.3, 'DisplayName', 'Low-Pass Filtre');
plot(t, temp_kalman, 'r', 'LineWidth', 1.6, 'DisplayName', '1D Kalman Filtresi');
title('Sıcaklık Sensörü (T) Filtreleme Performansı');
ylabel('Sıcaklık (°C)');
legend('Location', 'best'); grid on;

subplot(2, 1, 2);
plot(t, hum_clean, 'Color', [0.75 0.75 0.75], 'DisplayName', 'Ham Nem'); hold on;
plot(t, hum_movmean, 'b', 'LineWidth', 1.3, 'DisplayName', 'Moving Average');
plot(t, hum_lowpass, 'g', 'LineWidth', 1.3, 'DisplayName', 'Low-Pass Filtre');
plot(t, hum_kalman, 'r', 'LineWidth', 1.6, 'DisplayName', '1D Kalman Filtresi');
title('Nem Sensörü (H) Filtreleme Performansı');
xlabel('Örnek İndeksi (Sample)');
ylabel('Bağıl Nem (%)');
legend('Location', 'best'); grid on;

% 5. İşlenmiş verileri Adım 3 (SNR Analizi) için kaydet
save('filtered_results.mat', 't', 'temp_clean', 'temp_movmean', 'temp_lowpass', 'temp_kalman', ...
    'hum_clean', 'hum_movmean', 'hum_lowpass', 'hum_kalman');
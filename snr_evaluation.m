%% ADIM 3: Filtre Performans Değerlendirmesi (SNR / Gürültü Bastırma) ve Grafik Kaydı
clear; clc; close all;

% 1. Adım 2'de kaydedilen işlenmiş verileri yükle
load('filtered_results.mat');

% 2. Gürültü bileşenlerini (Ham sinyal - Filtrelenmiş sinyal) hesapla
noise_temp_mov = temp_clean - temp_movmean;
noise_temp_lp  = temp_clean - temp_lowpass;
noise_temp_kal = temp_clean - temp_kalman;

noise_hum_mov  = hum_clean - hum_movmean;
noise_hum_lp   = hum_clean - hum_lowpass;
noise_hum_kal  = hum_clean - hum_kalman;

% 3. Performans Metrikleri: Artık Gürültü Standart Sapması (Noise STD) ve Tahmini SNR (dB)
% Not: Sinyal gücü olarak filtrelenmiş sinyalin varyansı, gürültü gücü olarak fark varyansı alınmıştır.
calc_snr = @(sig, noise) 10 * log10(var(sig) / var(noise));

FilterNames = {'Moving Average'; 'Low-Pass Filter'; '1D Kalman Filter'};

Temp_Noise_STD = [std(noise_temp_mov); std(noise_temp_lp); std(noise_temp_kal)];
Temp_SNR_dB    = [calc_snr(temp_movmean, noise_temp_mov); ...
    calc_snr(temp_lowpass, noise_temp_lp); ...
    calc_snr(temp_kalman, noise_temp_kal)];

Hum_Noise_STD  = [std(noise_hum_mov); std(noise_hum_lp); std(noise_hum_kal)];
Hum_SNR_dB     = [calc_snr(hum_movmean, noise_hum_mov); ...
    calc_snr(hum_lowpass, noise_hum_lp); ...
    calc_snr(hum_kalman, noise_hum_kal)];

ResultsTable = table(FilterNames, Temp_Noise_STD, Temp_SNR_dB, Hum_Noise_STD, Hum_SNR_dB);
disp('=== FİLTRE PERFORMANS KARŞILAŞTIRMA TABLOSU ===');
disp(ResultsTable);

% 4. GitHub İçin Grafik 1: Zaman Domeni Filtreleme Karşılaştırması
fig1 = figure('Name', 'Filter Comparison', 'Position', [100, 100, 1000, 650]);

subplot(2, 1, 1);
plot(t, temp_clean, 'Color', [0.75 0.75 0.75], 'DisplayName', 'Ham Sıcaklık'); hold on;
plot(t, temp_movmean, 'b', 'LineWidth', 1.2, 'DisplayName', 'Moving Average');
plot(t, temp_lowpass, 'g', 'LineWidth', 1.2, 'DisplayName', 'Low-Pass');
plot(t, temp_kalman, 'r', 'LineWidth', 1.6, 'DisplayName', '1D Kalman');
title('Sıcaklık Verisi Filtreleme Karşılaştırması');
ylabel('Sıcaklık (°C)');
legend('Location', 'best'); grid on;

subplot(2, 1, 2);
plot(t, hum_clean, 'Color', [0.75 0.75 0.75], 'DisplayName', 'Ham Nem'); hold on;
plot(t, hum_movmean, 'b', 'LineWidth', 1.2, 'DisplayName', 'Moving Average');
plot(t, hum_lowpass, 'g', 'LineWidth', 1.2, 'DisplayName', 'Low-Pass');
plot(t, hum_kalman, 'r', 'LineWidth', 1.6, 'DisplayName', '1D Kalman');
title('Nem Verisi Filtreleme Karşılaştırması');
xlabel('Örnek İndeksi (Sample)');
ylabel('Bağıl Nem (%)');
legend('Location', 'best'); grid on;

exportgraphics(fig1, 'filter_comparison.png', 'Resolution', 300);

% 5. GitHub İçin Grafik 2: Bastırılan Gürültü ve SNR Karşılaştırması
fig2 = figure('Name', 'SNR Comparison', 'Position', [150, 150, 900, 400]);

subplot(1, 2, 1);
bar(categorical(FilterNames), [Temp_SNR_dB, Hum_SNR_dB]);
title('Filtre Bazlı Tahmini SNR (dB)');
ylabel('SNR (dB) - Yüksek Daha İyi');
legend({'Sıcaklık (T)', 'Nem (H)'}, 'Location', 'best');
grid on;

subplot(1, 2, 2);
plot(t, noise_temp_kal, 'Color', [0.85 0.33 0.10], 'DisplayName', 'Kalman Artık Gürültü (T)');
title('1D Kalman Filtresi ile Ayıklanan Sıcaklık Gürültüsü');
xlabel('Örnek İndeksi (Sample)');
ylabel('Gürültü Genliği (°C)');
grid on;

exportgraphics(fig2, 'snr_analysis.png', 'Resolution', 300);
disp('Grafikler basariyla kaydedildi: filter_comparison.png ve snr_analysis.png');
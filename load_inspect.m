%% ADIM 1: Veri Yükleme, Temizleme ve İlk Görselleştirme
clear; clc; close all;

% 1. Veri setini doğrudan kendi dosya adıyla oku
filePath = 'log_temp.csv'; 
rawData = readtable(filePath);

% 2. Tablo özetini ve ilk 5 satırı Command Window'a yazdır
disp('--- Veri Seti Sütun İsimleri ---');
disp(rawData.Properties.VariableNames);
head(rawData, 5)

% 3. Eksik veri (NaN) kontrolü
missingCount = sum(ismissing(rawData));
disp('--- Sütun Bazında Eksik Veri Sayısı ---');
disp(missingCount);
# 🌡️ DHT11 / BME280 Sensör Verileri İçin Dijital Filtreleme ve Gürültü Analizi

Bu projede, gömülü sistemlerde ve IoT uygulamalarında sıkça kullanılan DHT11 / BME280 çevresel sensörlerinden alınan gürültülü sıcaklık ve nem verilerini MATLAB ortamında işleyerek temizledim. Gerçek mikrodenetleyici kayıtlarında sıkça görülen yüksek frekanslı dalgalanmaları bastırmak için üç farklı dijital filtreleme yöntemi uyguladım ve performanslarını Sinyal-Gürültü Oranı (SNR) açısından karşılaştırdım.

---

 Adım Adım Çalışma Akışı

Adım 1: Veri Yükleme ve Eksik Veri Kontrolü (`load_inspect.m`)
* İlk olarak ham sensör kayıtlarını içeren `log_temp.csv` veri setini `readtable` fonksiyonuyla MATLAB ortamına aktardım.
* Tablo yapısını incelediğimde sıcaklık ve nem değerlerinin sayısal formatta değil, `'T=22.0'` ve `'H=20.0'` şeklinde metin (string) olarak kaydedildiğini gördüm.
* Eksik veri kontrolü (`ismissing`) yaparak nem sütununda 16 adet boş/bozuk ölçüm (`NaN`) bulunduğunu tespit ettim.

Adım 2: Veri Ön İşleme ve Filtre Tasarımı (`filter_design.m`)
* Filtreleme işlemine geçmeden önce `erase` komutuyla metinlerin başındaki `"T="` ve `"H="` ifadelerini temizledim ve `str2double` ile verileri sayısal (`double`) dizilere dönüştürdüm.
* İki sinyalin zaman ekseninde senkronize kalması için nem sütunundaki 16 eksik satırı hem nem hem de sıcaklık dizilerinden eşzamanlı olarak çıkardım.
* Ardından sensör gürültüsünü bastırmak için üç farklı filtreleme tekniği uyguladım:
1. Moving Average (Hareketli Ortalama):Ani sıçramaları yumuşatmak için 15 örneklik kayan pencere ortalaması kullandım.
2.Low-Pass Filter (Alçak Geçiren Filtre):Yavaş değişen çevresel trendleri korurken yüksek frekanslı elektriksel gürültüyü süzdüm.
3. 1-D Kalman Filtresi:Süreç gürültüsü ($Q$) ve ölçüm gürültüsü ($R$) kovaryans parametrelerini ayarlayarak gerçek zamanlı gömülü sistemlere uygun, gecikmesi düşük bir durum tahmini (state estimation) döngüsü oluşturdum.

 Adım 3: Gürültü Azaltma Değerlendirmesi ve Görselleştirme (`snr_evaluation.m`)
* Ham ölçümlerden filtrelenmiş sinyalleri çıkararak artık gürültü bileşenini elde ettim; her yöntem için gürültü standart sapmasını ve Sinyal-Gürültü Oranı (SNR - dB) iyileştirmesini hesapladım.
* Son olarak zaman domaini takibini ve SNR iyileşmelerini göstermek amacıyla yüksek çözünürlüklü (300 DPI) karşılaştırma grafiklerini dışa aktardım.

---


import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {
  late final String konusma_sahibi;
  late  final String kimle_konusuyor;
  late final bool goruldu;
  late final Timestamp olusturulma_tarihi;
  late final String son_yollanan_mesaj;
  late final Timestamp gorulme_tarihi;
  late final int gorulmeyen_mesaj_sayisi;
  late String konusulanUserName;
  late String konusulanUserProfilURL;
  late DateTime sonOkunmaZamani;
  late String aradakiFark;

  Konusma(
      {required this.konusma_sahibi,
        required this.kimle_konusuyor,
        required this.goruldu,
        required this.gorulmeyen_mesaj_sayisi,
        required this.olusturulma_tarihi,
        required this.son_yollanan_mesaj,
        required this.gorulme_tarihi});

  Map<String, dynamic> toMap() {
    return {
      'konusma_sahibi': konusma_sahibi,
      'kimle_konusuyor': kimle_konusuyor,
      'konusma_goruldu': goruldu,
      'gorulmeyen_mesaj_sayisi':gorulmeyen_mesaj_sayisi,
      'olusturulma_tarihi': olusturulma_tarihi ?? FieldValue.serverTimestamp(),
      'son_yollanan_mesaj': son_yollanan_mesaj ?? FieldValue.serverTimestamp(),
      'gorulme_tarihi': gorulme_tarihi,
    };
  }

  Konusma.fromMap(Map<String, dynamic> map)
      : konusma_sahibi = map['konusma_sahibi'] ?? '',
        kimle_konusuyor = map['kimle_konusuyor'] ?? '',
        goruldu = map['konusma_goruldu'] ?? false,
        gorulmeyen_mesaj_sayisi = map['gorulmeyen_mesaj_sayisi'] ?? 0,
        olusturulma_tarihi = map['olusturulma_tarihi'] ?? Timestamp.now(),
        son_yollanan_mesaj = map['son_yollanan_mesaj'] ?? '',
        gorulme_tarihi = map['gorulme_tarihi'] ?? Timestamp.now();

  @override
  String toString() {
    return 'Konusma{konusma_sahibi: $konusma_sahibi, kimle_konusuyor: $kimle_konusuyor, goruldu: $goruldu, olusturulma_tarihi: $olusturulma_tarihi, son_yollanan_mesaj: $son_yollanan_mesaj, gorulme_tarihi: $gorulme_tarihi}';
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';



class Mesaj {
  final String kimden;
  final String kime;
  final bool bendenMi;
  String? mesaj;
  final String konusmaSahibi;
  final Timestamp date;

  Mesaj({
    required this.kimden,
    required this.kime,
    required this.bendenMi,
    required this.mesaj,
    required this.date,
    required this.konusmaSahibi,
  });


  Map<String, dynamic> toMap() {
    return {
      'kimden': kimden,
      'kime': kime,
      'bendenMi': bendenMi,
      'mesaj': mesaj,
      'konusmaSahibi': konusmaSahibi,
      'date': date,
    };
  }


  factory Mesaj.fromMap(Map<String, dynamic> map) {
    return Mesaj(
      kimden: map['kimden'],
      kime: map['kime'],
      bendenMi: map['bendenMi'],
      mesaj: map['mesaj'],
      konusmaSahibi: map['konusmaSahibi'],
      date: map['date'],

    );
  }

  Mesaj copyWith({
    String? kimden,
    String? kime,
    bool? bendenMi,
    String? mesaj,
    Timestamp? date,
    String? konusmaSahibi,
  }) {
    return Mesaj(
      kimden: kimden ?? this.kimden,
      kime: kime ?? this.kime,
      bendenMi: bendenMi ?? this.bendenMi,
      mesaj: mesaj ?? this.mesaj,
      date: date ?? this.date,
      konusmaSahibi: konusmaSahibi ?? this.konusmaSahibi,
    );
  }

  @override
  String toString() {
    return 'Mesaj{kimden: $kimden, kime: $kime, bendenMi: $bendenMi, mesaj: $mesaj, date: $date}';
  }
}

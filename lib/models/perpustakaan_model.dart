class Perpustakaan {
  final int id;
  final String nama;
  final String alamat;
  final String noTelepon;
  final String tipe;
  final String latitude;
  final String longitude;

  Perpustakaan({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.noTelepon,
    required this.tipe,
    required this.latitude,
    required this.longitude,
  });

  factory Perpustakaan.fromJson(Map<String, dynamic> json) {
    return Perpustakaan(
      id: json['id'],
      nama: json['nama_perpustakaan'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      tipe: json['tipe'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nama_perpustakaan': nama,
      'alamat': alamat,
      'no_telepon': noTelepon,
      'tipe': tipe,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
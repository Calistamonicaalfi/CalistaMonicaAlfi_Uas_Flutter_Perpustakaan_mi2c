import 'package:flutter/material.dart';
import 'package:flutter_perpustakaan_calista/screens/perpustakaan_from.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PerpustakaanDetail extends StatelessWidget {
  final dynamic data;
  const PerpustakaanDetail({super.key, required this.data});

  Future<void> hapusData(BuildContext context) async {
    final res = await http.delete(
      Uri.parse("http://192.168.111.29:8000/api/perpustakaan/${data['id']}"),
    );
    if (res.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil dihapus")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(
      double.parse(data['latitude']),
      double.parse(data['longitude']),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(data['nama_perpustakaan']),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PerpustakaanForm(data: data)),
              );
              Navigator.pop(context); // kembali ke list dan trigger fetch
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => hapusData(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['nama_perpustakaan'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("Alamat: ${data['alamat']}"),
                  Text("No Telepon: ${data['no_telepon']}"),
                  Text("Kategori: ${data['tipe']}"),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Lokasi Perpustakaan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: location,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('lokasi'),
                      position: location,
                      infoWindow: InfoWindow(title: data['nama_perpustakaan']),
                    ),
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

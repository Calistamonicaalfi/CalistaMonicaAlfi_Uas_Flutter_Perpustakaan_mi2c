import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PerpustakaanForm extends StatefulWidget {
  final dynamic data;
  const PerpustakaanForm({super.key, this.data});

  @override
  State<PerpustakaanForm> createState() => _PerpustakaanFormState();
}

class _PerpustakaanFormState extends State<PerpustakaanForm> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController teleponController;
  late TextEditingController tipeController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.data?['nama_perpustakaan'] ?? '');
    alamatController = TextEditingController(text: widget.data?['alamat'] ?? '');
    teleponController = TextEditingController(text: widget.data?['no_telepon'] ?? '');
    tipeController = TextEditingController(text: widget.data?['tipe'] ?? '');
    latitudeController = TextEditingController(text: widget.data?['latitude'] ?? '');
    longitudeController = TextEditingController(text: widget.data?['longitude'] ?? '');
  }

  Future<void> submit() async {
    final isEdit = widget.data != null;
    final uri = isEdit
        ? Uri.parse("http://192.168.111.29:8000/api/perpustakaan/${widget.data['id']}")
        : Uri.parse("http://192.168.111.29:8000/api/perpustakaan");

    final response = await (isEdit
        ? http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_perpustakaan': namaController.text,
          'alamat': alamatController.text,
          'no_telepon': teleponController.text,
          'tipe': tipeController.text,
          'latitude': latitudeController.text,
          'longitude': longitudeController.text,
        }))
        : http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_perpustakaan': namaController.text,
          'alamat': alamatController.text,
          'no_telepon': teleponController.text,
          'tipe': tipeController.text,
          'latitude': latitudeController.text,
          'longitude': longitudeController.text,
        })));

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data == null ? 'Tambah Perpustakaan' : 'Edit Perpustakaan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama')),
              TextFormField(controller: alamatController, decoration: const InputDecoration(labelText: 'Alamat')),
              TextFormField(controller: teleponController, decoration: const InputDecoration(labelText: 'No Telepon')),
              TextFormField(controller: tipeController, decoration: const InputDecoration(labelText: 'Tipe (Negeri/Swasta)')),
              TextFormField(controller: latitudeController, decoration: const InputDecoration(labelText: 'Latitude')),
              TextFormField(controller: longitudeController, decoration: const InputDecoration(labelText: 'Longitude')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: Text(widget.data == null ? 'Simpan' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
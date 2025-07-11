import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_perpustakaan_calista/screens/perpustakaan_from.dart';
import 'package:http/http.dart' as http;
import 'perpustakaan_detail.dart';

class PerpustakaanList extends StatefulWidget {
  const PerpustakaanList({super.key});

  @override
  State<PerpustakaanList> createState() => _PerpustakaanListState();
}

class _PerpustakaanListState extends State<PerpustakaanList> {
  List data = [];

  Future<void> fetchData() async {
    final res = await http.get(Uri.parse("http://192.168.111.29:8000/api/perpustakaan"));
    if (res.statusCode == 200) {
      setState(() => data = json.decode(res.body));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void refreshAfterBack() => fetchData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Perpustakaan"),
        backgroundColor: Colors.deepPurple,
      ),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: data.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, i) {
          final item = data[i];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.local_library, size: 32, color: Colors.deepPurple),
              title: Text(
                item['nama_perpustakaan'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['alamat']),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PerpustakaanDetail(data: item),
                  ),
                );
                refreshAfterBack();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PerpustakaanForm()),
          );
          refreshAfterBack();
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}

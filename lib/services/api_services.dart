import 'dart:convert';
import 'package:flutter_perpustakaan_calista/models/perpustakaan_model.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl = 'http://192.168.111.29:8000/api/perpustakaan';

  static Future<List<Perpustakaan>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Perpustakaan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<Perpustakaan> create(Perpustakaan data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: data.toJson(),
    );
    if (response.statusCode == 201) {
      return Perpustakaan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus');
    }
  }

  static Future<Perpustakaan> update(Perpustakaan data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${data.id}'),
      body: data.toJson(),
    );
    if (response.statusCode == 200) {
      return Perpustakaan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengubah');
    }
  }

  static Future<Perpustakaan> getById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Perpustakaan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Data tidak ditemukan');
    }
  }
}
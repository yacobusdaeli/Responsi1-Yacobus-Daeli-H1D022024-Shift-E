import 'dart:convert';
import 'package:responsipm/helpers/api.dart';
import 'package:responsipm/helpers/api_url.dart';
import 'package:responsipm/model/penerbit.dart';

class PenerbitBloc {
  // Mendapatkan daftar penerbit
  static Future<List<Penerbit>> getPenerbits() async {
    String apiUrl = ApiUrl.listPenerbit; // URL untuk mengambil daftar penerbit
    var response = await Api().get(apiUrl);

    if (response.statusCode != 200) {
      throw Exception("Gagal memuat data: ${response.statusCode}");
    }

    var jsonObj = json.decode(response.body);
    List<dynamic> listPenerbit =
        (jsonObj as Map<String, dynamic>)['data'] ?? [];
    List<Penerbit> penerbits = [];

    for (var item in listPenerbit) {
      penerbits.add(Penerbit.fromJson(item));
    }

    return penerbits;
  }

  // Menambah penerbit
  static Future<String> addPenerbit({required Penerbit penerbit}) async {
    String apiUrl = ApiUrl.createPenerbit; // URL untuk menambah penerbit

    var body = {
      "publisher_name": penerbit.publisherName,
      "established_year": penerbit.establishedYear,
      "country": penerbit.country,
    };

    var response = await Api().post(apiUrl, jsonEncode(body));

    if (response.statusCode != 200) {
      throw Exception("Gagal menambah penerbit: ${response.statusCode}");
    }

    var jsonObj = json.decode(response.body);

    if (jsonObj.containsKey('status')) {
      return jsonObj['status'].toString(); // Kembalikan status sebagai string
    } else {
      throw Exception("Status tidak ditemukan di respons API");
    }
  }

  // Memperbarui penerbit
  static Future<String> updatePenerbit({required Penerbit penerbit}) async {
    if (penerbit.id == null) {
      throw Exception("ID penerbit tidak boleh null saat memperbarui.");
    }

    String apiUrl = ApiUrl.updatePenerbit(penerbit.id!); // Ubah ke penerbit.id!

    var body = {
      "publisher_name": penerbit.publisherName,
      "established_year": penerbit.establishedYear,
      "country": penerbit.country,
    };

    var response = await Api().put(apiUrl, jsonEncode(body));

    if (response.statusCode != 200) {
      throw Exception("Gagal memperbarui penerbit: ${response.statusCode}");
    }

    var jsonObj = json.decode(response.body);

    if (jsonObj.containsKey('status')) {
      return jsonObj['status'].toString(); // Kembalikan status sebagai string
    } else {
      throw Exception("Status tidak ditemukan di respons API");
    }
  }

  // Menghapus penerbit
  static Future<bool> deletePenerbit({required int id}) async {
    String apiUrl = ApiUrl.deletePenerbit(id); // URL untuk menghapus penerbit
    var response = await Api().delete(apiUrl);

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus penerbit: ${response.statusCode}");
    }

    var jsonObj = json.decode(response.body);

    if (jsonObj.containsKey('data')) {
      return jsonObj['data'] as bool; // Kembalikan data sebagai bool
    } else {
      throw Exception("Data tidak ditemukan di respons API");
    }
  }
}

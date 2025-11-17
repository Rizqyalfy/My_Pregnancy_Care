import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "http://192.168.2.8/my_pregnancy_api";
  // NOTE:
  // Jika HP asli pakai wifi: ganti ke IP laptop contoh:
  // static String baseUrl = "http://192.168.1.5/my_pregnancy_api";
  // Jika Web: pakai localhost
  // static String baseUrl = "http://localhost/my_pregnancy_api";

  /// POST data ibu ke server
  static Future<Map<String, dynamic>> insertDataIbu({
    required String tekanan,
    required String berat,
    required String keluhan,
    required String gerakJanin,
  }) async {
    var url = Uri.parse("$baseUrl/ibu/insert_data.php");

    var response = await http.post(
      url,
      body: {
        "tekanan_darah": tekanan,
        "berat_badan": berat,
        "keluhan": keluhan,
        "pergerakan_janin": gerakJanin,
      },
    );

    return jsonDecode(response.body);
  }

  /// GET data ibu
  static Future<List<dynamic>> getDataIbu() async {
    var url = Uri.parse("$baseUrl/ibu/get_data.php");
    var response = await http.get(url);

    return jsonDecode(response.body);
  }

  /// GET data grafik ibu
  static Future<List<dynamic>> getGrafik() async {
    var url = Uri.parse("$baseUrl/ibu/grafik_data.php");
    var response = await http.get(url);

    return jsonDecode(response.body);
  }

  /// GET jadwal ANC
  static Future<List<dynamic>> getJadwalANC() async {
    var url = Uri.parse("$baseUrl/anc/jadwal.php");
    var response = await http.get(url);

    return jsonDecode(response.body);
  }

  /// GET reminder vitamin / notif
  static Future<List<dynamic>> getReminder() async {
    var url = Uri.parse("$baseUrl/anc/reminder.php");
    var response = await http.get(url);

    return jsonDecode(response.body);
  }
}

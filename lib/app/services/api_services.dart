import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class ApiServices {
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String>? headers,
  });
  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    bool convertBody = true,
    Map<String, String>? headers,
  });
}

class ApiServicesImpl implements ApiServices {
  @override
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, String>? headers,
  }) async {
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    return const JsonDecoder().convert(utf8.decode(response.bodyBytes));
  }

  @override
  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    bool convertBody = true,
    Map<String, String>? headers,
  }) async {
    var response = await http.post(
      Uri.parse(url),
      body: convertBody ? jsonEncode(body) : body,
      headers: headers,
    );
    return const JsonDecoder().convert(utf8.decode(response.bodyBytes));
  }
}

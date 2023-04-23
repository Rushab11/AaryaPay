import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:aaryapay/constants.dart';

class AuthenticationRepository {
  final client = http.Client();

  static const storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final url = Uri.parse('$backendBase/auth/login');

    var response = await http.post(
      url,
      body: jsonEncode({
        "email": email,
        "password": password,
        "remember_me": true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Login Failed! Check Email or Password!");
    }

    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if(decodedResponse["two_fa_required"] == true){
      return
    }
  }
}

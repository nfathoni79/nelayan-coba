import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nelayan_coba/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FishonService {
  // static const String baseUrl = 'http://10.0.2.2:8010';
  // static const String clientId = 'ehQNss2iMgu69E5K8ddH1hqreQMjBwHwU16OPGxt';
  // static const String clientSecret =
  //     'YHPuAIyUPdzzyjZdZWxUm3l6kzBQY1b477XEu4vJmxJ3BiuH5CNdQ6aKKdCGCuom2S3Y1rKnaA8mP8IKTigfif9Ib8xVIQnGHbO4H4FV0NS0sQ3HF5bXx62vIeMchnTK';

  static const String baseUrl = 'https://api-staging.perindo.id';
  static const String clientId = '19fHyXuCHuSNw00wBUoSbxdYCUGFUz3qwtSrOOi1';
  static const String clientSecret =
      'ArpwWiPRbdNfyB6XWnprHphQNG9gEQz9ILlbH0rXhRsJ8UgLZWkNEYxSzvjWqA4c0Zxu9oy56pkJmQ6LcIYfKTwZYqHmvZxPVGckQYBpXStyQ0oG4r5AXutNf0oJl7MB';

  static String basicAuth =
      'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

  static Future<bool> doesPhoneExist(String phone) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/user/check-phone?phone=$phone'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<String> getToken(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/o/token/'),
      headers: {
        HttpHeaders.authorizationHeader: basicAuth,
      },
      body: {
        'username': username,
        'password': password,
        'grant_type': 'password',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return body['access_token'];
    } else {
      throw Exception('Failed to get token');
    }
  }

  static Future<Profile> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get profile');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/user/myprofile/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      return Profile.fromJson(body['data']['profil']);
    } else {
      throw Exception('Failed to get profile');
    }
  }
}

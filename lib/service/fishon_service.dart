import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nelayan_coba/model/deposit.dart';
import 'package:nelayan_coba/model/profile.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/transaction.dart';
import 'package:nelayan_coba/model/user_token.dart';
import 'package:nelayan_coba/model/withdrawal.dart';
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

  static Future<UserToken> getToken(String username, String password) async {
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
      UserToken token = UserToken.fromJson(jsonDecode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', token.accessToken);
      prefs.setString('refreshToken', token.refreshToken);

      return token;
    } else {
      throw Exception('Failed to get token');
    }
  }

  static Future<UserToken> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    final response = await http.post(
      Uri.parse('$baseUrl/o/token/'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
    );

    if (response.statusCode == 200) {
      UserToken token = UserToken.fromJson(jsonDecode(response.body));
      prefs.setString('accessToken', token.accessToken);
      prefs.setString('refreshToken', token.refreshToken);

      return token;
    } else {
      throw Exception('Failed to get new token');
    }
  }

  static Future<bool> createUser(String phone, String name, String ktp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/user/register/'),
      body: {
        'client_id': clientId,
        'secret_key': clientSecret,
        'username': 'u$phone',
        'email': 'u$phone@gmail.com',
        'full_name': name,
        'ktp_number': ktp,
        'jenis_lembaga': 'Perorangan',
        'lat': '0',
        'lon': '0',
        'kabupaten': '-',
        'kecamatan': '-',
        'kelurahan': '-',
        'phone': phone,
        'type_user': 'BASIC',
        'wpp': 'null',
        'password': '12345678',
        'confirm_password': '12345678',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create user');
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
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getProfile();
    } else {
      throw Exception('Failed to get profile');
    }
  }

  static Future<bool> createSeaseedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to create Seaseed user');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/seaseed/users/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.createSeaseedUser();
    } else {
      throw Exception('Failed to create Seaseed user');
    }
  }

  static Future<SeaseedUser> getSeaseedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get Seaseed user');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/users/current/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      return SeaseedUser.fromJson(body['seaseed_user']);
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getSeaseedUser();
    } else {
      throw Exception('Failed to get Seaseed user');
    }
  }

  static Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get other Seaseed users');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/users/others/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List users = body['seaseed_users'];

      return List<SeaseedUser>.from(
          users.map((user) => SeaseedUser.fromJson(user)));
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getOtherSeaseedUsers();
    } else {
      throw Exception('Failed to get other Seaseed users');
    }
  }

  static Future<Deposit> createDeposit(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to create Deposit');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/seaseed/deposits/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'amount': '$amount',
      },
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Deposit.fromJson(body['deposit']);
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.createDeposit(amount);
    } else {
      throw Exception('Failed to create Deposit');
    }
  }

  static Future<Withdrawal> createWithdrawal(int amount, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to create Withdrawal');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/seaseed/withdrawals/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'amount': '$amount',
        'email': email,
      },
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Withdrawal.fromJson(body['withdrawal']);
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.createWithdrawal(amount, email);
    } else {
      throw Exception('Failed to create Withdrawal');
    }
  }

  static Future<bool> createTransfer(String receiverWallet, int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to create Transfer');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/seaseed/transfers/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'receiver_wallet_id': receiverWallet,
        'amount': '$amount',
      },
    );

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.createTransfer(receiverWallet, amount);
    } else {
      throw Exception('Failed to create Transfer');
    }
  }

  static Future<List<Transaction>> getTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get transactions');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/transactions/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List transactions = body['transactions'];

      return List<Transaction>.from(
          transactions.map((trx) => Transaction.fromJson(trx)));
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getTransactions();
    } else {
      throw Exception('Failed to get transactions');
    }
  }
}

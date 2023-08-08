import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/model/fish.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_history.dart';
import 'package:nelayan_coba/model/product.dart';
import 'package:nelayan_coba/model/profile.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/sell_fish.dart';
import 'package:nelayan_coba/model/sell_history.dart';
import 'package:nelayan_coba/model/user_token.dart';
import 'package:nelayan_coba/util/my_utils.dart';
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

      return SeaseedUser.fromJson(body['user']);
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
      List users = body['users'];

      return List<SeaseedUser>.from(
          users.map((user) => SeaseedUser.fromJson(user)));
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getOtherSeaseedUsers();
    } else {
      throw Exception('Failed to get other Seaseed users');
    }
  }

  static Future<List<Mart>> getMarts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/fishmart/store/?lat=0&lon=0&prefix=PI'),
    );

    if (response.statusCode == 200) {
      List marts = jsonDecode(response.body);

      return List<Mart>.from(marts.map((mart) => Mart.fromJson(mart)));
    } else {
      throw Exception('Failed to get marts');
    }
  }

  static Future<List<Product>> getProductsByStore(
      String slug, String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get products');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/fishmart/item/$slug/?keyword=$keyword'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List products = jsonDecode(response.body);

      return List<Product>.from(
          products.map((product) => Product.fromJson(product)));
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getProductsByStore(slug, keyword);
    } else {
      throw Exception('Failed to get products');
    }
  }

  static Future<bool> purchase(String slug, int amount,
      List<CartProduct> cartProductList, String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to purchase');
    }

    Map<String, String> body = {
      'store': slug,
      'amount': '$amount',
      'cart': MyUtils.toStringCartProductList(cartProductList),
      'address': address,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/fishmart/v2/purchase/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.purchase(slug, amount, cartProductList, address);
    } else {
      String message = jsonDecode(response.body)['message'];
      throw Exception(message);
    }
  }

  static Future<List<MartHistory>> getMartHistoryList(String slug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get history');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/fishmart/history/?store=$slug'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List historyList = jsonDecode(response.body)['data'];
      return historyList.map((item) => MartHistory.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getMartHistoryList(slug);
    } else {
      throw Exception('Failed to get history');
    }
  }

  static Future<List<Fish>> getFishList(String slug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get fish');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/log/ikan/?area=$slug'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List fishList = jsonDecode(response.body);
      return fishList.map((fish) => Fish.fromJson(fish)).toList();
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getFishList(slug);
    } else {
      throw Exception('Failed to get fish');
    }
  }

  static Future<bool> sellFish(String slug, List<SellFish> sellFishList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to sell fish');
    }

    Map<String, dynamic> body = {
      'store': slug,
      'data': sellFishList.map((item) => item.toSellJson()).toList(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/jual/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.sellFish(slug, sellFishList);
    } else {
      throw Exception('Failed to sell fishasdfasfs');
    }
  }

  static Future<List<SellHistory>> getSellHistoryList(String slug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Failed to get history');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/jual/?store=$slug'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List historyList = jsonDecode(response.body)['results'];
      return historyList.map((item) => SellHistory.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      await FishonService.refreshToken();
      return FishonService.getSellHistoryList(slug);
    } else {
      throw Exception('Failed to get history');
    }
  }
}

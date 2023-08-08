import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/model/bank.dart';
import 'package:nelayan_coba/model/deposit.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/transaction.dart';
import 'package:nelayan_coba/model/user_token.dart';
import 'package:nelayan_coba/model/withdrawal.dart';
import 'package:nelayan_coba/service/prefs_service.dart';

class FishonNewService {
  // static const String baseUrl = 'http://10.0.2.2:8010';
  // static const String clientId = 'ehQNss2iMgu69E5K8ddH1hqreQMjBwHwU16OPGxt';
  // static const String clientSecret =
  //     'YHPuAIyUPdzzyjZdZWxUm3l6kzBQY1b477XEu4vJmxJ3BiuH5CNdQ6aKKdCGCuom2S3Y1rKnaA8mP8IKTigfif9Ib8xVIQnGHbO4H4FV0NS0sQ3HF5bXx62vIeMchnTK';

  static const String baseUrl = 'https://api-staging.perindo.id';
  static const String clientId = '19fHyXuCHuSNw00wBUoSbxdYCUGFUz3qwtSrOOi1';
  static const String clientSecret =
      'ArpwWiPRbdNfyB6XWnprHphQNG9gEQz9ILlbH0rXhRsJ8UgLZWkNEYxSzvjWqA4c0Zxu9oy56pkJmQ6LcIYfKTwZYqHmvZxPVGckQYBpXStyQ0oG4r5AXutNf0oJl7MB';

  final _prefsService = locator<PrefsService>();

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';

  /// Get a new token if old token is expired.
  Future<UserToken> refreshToken() async {
    String? refreshToken = await _prefsService.getRefreshToken();

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
      await _prefsService.setTokens(token.accessToken, token.refreshToken);

      return token;
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get a new token.';
    throw Exception(message);
  }

  /// Get current Seaseed user.
  Future<SeaseedUser> getCurrentSeaseedUser() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/users/current/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return SeaseedUser.fromJson(body['user']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getCurrentSeaseedUser();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get Seaseed user.';
    throw Exception(message);
  }

  /// Get other Seaseed users except current one.
  Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/users/others/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List users = body['users'];

      return users.map((user) => SeaseedUser.fromJson(user)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getOtherSeaseedUsers();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get other users.';
    throw Exception(message);
  }

  /// Create a deposit.
  Future<Deposit> createDeposit(int amount) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

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
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createDeposit(amount);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create deposit.';
    throw Exception(message);
  }

  /// Get a deposit by UUID.
  Future<Deposit> getDeposit(String uuid) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/deposits/?uuid=$uuid'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Deposit.fromJson(body['deposit']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getDeposit(uuid);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get deposit.';
    throw Exception(message);
  }

  /// Create a withdrawal.
  Future<Withdrawal> createWithdrawal(
      int amount, String email, String accountNo, String bankCode) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/api/seaseed/withdrawals/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'amount': '$amount',
        'email': email,
        'account_no': accountNo,
        'bank_code': bankCode,
      },
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Withdrawal.fromJson(body['withdrawal']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createWithdrawal(amount, email, accountNo, bankCode);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create withdrawal.';
    throw Exception(message);
  }

  /// Get a withdrawal by UUID.
  Future<Withdrawal> getWithdrawal(String uuid) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/withdrawals/?uuid=$uuid'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Withdrawal.fromJson(body['withdrawal']);
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getWithdrawal(uuid);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get withdrawal.';
    throw Exception(message);
  }

  /// Get bank list for withdrawal.
  Future<List<Bank>> getBanks() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/banks/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List banks = body['banks'];

      return banks.map((bank) => Bank.fromJson(bank)).toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getBanks();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get banks.';
    throw Exception(message);
  }

  /// Create a transfer.
  Future<bool> createTransfer(
      String toUserUuid, int amount, String remark) async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.post(
      Uri.parse('$baseUrl/api/seaseed/transfers/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: {
        'to_user_uuid': toUserUuid,
        'amount': '$amount',
        'remark': remark,
      },
    );

    if (response.statusCode == 201) {
      return true;
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return createTransfer(toUserUuid, amount, remark);
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to create transfer.';
    throw Exception(message);
  }

  /// Get user's Seaseed transaction list.
  Future<List<Transaction>> getTransactions() async {
    String? token = await _prefsService.getAccessToken();
    if (token == null) throw Exception('Failed to get token.');

    final response = await http.get(
      Uri.parse('$baseUrl/api/seaseed/transactions/'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List transactions = body['transactions'];

      return transactions
          .map((trx) => Transaction.fromJson(trx))
          .toList();
    }

    if (response.statusCode == 401) {
      await refreshToken();
      return getTransactions();
    }

    String message =
        jsonDecode(response.body)['message'] ?? 'Failed to get transactions.';
    throw Exception(message);
  }
}
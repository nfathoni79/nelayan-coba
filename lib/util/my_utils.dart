import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nelayan_coba/model/cart_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyUtils {
  static String formatNumber(int number) {
    return NumberFormat.decimalPattern('id').format(number);
  }

  static void showUnavailableSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Not available in this version'),
    ));
  }

  static Future showLoading(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Memuat...'),
            SizedBox(height: 8),
            CircularProgressIndicator(),
          ],
        ),
        contentPadding: EdgeInsets.all(32),
      ),
      barrierDismissible: false,
    );
  }

  static Future<List<CartProduct>> getFutureCartFromPrefs() async {
    List<CartProduct> cartProductList = [];

    final prefs = await SharedPreferences.getInstance();
    String? jsonStringCart = prefs.getString('cart');

    if (jsonStringCart != null) {
      List jsonCart = jsonDecode(jsonStringCart);
      cartProductList = jsonCart.map((item) => CartProduct.fromJson(item)).toList();
    }

    return cartProductList;
  }

  static Future<bool> saveCartToPrefs(List<CartProduct> cartProductList) async {
    List jsonCart = cartProductList.map((item) => item.toJson()).toList();
    String jsonStringCart = jsonEncode(jsonCart);
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString('cart', jsonStringCart);
  }

  static Future<bool> clearCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('cart');
  }
}
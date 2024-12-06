import 'package:inventory_management/Model/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const _keyProducts = 'product_list';

  static Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productJson = prefs.getString(_keyProducts) ?? '[]';
    final List<dynamic> decoded = jsonDecode(productJson);
    return decoded.map((json) => Product.fromJson(json)).toList();
  }

  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(products.map((product) => product.toJson()).toList());
    await prefs.setString(_keyProducts, encoded);
  }
}

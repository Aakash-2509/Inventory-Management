import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/Model/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final productListProvider =
    StateNotifierProvider<ProductListNotifier, List<Product>>((ref) {
  return ProductListNotifier();
});

class ProductListNotifier extends StateNotifier<List<Product>> {
  ProductListNotifier() : super([]) {
    loadProducts();
  }

  void addProduct(Product product) {
    state = [...state, product];
    saveProducts();
  }

  void updateProduct(int index, Product updatedProduct) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedProduct else state[i]
    ];
    saveProducts();
  }

  void deleteProduct(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
    saveProducts();
  }

  Future<void> saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((product) => product.toJson()).toList();
    await prefs.setString('products', json.encode(jsonList));
  }

  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('products');
    if (jsonString != null) {
      final jsonList = json.decode(jsonString) as List;
      state = jsonList.map((json) => Product.fromJson(json)).toList();
    }
  }
}

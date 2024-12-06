import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/Provider/productProvider.dart';
import 'package:inventory_management/Screens/addProductScreen.dart';
import 'package:inventory_management/Screens/editProductScreen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productList = ref.watch(productListProvider);

    // Filter the product list based on the search query
    final filteredProducts = productList.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.sku.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          "Product List Screen",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                // labelText: 'Search',
                hintText: 'Search by name or SKU',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Product List
            Expanded(
              child: filteredProducts.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final isLowStock = product.quantity < 5;

                        return ListTile(
                          leading: isLowStock
                              ? const Icon(Icons.warning, color: Colors.red)
                              : const Icon(Icons.check_circle,
                                  color: Colors.green),
                          title: Text(product.name),
                          subtitle: Text(
                              'SKU: ${product.sku} | Price: Rs.${product.price.round()}'),
                          trailing: isLowStock
                              ? Text(
                                  'Qty: ${product.quantity}',
                                  style: const TextStyle(color: Colors.red),
                                )
                              : Text(
                                  'Qty: ${product.quantity}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductScreen(
                                    index: index, product: product),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No products found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/Model/productModel.dart';
import 'package:inventory_management/Provider/productProvider.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final int index;
  final Product product;

  const EditProductScreen(
      {super.key, required this.index, required this.product});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: widget.product.price.round().toString());
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text(
            'Edit Product',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Enter valid price'
                        : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || int.tryParse(value) == null
                        ? 'Enter valid quantity'
                        : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedProduct = Product(
                      name: widget.product.name,
                      sku: widget.product.sku,
                      price: double.parse(_priceController.text),
                      quantity: int.parse(_quantityController.text),
                    );
                    ref
                        .read(productListProvider.notifier)
                        .updateProduct(widget.index, updatedProduct);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Product'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: const Text(
                            'Are you sure you want to delete this product?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(productListProvider.notifier)
                                  .deleteProduct(widget.index);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[50]),
                child: const Text('Delete Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

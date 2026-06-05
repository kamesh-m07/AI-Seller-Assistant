import 'package:ai_seller_assistant/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productNameController = TextEditingController();
  final categoryController = TextEditingController();
  final brandController = TextEditingController();
  final costPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: const InputDecoration(
                labelText: "Product Name *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Category *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                labelText: "Brand",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: costPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Cost Price *",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: sellingPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Selling Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Product Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            OutlinedButton.icon(
              onPressed: () {
                // Pick Image
              },
              icon: const Icon(Icons.image),
              label: const Text("Product Image"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await FirestoreService().addProduct(
                    productName: productNameController.text.trim(),
                    category: categoryController.text.trim(),
                    costPrice: costPriceController.text.trim(),
                    brand: brandController.text.trim(),
                    sellingPrice: sellingPriceController.text.trim(),
                    description: descriptionController.text.trim(),
                  );


  productNameController.clear();
  categoryController.clear();
  brandController.clear();
  costPriceController.clear();
  sellingPriceController.clear();
  descriptionController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product add Successfully')),
                  );
                  // Save Product
                },
                child: const Text("Save Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

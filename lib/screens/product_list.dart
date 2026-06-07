import 'package:ai_seller_assistant/screens/ai_listing_screen.dart';
import 'package:ai_seller_assistant/services/ai_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(child: Text('No Products Found'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['productName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),
                      if (product.data().toString().contains('aiTitle'))
                        Text('AI Title: ${product['aiTitle']}'),
                      Text('Category : ${product['category']}'),
                      Text('Brand : ${product['brand']}'),
                      Text('Cost Price : ₹${product['costPrice']}'),
                      if (product.data().toString().contains('sellingPrice'))
                        Text('Selling Price : ₹${product['sellingPrice']}'),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Edit Product
                              },
                              child: const Text('Edit'),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(product.id)
                                    .delete();
                              },
                              child: const Text('Delete'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AiListingScreen(product: product),
                              ),
                            );
                          },
                          // onPressed: () async {
                          //   final result = await GeminiService()
                          //       .generateListing(
                          //         productName: product['productName'],
                          //         category: product['category'],
                          //         brand: product['brand'],
                          //         sellingPrice: product['sellingPrice'],
                          //         description: product['description'],
                          //       );

                          //   showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       title: const Text('AI Listing'),
                          //       content: SingleChildScrollView(
                          //         child: Text(result),
                          //       ),
                          //     ),
                          //   );
                          // },
                          child: const Text('Generate AI Listing'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

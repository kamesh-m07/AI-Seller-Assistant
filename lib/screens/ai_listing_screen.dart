import 'package:ai_seller_assistant/services/ai_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AiListingScreen extends StatefulWidget {
  final QueryDocumentSnapshot product;

  const AiListingScreen({super.key, required this.product});

  @override
  State<AiListingScreen> createState() => _AiListingScreenState();
}

class _AiListingScreenState extends State<AiListingScreen> {
  bool isLoading = true;
  String aiContent = '';

  @override
  void initState() {
    super.initState();
    generateListing();
  }

  Future<void> generateListing() async {
    try {
      final result = await GeminiService().generateListing(
        productName: widget.product['productName'],
        category: widget.product['category'],
        brand: widget.product['brand'],
        sellingPrice: widget.product['sellingPrice'],
        description: widget.product['description'],
      );

      setState(() {
        aiContent = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        aiContent = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> saveListing() async {
    await FirebaseFirestore.instance.collection('ai_listings').add({
      'productId': widget.product.id,
      'productName': widget.product['productName'],
      'aiContent': aiContent,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('AI Listing Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Listing'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['productName'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          aiContent,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveListing,
                      child: const Text('Save AI Listing'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

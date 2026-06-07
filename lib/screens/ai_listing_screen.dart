import 'dart:convert';

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

  String aiTitle = '';
  String aiDescription = '';
  String aiKeywords = '';
  String aiSuggestedPrice = '';

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
        costPrice: widget.product['costPrice'],
      );

      print(result);

      final data = jsonDecode(result);

      setState(() {
        aiTitle = data['aiTitle'] ?? '';
        aiDescription = data['aiDescription'] ?? '';
        aiKeywords = data['aiKeywords'] ?? '';
        aiSuggestedPrice = data['aiSuggestedPrice'].toString();

        isLoading = false;
      });
    } catch (e) {
      print("ERROR : $e");

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> saveListing() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.product.id)
        .update({
          'aiTitle': aiTitle,
          'aiDescription': aiDescription,
          'aiKeywords': aiKeywords,
          'aiSuggestedPrice': aiSuggestedPrice,
          'aiGeneratedAt': Timestamp.now(),
        });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI Listing Saved Successfully')),
    );
  }

  Widget buildField(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Listing'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildField('🤖 Product Title', aiTitle),

                  buildField('🤖 Product Description', aiDescription),

                  buildField('🤖 SEO Keywords', aiKeywords),

                  buildField(
                    '🤖 Suggested Selling Price',
                    '₹$aiSuggestedPrice',
                  ),

                  const SizedBox(height: 20),

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

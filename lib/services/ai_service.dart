import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  Future<String> generateListing({
    required String productName,
    required String category,
    required String brand,
    required String sellingPrice,
    required String description,
  }) async {
    final response = await Gemini.instance.text(
      '''
Create an attractive e-commerce product listing.

Product Name: $productName
Category: $category
Brand: $brand
Selling Price: ₹$sellingPrice
Description: $description

Generate:
1. Product Title
2. Product Description
3. Key Features (5 points)
''',
    );

    return response?.output ?? 'No response generated';
  }
}
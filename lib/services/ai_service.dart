import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  Future<String> generateListing({
    required String productName,
    required String category,
    required String brand,
    required String costPrice,
  }) async {
    final response = await Gemini.instance.text('''
Generate an e-commerce listing.

Product Name: $productName
Category: $category
Brand: $brand
Cost Price: ₹$costPrice

Return ONLY valid JSON in this format:

{
  "aiTitle": "",
  "aiDescription": "",
  "aiKeywords": "",
  "aiSuggestedPrice": 0
}

Do not add markdown.
Do not add explanation.
Return JSON only.
''');

    print(response?.output);
    print('hi');

    return response?.output ?? '{}';
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProduct({
    required String productName,
    required String category,
    required String brand,
    required String costPrice,
    required String sellingPrice,
    required String description,
  }) async {
    await _firestore.collection('products').add({
      'productName': productName,
      'category': category,
      'brand': brand,
      'costPrice': costPrice,
      'sellingPrice': sellingPrice,
      'description': description,
      'createdAt': Timestamp.now(),
    });
  }
}

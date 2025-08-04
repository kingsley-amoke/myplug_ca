import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/domain/repositories/product_repository.dart';

class ProductFirestoreService implements ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Product?> loadProduct(String productId) async {
    final res = await _firestore.collection('products').doc(productId).get();
    if (res.data() != null) {
      return Product.fromMap(res.data()!);
    } else {
      return null;
    }
  }

  @override
  Future<List<Product>> loadAllProducts() async {
    final snapshot = await _firestore.collection('products').get();

    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.data());
    }).toList();
  }

  @override
  Future<Product?> addProduct(Product product) async {
    final docRef = _firestore.collection('products').doc();

    await docRef.set(product.copyWith(id: docRef.id).toMap());
    return product.copyWith(id: docRef.id);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
    return product;
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }
}

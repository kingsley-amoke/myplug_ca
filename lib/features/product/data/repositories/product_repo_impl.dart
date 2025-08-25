import 'dart:io';

import 'package:fixnbuy/features/product/domain/models/product.dart';
import 'package:fixnbuy/features/product/domain/repositories/product_repository.dart';
import 'package:fixnbuy/features/product/services/database_service.dart';

class ProductRepoImpl extends ProductRepository {
  final ProductDatabaseService _databaseService;

  ProductRepoImpl(this._databaseService);

  @override
  Future<Product?> loadProduct(String productId) async {
    return await _databaseService.loadProduct(productId);
  }

  @override
  Future<List<Product>> loadAllProducts() async {
    return await _databaseService.loadAllProducts();
  }

  @override
  Future<Product?> addProduct(Product product) async {
    return await _databaseService.addProduct(product);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    return await _databaseService.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    return await _databaseService.deleteProduct(productId);
  }

  Future<String?> uploadImage({
    required File imageFile,
    required String path,
    required String productId,
  }) async {
    return await _databaseService.uploadImage(
      imageFile: imageFile,
      path: path,
      productId: productId,
    );
  }

  Future<void> deleteProductImage(String url) async {
    await _databaseService.deleteProductImage(url);
  }
}

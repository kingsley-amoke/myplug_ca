import 'dart:io';

import 'package:myplug_ca/core/domain/repositories/image_upload_repo.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/domain/repositories/product_repository.dart';

class ProductDatabaseService implements ProductRepository {
  final ProductRepository databaseService;
  final FileUploadRepo fileUploadService;

  ProductDatabaseService(
      {required this.databaseService, required this.fileUploadService});

  @override
  Future<Product?> loadProduct(String productId) async {
    return databaseService.loadProduct(productId);
  }

  @override
  Future<List<Product>> loadAllProducts() async {
    return databaseService.loadAllProducts();
  }

  @override
  Future<Product?> addProduct(Product product) async {
    return databaseService.addProduct(product);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    return databaseService.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    return databaseService.deleteProduct(productId);
  }

  Future<String?> uploadImage({
    required File imageFile,
    required String path,
    required String productId,
  }) async {
    return await fileUploadService.uploadImage(
      imageFile: imageFile,
      path: path,
      id: productId,
    );
  }

  Future<void> deleteProductImage(String url) async {
    await fileUploadService.deleteImage(url);
  }
}

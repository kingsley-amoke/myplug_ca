import 'package:fixnbuy/features/product/domain/models/product.dart';

abstract class ProductRepository {
  Future<Product?> loadProduct(String productId);
  Future<List<Product>> loadAllProducts();
  Future<Product?> addProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
}

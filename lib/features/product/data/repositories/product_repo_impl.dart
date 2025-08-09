import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/domain/repositories/product_repository.dart';
import 'package:myplug_ca/features/product/services/database_service.dart';

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
}

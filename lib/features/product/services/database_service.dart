import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/features/product/domain/repositories/product_repository.dart';

class DatabaseService implements ProductRepository {
  final ProductRepository _databaseService;

  DatabaseService(this._databaseService);

  @override
  Future<Product?> loadProduct(String productId) async {
    return _databaseService.loadProduct(productId);
  }

  @override
  Future<List<Product>> loadAllProducts() async {
    return _databaseService.loadAllProducts();
  }

  @override
  Future<Product?> addProduct(Product product) async {
    return _databaseService.addProduct(product);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    return _databaseService.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    return _databaseService.deleteProduct(productId);
  }
}

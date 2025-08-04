import 'package:flutter/material.dart';
import 'package:myplug_ca/core/constants/products.dart';
import 'package:myplug_ca/features/product/data/repositories/product_repo_impl.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepoImpl _productRepoImpl;

  ProductProvider(this._productRepoImpl);

  List<Product> _products = [];
  Product? _currentProduct;

  List<Product> get products => _products;
  Product? get currentProduct => _currentProduct;

  Future<void> loadProduct(String productId) async {
    _currentProduct = await _productRepoImpl.loadProduct(productId);
    notifyListeners();
  }

  Future<void> loadProducts() async {
    // _products = await _productRepoImpl.loadAllProducts();
    _products = demoProducts;
    notifyListeners();
  }
}

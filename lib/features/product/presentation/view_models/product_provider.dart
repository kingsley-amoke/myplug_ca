import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/core/constants/products.dart';
import 'package:myplug_ca/features/product/data/repositories/product_repo_impl.dart';
import 'package:myplug_ca/features/product/domain/models/myplug_shop.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepoImpl _productRepoImpl;

  ProductProvider(this._productRepoImpl);

  List<Product> _products = [];
  List<Product> _productsByCategory = [];
  Product? _currentProduct;
  List<Product> _myProducts = [];

  List<Product> get products => _products;
  List<Product> get productsByCategory => _productsByCategory;
  Product? get currentProduct => _currentProduct;
  List<Product> get myProducts => _myProducts;

  Future<void> loadProduct(String productId) async {
    _currentProduct = await _productRepoImpl.loadProduct(productId);
    notifyListeners();
  }

  Future<void> loadProducts() async {
    // _products = await _productRepoImpl.loadAllProducts();
    _products = demoProducts;
    notifyListeners();
  }

  void getMyProducts(String userId) {
    _myProducts = _products.where((p) => p.seller.id == userId).toList();
    notifyListeners();
  }

  void getProductsByCategory(MyplugShop shop) {
    _productsByCategory = _products.where((item) => item.shop == shop).toList();
    notifyListeners();
  }

  List<Product> filterByParams<T>({
    String? location,
    double? rating,
    double? minPrice,
  }) {
    List<Product> matches = [];

    for (Product item in _productsByCategory) {
      // bool matches = true;

      if (minPrice == null && location == null && rating == null) {
        matches = _productsByCategory;
      }

      if (location != null && rating != null && minPrice != null) {
        // matches.clear();
        if (item.price >= minPrice) {
          matches.add(item);
        }
        if (getAverageRating(ratings: item.ratings) >= rating) {
          matches.add(item);
        }
        if (location.toLowerCase() == item.location.toLowerCase()) {
          matches.add(item);
        }
      }

      if (location != null && rating != null && minPrice == null) {
        // matches.clear();
        if (getAverageRating(ratings: item.ratings) >= rating) {
          matches.add(item);
        }
        if (location.toLowerCase() == item.location.toLowerCase()) {
          matches.add(item);
        }
      }

      if (location != null && minPrice != null && rating == null) {
        // matches.clear();
        if (item.price >= minPrice) {
          matches.add(item);
        }
        if (location.toLowerCase() == item.location.toLowerCase()) {
          matches.add(item);
        }
      }
      if (rating != null && minPrice != null && location == null) {
        // matches.clear();
        if (item.price >= minPrice) {
          matches.add(item);
        }
        if (getAverageRating(ratings: item.ratings) >= rating) {
          matches.add(item);
        }
      }

      if (location != null) {
        // print(location);
        // matches.clear();
        if (item.location.toLowerCase() == location.toLowerCase()) {
          matches.add(item);
        }
      }

      // Filter by jobType (optional)
      if (rating != null) {
        // matches.clear();
        if (getAverageRating(ratings: item.ratings) >= rating) {
          matches.add(item);
        }
      }

      // Filter by minSalary only (optional)
      if (minPrice != null) {
        // print('here');
        // matches.clear();
        if (item.price >= minPrice) {
          matches.add(item);
        }
      }
    }

    // print(matches);

    _productsByCategory = matches;

    notifyListeners();
    return matches;
  }

  //assign Current product

  void assignCurrentProduct(String productId) {
    _currentProduct = _products.firstWhere((p) => p.id == productId);
    notifyListeners();
  }

//update product
  Future<void> updateProduct({
    required String id,
    String? title,
    String? description,
    String? location,
    double? price,
    Rating? rating,
    List<String>? images,
  }) async {
    assignCurrentProduct(id);
    final updatedProduct = _currentProduct?.copyWith(
      title: title,
      description: description,
      location: location,
      price: price,
      rating: rating,
      images: images,
    );

    if (updatedProduct != null) {
      _productRepoImpl.updateProduct(updatedProduct);
    }

    notifyListeners();
  }

//delete product
  Future<void> deleteProduct(
      {required MyplugUser user, required Product product}) async {
    if (user.isAdmin || user.id == product.seller.id) {
      await _productRepoImpl.deleteProduct(product.id!);

      _products.remove(product);
      notifyListeners();
    }
  }
}

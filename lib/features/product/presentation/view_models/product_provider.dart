import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myplug_ca/core/config/config.dart';
import 'package:myplug_ca/features/product/data/repositories/product_repo_impl.dart';
import 'package:myplug_ca/features/product/domain/models/myplug_shop.dart';
import 'package:myplug_ca/features/product/domain/models/product.dart';
import 'package:myplug_ca/core/domain/models/rating.dart';
import 'package:myplug_ca/features/user/domain/models/myplug_user.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepoImpl _productRepoImpl;

  ProductProvider(this._productRepoImpl);

  List<Product> _products = [];
  List<Product> allProducts = [];
  List<Product> _productsByCategory = [];
  List<Product> filteredProducts = [];
  List<Product> filteredMyProducts = [];
  List<Product> promotedProducts = [];

  bool productsByCategoryLoading = true;
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
    _products = await _productRepoImpl.loadAllProducts();
    _sortProducts();
    filteredProducts = _products;
    allProducts = _products;
    promotedProducts = _products.where((p) => p.isPromoted).toList();
    notifyListeners();
  }

  void getMyProducts(String userId) {
    _myProducts = _products.where((p) => p.seller.id == userId).toList();
    filteredMyProducts = _myProducts;

    // notifyListeners();
  }

  void getProductsByCategory(MyplugShop shop) {
    productsByCategoryLoading = true;
    _productsByCategory =
        _products.where((item) => item.shop.id == shop.id).toList();
    productsByCategoryLoading = false;
    notifyListeners();
  }

//sort products by promotions
  void _sortProducts() {
    _products.sort((a, b) {
      if (a.isPromoted && !b.isPromoted) return -1; // Promoted comes first
      if (!a.isPromoted && b.isPromoted) return 1;
      return 0; // Keep original order otherwise
    });
  }

  List<Product> filterByParams({
    String? location,
    double? rating,
    double? minPrice,
    String? searchTerm,
  }) {
    List<Product> matches = [];

    for (Product item in _productsByCategory) {
      bool match = true;

      // Location filter
      if (location != null &&
          item.location.toLowerCase() != location.toLowerCase()) {
        match = false;
      }

      // Rating filter
      if (rating != null && getAverageRating(ratings: item.ratings) < rating) {
        match = false;
      }

      // Price filter
      if (minPrice != null && item.price < minPrice) {
        match = false;
      }

      // Search term filter (ignore if null or empty)
      if (searchTerm != null && searchTerm.trim().isNotEmpty) {
        final term = searchTerm.toLowerCase();
        final name = item.title.toLowerCase();
        final description = item.description.toLowerCase();

        if (!(name.contains(term) || description.contains(term))) {
          match = false;
        }
      }

      if (match) {
        matches.add(item);
      }
    }

    _productsByCategory = matches;
    notifyListeners();
    return matches;
  }

  List<Product> filterAllProductsByParams({
    String? location,
    double? rating,
    double? minPrice,
    String? searchTerm,
  }) {
    List<Product> matches = [];

    for (Product item in _products) {
      bool match = true;

      // Location filter
      if (location != null &&
          item.location.toLowerCase() != location.toLowerCase()) {
        match = false;
      }

      // Rating filter
      if (rating != null && getAverageRating(ratings: item.ratings) < rating) {
        match = false;
      }

      // Price filter
      if (minPrice != null && item.price < minPrice) {
        match = false;
      }

      // Search term filter (ignore if null or empty)
      if (searchTerm != null && searchTerm.trim().isNotEmpty) {
        final term = searchTerm.toLowerCase();
        final name = item.title.toLowerCase();
        final description = item.description.toLowerCase();

        if (!(name.contains(term) || description.contains(term))) {
          match = false;
        }
      }

      if (match) {
        matches.add(item);
      }
    }

    allProducts = matches;
    notifyListeners();
    return matches;
  }

  List<Product> searchAllProducts({
    required String search,
  }) {
    // If search is empty, restore all products
    if (search.trim().isEmpty) {
      filteredProducts = List<Product>.from(_products); // restore all
      notifyListeners();
      return filteredProducts;
    }

    List<Product> matches = [];

    for (Product product in _products) {
      final term = search.toLowerCase();

      final title = product.title.toLowerCase();
      final description = product.description.toLowerCase();
      final location = product.location.toLowerCase();
      final shop = product.shop.name.toLowerCase();
      final seller = product.seller.fullname.toLowerCase();

      if (title.contains(term) ||
          description.contains(term) ||
          location.contains(term) ||
          shop.contains(term) ||
          seller.contains(term)) {
        matches.add(product);
      }
    }

    filteredProducts = matches;
    notifyListeners();
    return filteredProducts;
  }

  List<Product> searchMyProducts({
    required String search,
  }) {
    // If search is empty, restore all products
    if (search.trim().isEmpty) {
      filteredMyProducts = List<Product>.from(_myProducts);
      notifyListeners();
      return filteredMyProducts;
    }

    List<Product> matches = [];

    for (Product product in _myProducts) {
      final term = search.toLowerCase();

      final title = product.title.toLowerCase();
      final description = product.description.toLowerCase();
      final location = product.location.toLowerCase();
      final shop = product.shop.name.toLowerCase();
      final seller = product.seller.fullname.toLowerCase();

      if (title.contains(term) ||
          description.contains(term) ||
          location.contains(term) ||
          shop.contains(term) ||
          seller.contains(term)) {
        matches.add(product);
      }
    }

    filteredMyProducts = matches;
    notifyListeners();
    return filteredMyProducts;
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

  Future<void> addProduct({
    required String title,
    required String description,
    required double price,
    required String location,
    required MyplugShop shop,
    required MyplugUser seller,
    required List<File> images,
  }) async {
    final product = Product(
      description: description,
      images: [],
      seller: seller,
      title: title,
      location: location,
      price: price,
      shop: shop,
    );

    List<String> newUrs = [];
    for (File i in images) {
      final url = await _productRepoImpl.uploadImage(
        imageFile: i,
        path: 'products',
        productId: 'new',
      );
      if (url != null) {
        newUrs.add(url);
      }
    }

    final addedProduct = product.copyWith(images: newUrs);

    await _productRepoImpl
        .addProduct(
      addedProduct,
    )
        .then((_) {
      _products.add(addedProduct);
      _myProducts.add(addedProduct);
    });

    notifyListeners();
  }

  Future<void> editProduct({
    required Product product,
    required String title,
    required String description,
    required String location,
    required double price,
    required List<String> existingImages,
    required List<File> newImages,
  }) async {
    List<String> newUrs = [];

    if (newImages.isNotEmpty) {
      for (File i in newImages) {
        final url = await _productRepoImpl.uploadImage(
          imageFile: i,
          path: 'products',
          productId: product.id!,
        );
        if (url != null) {
          newUrs.add(url);
        }
      }
    }

    if (newUrs.isNotEmpty) {
      existingImages.addAll(newUrs);
    }

    final updatedProduct = product.copyWith(
      title: title,
      description: description,
      location: location,
      price: price,
      images: existingImages,
    );

    _productRepoImpl.updateProduct(updatedProduct).then(((_) {
      _products.remove(product);
      _products.add(updatedProduct);

      filteredProducts = _products;

      notifyListeners();
    }));

    notifyListeners();
  }

  //add review
  Future<void> addReview(Product product) async {
    _productRepoImpl.updateProduct(product);
  }

  //promote product
  Future<void> promoteProduct(Product product) async {
    final updatedProduct = product.copyWith(isPromoted: true);

    _products.remove(product);
    _products.insert(0, updatedProduct);

    _myProducts.remove(product);
    _myProducts.insert(0, updatedProduct);
    promotedProducts.insert(0, updatedProduct);

    notifyListeners();
  }

  //cancel product promotion
  Future<void> cancelPromotion(Product product) async {
    final updatedProduct = product.copyWith(isPromoted: false);

    await _productRepoImpl.updateProduct(updatedProduct);

    _products.remove(product);
    _products.insert(0, updatedProduct);
    _myProducts.remove(product);
    _myProducts.insert(0, updatedProduct);
    promotedProducts.remove(product);
    notifyListeners();
  }

  //auto cancel promotions
  Future<void> checkAndCancelPromotions(List<String> productIds) async {
    await loadProducts();
    for (String id in productIds) {
      final productToCancel = _products.firstWhere((p) => p.id == id);
      cancelPromotion(productToCancel);
    }
  }

//delete product
  Future<void> deleteProduct(
      {required MyplugUser user, required Product product}) async {
    if (user.isAdmin || user.id == product.seller.id) {
      await _productRepoImpl.deleteProduct(product.id!);

      for (String i in product.images) {
        _productRepoImpl.deleteProductImage(i);
      }

      _products.remove(product);
      notifyListeners();
    }
  }
}

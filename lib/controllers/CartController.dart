import 'package:ecommers/controllers/storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartController extends GetxController {
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxDouble _subtotal = 0.0.obs;
  final RxDouble _discount = 0.0.obs;
  final RxDouble _total = 0.0.obs;
  final RxBool _isLoading = false.obs;
  final TextEditingController discountCodeController = TextEditingController();
  final StorageService _storageService = Get.find<StorageService>();

  // Getters for observables
  List<CartItem> get cartItems => _cartItems;
  double get subtotal => _subtotal.value;
  double get discount => _discount.value;
  double get total => _total.value;
  bool get isLoading => _isLoading.value;
  bool get isEmpty => _cartItems.isEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
  }

  // Load cart data from local storage
  Future<void> _loadCartFromStorage() async {
    _isLoading.value = true;
    try {
      final storedCart = await _storageService.getCart();
      if (storedCart != null && storedCart.isNotEmpty) {
        _cartItems.assignAll(storedCart);
        _calculateTotals();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Save cart to local storage
  Future<void> _saveCartToStorage() async {
    try {
      await _storageService.saveCart(_cartItems);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Add product to cart
  void addToCart(Product product, {int quantity = 1, String? size, String? color}) {
    final existingIndex = _cartItems.indexWhere((item) => 
      item.product.id == product.id && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (existingIndex != -1) {
      // Update existing item
      final updatedItem = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity
      );
      _cartItems[existingIndex] = updatedItem;
    } else {
      // Add new item
      _cartItems.add(CartItem(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    
    _calculateTotals();
    _saveCartToStorage();
    
    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      duration: Duration(seconds: 2),
    );
  }

  // Remove item from cart
  void removeFromCart(int productId, {String? size, String? color}) {
    final existingIndex = _cartItems.indexWhere((item) => 
      item.product.id == productId && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (existingIndex != -1) {
      _cartItems.removeAt(existingIndex);
      _calculateTotals();
      _saveCartToStorage();
    }
  }

  // Increment item quantity
  void incrementQuantity(int productId, {String? size, String? color}) {
    final existingIndex = _cartItems.indexWhere((item) => 
      item.product.id == productId && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (existingIndex != -1) {
      final updatedItem = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1
      );
      _cartItems[existingIndex] = updatedItem;
      _calculateTotals();
      _saveCartToStorage();
    }
  }

  // Decrement item quantity
  void decrementQuantity(int productId, {String? size, String? color}) {
    final existingIndex = _cartItems.indexWhere((item) => 
      item.product.id == productId && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (existingIndex != -1) {
      if (_cartItems[existingIndex].quantity > 1) {
        final updatedItem = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity - 1
        );
        _cartItems[existingIndex] = updatedItem;
      } else {
        _cartItems.removeAt(existingIndex);
      }
      _calculateTotals();
      _saveCartToStorage();
    }
  }

  // Update item quantity directly
  void updateQuantity(int productId, int quantity, {String? size, String? color}) {
    if (quantity <= 0) {
      removeFromCart(productId, size: size, color: color);
      return;
    }

    final existingIndex = _cartItems.indexWhere((item) => 
      item.product.id == productId && 
      item.selectedSize == size && 
      item.selectedColor == color
    );

    if (existingIndex != -1) {
      final updatedItem = _cartItems[existingIndex].copyWith(quantity: quantity);
      _cartItems[existingIndex] = updatedItem;
      _calculateTotals();
      _saveCartToStorage();
    }
  }

  // Apply discount code
  Future<void> applyDiscountCode(String code) async {
    _isLoading.value = true;
    try {
      // Simulate API call to validate discount code
      await Future.delayed(Duration(milliseconds: 800));
      
      // Example discount logic (in a real app, this would come from API)
      if (code.toUpperCase() == 'SAVE10') {
        _discount.value = _subtotal.value * 0.1; // 10% discount
        Get.snackbar(
          'Discount Applied',
          '10% discount has been applied to your order',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
        );
      } else if (code.toUpperCase() == 'SAVE20') {
        _discount.value = _subtotal.value * 0.2; // 20% discount
        Get.snackbar(
          'Discount Applied',
          '20% discount has been applied to your order',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
        );
      } else {
        _discount.value = 0.0;
        Get.snackbar(
          'Invalid Code',
          'The discount code you entered is invalid or expired',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
        );
      }
      
      _calculateTotals();
    } finally {
      _isLoading.value = false;
    }
  }

  // Calculate totals
  void _calculateTotals() {
    _subtotal.value = _cartItems.fold(
      0, (sum, item) => sum + item.total
    );
    _total.value = _subtotal.value - _discount.value;
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    _discount.value = 0.0;
    _calculateTotals();
    _saveCartToStorage();
  }

  // Process checkout
  Future<void> checkout() async {
    if (_cartItems.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Add items to your cart before checkout',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;
    try {
      // Simulate checkout process
      await Future.delayed(Duration(seconds: 2));
      
      // Clear cart after successful checkout
      clearCart();
      
      Get.snackbar(
        'Order Placed',
        'Your order has been placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        duration: Duration(seconds: 3),
      );
      
      // Navigate to order confirmation or home page
      Get.offAllNamed('/order-confirmation');
    } catch (e) {
      Get.snackbar(
        'Checkout Failed',
        'Unable to process your order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
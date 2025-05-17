import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late SharedPreferences _prefs;
  
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }
  
  // Cart storage methods
  Future<void> saveCart(List<CartItem> cartItems) async {
    // Convert CartItem list to a format that can be stored
    // Since we can't directly store objects, we'll store just the IDs and quantities
    final cartItemsData = cartItems.map((item) => {
      'productId': item.product.id,
      'quantity': item.quantity,
      'selectedSize': item.selectedSize,
      'selectedColor': item.selectedColor,
    }).toList();
    
    await _prefs.setString('cart', jsonEncode(cartItemsData));
  }
  
  Future<List<CartItem>?> getCart() async {
    final cartData = _prefs.getString('cart');
    if (cartData == null) return null;
    
    try {
      final decodedData = jsonDecode(cartData) as List;
      // We need to get the product details for each item in the cart
      // This would normally be fetched from a product service or cache
      // For now, we'll assume the product data is available elsewhere
      // In a real app, you might need to fetch the product details 
      // from your API or local cache
      
      // This is just a placeholder - in a real app, you'd need to 
      // implement a way to get the product details by ID
      return [];
    } catch (e) {
      print('Error retrieving cart: $e');
      return null;
    }
  }
  
  // Other storage methods can be added here
  // For example, storing user preferences, auth tokens, etc.
}
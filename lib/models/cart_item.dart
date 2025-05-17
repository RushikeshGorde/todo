import 'package:ecommers/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  String? selectedSize;
  String? selectedColor;
  
  CartItem({
    required this.product, 
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  // Calculate the total for this cart item
  double get total => product.price * quantity;
  
  // Create a copy of the cart item with updated properties
  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
  
  // Convert CartItem to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
    };
  }
  
  @override
  String toString() => 'CartItem(product: ${product.title}, quantity: $quantity, total: \$${total.toStringAsFixed(2)})';
}
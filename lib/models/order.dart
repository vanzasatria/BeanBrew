// models/order.dart
import 'package:beanbrewapps/models/product.dart';

class Order {
  final Product product;
  final int quantity;
  final double totalPrice;
  final String status;

  Order({
    required this.product,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });
}

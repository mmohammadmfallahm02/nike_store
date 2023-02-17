import 'package:nike/data/product.dart';

class CartResponse {
  final int productId;
  final int count;
  final int cartItemId;
  CartResponse.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        count = json['count'],
        cartItemId = json['id'];
}

class ProductCartListItem {
  final ProductEntity product;
  final int count;
  final int cartItemId;

  ProductCartListItem(this.product, this.count, this.cartItemId);
}

class CartListResponse {
  final List<ProductCartListItem> cartItems;
  final int orderId;
  final int payablePrice;
  final int totalPrice;
  final int shoppingCost;
  final String date;

  CartListResponse.fromJson(Map<String, dynamic> json)
      : cartItems = json['order_items'],
        orderId = json['id'],
        payablePrice = json['payable'],
        totalPrice = json['total'],
        shoppingCost = json['shipping_cost'],
        date = json['date'];
}

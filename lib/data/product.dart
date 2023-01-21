class ProductEntity {
  final int id;
  final String title;
  final String imageUrl;
  final int price;
  final int discount;
  final int previousPrice;

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['price'],
        discount = json['discount'],
        previousPrice = json['previous_price']??json['price'];
}

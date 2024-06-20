class Product {
  final String id;
  final String name;
  final String image;
  final int price;
  final String category;
  final String description;
  final double rating;
  final bool isRecommended;
  final bool isBestSeller;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
    required this.isRecommended,
    required this.isBestSeller,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      category: json['category'],
      description: json['description'],
      rating: json['rating'],
      isRecommended: json['isRecommended'],
      isBestSeller: json['isBestSeller'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'category': category,
      'description': description,
      'rating': rating,
      'isRecommended': isRecommended,
      'isBestSeller': isBestSeller,
    };
  }
}

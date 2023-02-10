class Product {
  final int id;
  final String? brand,
      name,
      price,
      priceSign,
      image,
      link,
      category,
      description;
  final List<String>? tags;
  final List<Map<String, dynamic>>? colors;

  Product(
      {required this.id,
      this.brand,
      this.name,
      this.price,
      this.priceSign,
      this.image,
      this.link,
      this.description,
      this.category,
      this.tags,
      this.colors});

  factory Product.fromJson(final Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      name: json['name'],
      price: json['price'],
      priceSign: json['price_sign'],
      image: json['image_link'],
      link: json['product_link'],
      description: json['description'],
      category: json['category'],
      tags: List<String>.from(json['tag_list']),
      colors: List<Map<String, dynamic>>.from(json['product_colors']),
    );
  }
}

// ignore_for_file: avoid_print

class Product {
  int id;
  String name;
  String description;
  double price;
  String image;
  bool favorite = false;
  int cartCount = 0;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    favorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double price = 0.0;
    try {
      price = json['attributes']['price'];
    } catch (e) {
      price = json['attributes']['price'].toDouble();
    }

    return Product(
        id: json['id'],
        name: json['attributes']['name'],
        description: json['attributes']['description'],
        price: price,
        image: 'http://10.0.2.2:1337' +
            json['attributes']['image']['data']['attributes']['url']);
  }
}

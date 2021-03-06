class User {
  int id;
  String username;
  String email;
  String jwt;
  int cartId;
  int favoriteId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.jwt,
    required this.cartId,
    required this.favoriteId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        jwt: json['jwt'],
        cartId: json['cart_id'],
        favoriteId: json['favorite_id'],
      );
}

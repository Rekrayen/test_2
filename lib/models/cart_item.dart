class CartItem {
  final String id;
  final String masterClassId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.masterClassId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => price * quantity;

  CartItem copyWith({
    String? id,
    String? masterClassId,
    String? title,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      masterClassId: masterClassId ?? this.masterClassId,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}

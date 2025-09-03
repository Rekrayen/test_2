import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/masterclass.dart';

class CartManager with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(MasterClass masterClass) {
    if (_items.containsKey(masterClass.id)) {
      _items.update(
        masterClass.id,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        masterClass.id,
        () => CartItem(
          id: 'c${DateTime.now().toIso8601String()}',
          masterClassId: masterClass.id,
          title: masterClass.title,
          quantity: 1,
          price: masterClass.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String masterClassId) {
    _items.remove(masterClassId);
    notifyListeners();
  }

  void removeSingleItem(String masterClassId) {
    if (!_items.containsKey(masterClassId)) {
      return;
    }
    if (_items[masterClassId]!.quantity > 1) {
      _items.update(
        masterClassId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(masterClassId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

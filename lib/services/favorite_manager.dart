import 'package:flutter/foundation.dart';

class FavoriteManager with ChangeNotifier {
  final List<String> _favoriteIds = [];

  List<String> get favoriteIds => [..._favoriteIds];

  bool isFavorite(String masterClassId) {
    return _favoriteIds.contains(masterClassId);
  }

  void addToFavorites(String masterClassId) {
    if (!_favoriteIds.contains(masterClassId)) {
      _favoriteIds.add(masterClassId);
      notifyListeners();
    }
  }

  void removeFromFavorites(String masterClassId) {
    if (_favoriteIds.contains(masterClassId)) {
      _favoriteIds.remove(masterClassId);
      notifyListeners();
    }
  }

  void toggleFavorite(String masterClassId) {
    if (isFavorite(masterClassId)) {
      removeFromFavorites(masterClassId);
    } else {
      addToFavorites(masterClassId);
    }
  }
}

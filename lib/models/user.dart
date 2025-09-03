import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String id;
  String name;
  final String email;
  final String userType;
  String? avatarUrl;
  String? bannerUrl; // ДОБАВЬТЕ ПОЛЕ ДЛЯ БАННЕРА
  final List<String> favoriteMasterClasses;
  final DateTime registrationDate;

  String? schoolName;
  String? description;
  String? website;
  String? socialMedia;
  String? phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.avatarUrl,
    this.bannerUrl, // ДОБАВЬТЕ В КОНСТРУКТОР
    this.favoriteMasterClasses = const [],
    required this.registrationDate,
    this.schoolName,
    this.description,
    this.website,
    this.socialMedia,
    this.phone,
  });

  bool get isSeller => userType == 'seller';

  User copyWith({
    String? name,
    String? avatarUrl,
    String? bannerUrl, // ДОБАВЬТЕ В COPYWITH
    String? schoolName,
    String? description,
    String? website,
    String? socialMedia,
    String? phone,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email,
      userType: userType,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl, // ДОБАВЬТЕ
      favoriteMasterClasses: favoriteMasterClasses,
      registrationDate: registrationDate,
      schoolName: schoolName ?? this.schoolName,
      description: description ?? this.description,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
      phone: phone ?? this.phone,
    );
  }
}

class AuthService with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'seller@example.com') {
      _currentUser = User(
        id: '2',
        name: 'Иван Продавец',
        email: email,
        userType: 'seller',
        registrationDate: DateTime.now(),
        schoolName: 'Студия творчества "Арт-Хаб"',
        description: 'Профессиональные мастер-классы по живописи и кулинарии',
        website: 'www.art-hub.ru',
        socialMedia: '@arthub',
        phone: '+7 (999) 123-45-67',
      );
      notifyListeners();
      return true;
    } else {
      _currentUser = User(
        id: '1',
        name: 'Петр Покупатель',
        email: email,
        userType: 'buyer',
        registrationDate: DateTime.now(),
        phone: '+7 (999) 123-45-67',
      );
      notifyListeners();
      return true;
    }
  }

  void updateUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

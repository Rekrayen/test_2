class User {
  final String id;
  final String name;
  final String email;
  final String userType;
  final String? avatarUrl;
  final List<String> favoriteMasterClasses;
  final DateTime registrationDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.avatarUrl,
    this.favoriteMasterClasses = const [],
    required this.registrationDate,
  });

  bool get isSeller => userType == 'seller';
}

class AuthService {
  static User? currentUser;

  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'seller@example.com') {
      currentUser = User(
        id: '2',
        name: 'Иван Продавец',
        email: email,
        userType: 'seller',
        registrationDate: DateTime.now(),
      );
      return true;
    } else {
      currentUser = User(
        id: '1',
        name: 'Петр Покупатель',
        email: email,
        userType: 'buyer',
        registrationDate: DateTime.now(),
      );
      return true;
    }
  }

  static void logout() {
    currentUser = null;
  }
}

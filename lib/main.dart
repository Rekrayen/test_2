import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/cart_manager.dart';
import 'services/favorite_manager.dart';
import 'services/theme_manager.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthService()),
        ChangeNotifierProvider(create: (ctx) => CartManager()),
        ChangeNotifierProvider(create: (ctx) => FavoriteManager()),
        ChangeNotifierProvider(create: (ctx) => ThemeManager()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'Тест приложения',
            theme: ThemeData(
              useMaterial3: true, // ПЕРЕМЕЩАЕМ ВНУТРЬ КОНСТРУКТОРА
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true, // ПЕРЕМЕЩАЕМ ВНУТРЬ КОНСТРУКТОРА
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            themeMode: themeManager.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

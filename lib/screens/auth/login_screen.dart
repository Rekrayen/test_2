import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ДОБАВЬТЕ ЭТОТ ИМПОРТ
import '../../models/user.dart';
import '../profile/user_profile_screen.dart';
import '../profile/seller_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService =
        Provider.of<AuthService>(context, listen: false); // ИЗМЕНИТЕ
    final success = await authService.login(
      // ИЗМЕНИТЕ
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success && authService.currentUser != null) {
      // ИЗМЕНИТЕ
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => authService.currentUser!.isSeller // ИЗМЕНИТЕ
              ? const SellerProfileScreen()
              : const UserProfileScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка входа')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите пароль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Войти'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _emailController.text = 'seller@example.com';
                  _passwordController.text = 'password';
                  _login();
                },
                child: const Text('Быстрый вход как продавец'),
              ),
              TextButton(
                onPressed: () {
                  _emailController.text = 'buyer@example.com';
                  _passwordController.text = 'password';
                  _login();
                },
                child: const Text('Быстрый вход как покупатель'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user.dart';
import '../../services/theme_manager.dart';
import '../auth/login_screen.dart';

class SellerSettingsScreen extends StatefulWidget {
  const SellerSettingsScreen({super.key});

  @override
  State<SellerSettingsScreen> createState() => _SellerSettingsScreenState();
}

class _SellerSettingsScreenState extends State<SellerSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _schoolController;
  late TextEditingController _descriptionController;
  late TextEditingController _websiteController;
  late TextEditingController _socialController;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _schoolController = TextEditingController(text: user?.schoolName ?? '');
    _descriptionController =
        TextEditingController(text: user?.description ?? '');
    _websiteController = TextEditingController(text: user?.website ?? '');
    _socialController = TextEditingController(text: user?.socialMedia ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _schoolController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      if (user != null) {
        final updatedUser = user.copyWith(avatarUrl: pickedFile.path);
        authService.updateUser(updatedUser);
      }
    }
  }

  void _pickBanner() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      if (user != null) {
        final updatedUser = user.copyWith(bannerUrl: pickedFile.path);
        authService.updateUser(updatedUser);
      }
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      if (user != null) {
        final updatedUser = user.copyWith(
          name: _nameController.text,
          phone: _phoneController.text,
          schoolName: _schoolController.text,
          description: _descriptionController.text,
          website: _websiteController.text,
          socialMedia: _socialController.text,
        );
        authService.updateUser(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль сохранен')),
        );
      }
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Смена пароля'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Текущий пароль',
              ),
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Новый пароль',
              ),
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Повторите новый пароль',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Реализовать смену пароля
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Пароль изменен')),
              );
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки продавца'),
      ),
      body: user == null
          ? const Center(child: Text('Пользователь не авторизован'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Баннер и аватарка
                Column(
                  children: [
                    // Баннер
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        image: user.bannerUrl != null
                            ? DecorationImage(
                                image: NetworkImage(user.bannerUrl!),
                                fit: BoxFit.cover,
                              )
                            : const DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.cover,
                              ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    size: 20, color: Colors.white),
                                onPressed: _pickBanner,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Аватарка
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: user.avatarUrl != null
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          child: user.avatarUrl == null
                              ? const Icon(Icons.person,
                                  size: 40, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  size: 20, color: Colors.white),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Форма редактирования профиля
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Личная информация
                      const Text('Личная информация',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Имя и фамилия',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите имя';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Введите email';
                          }
                          if (!value.contains('@')) {
                            return 'Введите корректный email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Телефон',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),

                      // Информация о школе/студии
                      const Text('Информация о школе/студии',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _schoolController,
                        decoration: const InputDecoration(
                          labelText: 'Название школы/студии',
                          prefixIcon: Icon(Icons.business),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Описание',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _websiteController,
                        decoration: const InputDecoration(
                          labelText: 'Веб-сайт',
                          prefixIcon: Icon(Icons.language),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _socialController,
                        decoration: const InputDecoration(
                          labelText: 'Социальные сети',
                          prefixIcon: Icon(Icons.share),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Настройки темы
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Тема приложения',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButton<ThemeMode>(
                          value: themeManager.themeMode,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text('Системная'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text('Светлая'),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text('Темная'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              themeManager.setThemeMode(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Смена пароля
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Сменить пароль'),
                  onTap: _changePassword,
                ),

                // Сохранить профиль
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Сохранить изменения'),
                ),
                const SizedBox(height: 16),

                // Выход
                OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Выйти из аккаунта'),
                ),
              ],
            ),
    );
  }
}

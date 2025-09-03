import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../auth/login_screen.dart';
import 'user_settings_screen.dart'; // Добавьте этот импорт

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              AuthService.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Пользователь не авторизован'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 24),
                _buildStatsSection(),
                const SizedBox(height: 24),
                _buildActionsSection(context),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, size: 40, color: Colors.grey),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(user.email),
            Text(
              'Покупатель',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text('12',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Посещено'),
          ],
        ),
        Column(
          children: [
            Text('5',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('В избранном'),
          ],
        ),
        Column(
          children: [
            Text('3',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Бронировано'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Избранные мастер-классы'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Мои бронирования'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('История посещений'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Настройки'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const UserSettingsScreen()),
            );
          },
        ),
      ],
    );
  }
}

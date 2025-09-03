import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../auth/login_screen.dart';
import 'add_masterclass_screen.dart';
import '../catalog_screen.dart';
import 'seller_settings_screen.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кабинет продавца'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddMasterClassScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              authService.logout();
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
                const SizedBox(height: 24),
                _buildMasterClassesSection(context),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              child: user.avatarUrl == null
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(user.email),
                Text(
                  'Продавец',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text('8',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Мастер-классов'),
          ],
        ),
        Column(
          children: [
            Text('124',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Учеников'),
          ],
        ),
        Column(
          children: [
            Text('4.8',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Рейтинг'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddMasterClassScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Добавить МК'),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.calendar_today),
          label: const Text('Расписание'),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.analytics),
          label: const Text('Статистика'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const SellerSettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings),
          label: const Text('Настройки'),
        ),
      ],
    );
  }

  Widget _buildMasterClassesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Мои мастер-классы',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            title: Text('Итальянская кухня для начинающих'),
            subtitle: Text('2500 ₽ • 12 записей'),
            trailing: Icon(Icons.edit),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text('Масляная живопись для продвинутых'),
            subtitle: Text('5000 ₽ • 8 записей'),
            trailing: Icon(Icons.edit),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CatalogScreen(),
              ),
            );
          },
          child: const Text('Посмотреть все мои мастер-классы'),
        ),
      ],
    );
  }
}

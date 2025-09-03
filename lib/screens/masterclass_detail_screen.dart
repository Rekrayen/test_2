import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/masterclass.dart';
import '../services/cart_manager.dart';
import 'cart_screen.dart';

class MasterClassDetailScreen extends StatelessWidget {
  final MasterClass masterClass;

  const MasterClassDetailScreen({super.key, required this.masterClass});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(locale: 'ru_RU', symbol: '₽');
    final dateFormat = DateFormat('dd MMMM yyyy', 'ru_RU');
    final timeFormat = DateFormat('HH:mm', 'ru_RU');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали мастер-класса'),
        // ИКОНКА КОРЗИНЫ В APP BAR - ДОБАВЛЕНО
        actions: [
          Consumer<CartManager>(
            builder: (context, cart, child) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const CartScreen()),
                    );
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и основная информация
            Text(
              masterClass.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Преподаватель: ${masterClass.instructor}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Изображение (заглушка)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: Icon(
                Icons.school,
                size: 60,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Информация о цене и рейтинге
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  masterClass.isFree
                      ? 'Бесплатно'
                      : priceFormat.format(masterClass.price),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: masterClass.isFree ? Colors.green : Colors.black,
                  ),
                ),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: masterClass.rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                      ignoreGestures: true,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${masterClass.rating} (${masterClass.reviewsCount})',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Детальная информация
            _buildInfoSection('Описание', masterClass.description),
            const SizedBox(height: 16),

            _buildInfoItem(Icons.calendar_today, 'Дата проведения',
                dateFormat.format(masterClass.date)),
            const SizedBox(height: 8),

            _buildInfoItem(Icons.access_time, 'Время',
                timeFormat.format(masterClass.date)),
            const SizedBox(height: 8),

            _buildInfoItem(
                Icons.timer, 'Длительность', '${masterClass.duration} минут'),
            const SizedBox(height: 8),

            _buildInfoItem(Icons.category, 'Категория', masterClass.category),
            const SizedBox(height: 8),

            _buildInfoItem(
                Icons.format_list_bulleted, 'Формат', masterClass.format),
            const SizedBox(height: 8),

            _buildInfoItem(Icons.school, 'Уровень', masterClass.difficulty),
            const SizedBox(height: 8),

            _buildInfoItem(Icons.language, 'Язык', masterClass.language),
            const SizedBox(height: 20),

            // Кнопка записи
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showRegistrationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Записаться на мастер-класс',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // КНОПКА "ДОБАВИТЬ В КОРЗИНУ" - ДОБАВЛЕНО
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<CartManager>(context, listen: false)
                      .addItem(masterClass);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Добавлено в корзину: ${masterClass.title}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Добавить в корзину',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Запись на мастер-класс'),
        content: Text(
            'Вы уверены, что хотите записаться на "${masterClass.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Вы успешно записаны на "${masterClass.title}"!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Записаться'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../services/favorite_manager.dart';
import '../widgets/masterclass_card.dart';
import 'masterclass_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteManager = Provider.of<FavoriteManager>(context);
    final favoriteMasterClasses = dummyMasterClasses.where((masterClass) {
      return favoriteManager.isFavorite(masterClass.id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: favoriteMasterClasses.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'У вас пока нет избранных мастер-классов',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Добавляйте мастер-классы в избранное, чтобы вернуться к ним позже',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteMasterClasses.length,
              itemBuilder: (context, index) {
                final masterClass = favoriteMasterClasses[index];
                return MasterClassCard(
                  masterClass: masterClass,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MasterClassDetailScreen(
                          masterClass: masterClass,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

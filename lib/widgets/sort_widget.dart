import 'package:flutter/material.dart';

enum SortOption { dateAsc, dateDesc, popularity, rating, priceAsc, priceDesc }

class SortWidget extends StatelessWidget {
  final SortOption currentSort;
  final Function(SortOption) onSortChanged;

  const SortWidget({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      icon: const Icon(Icons.sort),
      onSelected: onSortChanged,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
        const PopupMenuItem<SortOption>(
          value: SortOption.dateAsc,
          child: Text('Дата (сначала старые)'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.dateDesc,
          child: Text('Дата (сначала новые)'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.popularity,
          child: Text('Популярность'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.rating,
          child: Text('Рейтинг'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.priceAsc,
          child: Text('Цена (дешевые)'),
        ),
        const PopupMenuItem<SortOption>(
          value: SortOption.priceDesc,
          child: Text('Цена (дорогие)'),
        ),
      ],
    );
  }
}

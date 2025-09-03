import 'package:flutter/material.dart';

enum SortOption { date, price, rating }

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile<SortOption>(
          title: const Text('По дате'),
          value: SortOption.date,
          groupValue: currentSort,
          onChanged: (value) {
            if (value != null) {
              onSortChanged(value);
            }
          },
        ),
        RadioListTile<SortOption>(
          title: const Text('По цене'),
          value: SortOption.price,
          groupValue: currentSort,
          onChanged: (value) {
            if (value != null) {
              onSortChanged(value);
            }
          },
        ),
        RadioListTile<SortOption>(
          title: const Text('По рейтингу'),
          value: SortOption.rating,
          groupValue: currentSort,
          onChanged: (value) {
            if (value != null) {
              onSortChanged(value);
            }
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/masterclass.dart';
import '../data/dummy_data.dart';
import '../widgets/masterclass_card.dart';
import '../widgets/filter_widget.dart';
import '../widgets/sort_widget.dart';
import 'masterclass_detail_screen.dart'; // Добавьте этот импорт

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  CatalogScreenState createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {
  FilterOptions _currentFilters = FilterOptions();
  SortOption _currentSort = SortOption.dateDesc;
  final TextEditingController _searchController = TextEditingController();

  List<MasterClass> get _filteredMasterClasses {
    List<MasterClass> result = dummyMasterClasses.where((masterClass) {
      if (_currentFilters.categories.isNotEmpty &&
          !_currentFilters.categories.contains(masterClass.category)) {
        return false;
      }

      if (_currentFilters.minPrice != null &&
          masterClass.price < _currentFilters.minPrice!) {
        return false;
      }
      if (_currentFilters.maxPrice != null &&
          masterClass.price > _currentFilters.maxPrice!) {
        return false;
      }

      if (_currentFilters.formats.isNotEmpty &&
          !_currentFilters.formats.contains(masterClass.format)) {
        return false;
      }

      if (_currentFilters.minDate != null &&
          masterClass.date.isBefore(_currentFilters.minDate!)) {
        return false;
      }
      if (_currentFilters.maxDate != null &&
          masterClass.date.isAfter(_currentFilters.maxDate!)) {
        return false;
      }

      if (_currentFilters.difficulties.isNotEmpty &&
          !_currentFilters.difficulties.contains(masterClass.difficulty)) {
        return false;
      }

      if (_currentFilters.languages.isNotEmpty &&
          !_currentFilters.languages.contains(masterClass.language)) {
        return false;
      }

      if (masterClass.rating < _currentFilters.minRating) {
        return false;
      }

      if (_searchController.text.isNotEmpty &&
          !masterClass.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) &&
          !masterClass.description
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();

    result.sort((a, b) {
      switch (_currentSort) {
        case SortOption.dateAsc:
          return a.date.compareTo(b.date);
        case SortOption.dateDesc:
          return b.date.compareTo(a.date);
        case SortOption.popularity:
          return b.reviewsCount.compareTo(a.reviewsCount);
        case SortOption.rating:
          return b.rating.compareTo(a.rating);
        case SortOption.priceAsc:
          return a.price.compareTo(b.price);
        case SortOption.priceDesc:
          return b.price.compareTo(a.price);
      }
    });

    return result;
  }

  void _openFilters() async {
    final result = await Navigator.of(context).push<FilterOptions>(
      MaterialPageRoute(
        builder: (context) => FilterWidget(
          initialFilters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _currentFilters = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _filteredMasterClasses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог мастер-классов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilters,
          ),
          SortWidget(
            currentSort: _currentSort,
            onSortChanged: (sort) {
              setState(() {
                _currentSort = sort;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск мастер-классов...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: filteredClasses.isEmpty
                ? const Center(
                    child: Text('Мастер-классы не найдены'),
                  )
                : ListView.builder(
                    itemCount: filteredClasses.length,
                    itemBuilder: (context, index) {
                      final masterClass = filteredClasses[index];
                      return MasterClassCard(
                        masterClass: masterClass,
                        onTap: () {
                          // Переход на страницу мастер-класса
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

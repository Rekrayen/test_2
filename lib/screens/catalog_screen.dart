import 'package:flutter/material.dart';
import '../models/masterclass.dart';
import '../data/dummy_data.dart';
import '../widgets/masterclass_card.dart';
import '../widgets/filter_widget.dart';
import '../widgets/sort_widget.dart';
import 'masterclass_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  CatalogScreenState createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {
  FilterOptions _currentFilters = FilterOptions();
  SortOption _currentSort = SortOption.dateDesc;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _searchSuggestions = [];

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

  void _updateSearchSuggestions(String query) {
    if (query.isEmpty) {
      setState(() => _searchSuggestions = []);
      return;
    }

    final suggestions = dummyMasterClasses
        .where((masterClass) =>
            masterClass.title.toLowerCase().contains(query.toLowerCase()) ||
            masterClass.description.toLowerCase().contains(query.toLowerCase()))
        .map((masterClass) => masterClass.title)
        .toSet() // Убираем дубликаты
        .toList()
        .take(5) // Ограничиваем 5 подсказками
        .toList();

    setState(() => _searchSuggestions = suggestions);
  }

  void _selectSuggestion(String suggestion) {
    _searchController.text = suggestion;
    setState(() => _searchSuggestions = []);
    _searchFocusNode.unfocus();
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

  void _openMasterClassDetail(MasterClass masterClass) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MasterClassDetailScreen(masterClass: masterClass),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _updateSearchSuggestions(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
              setState(() => _currentSort = sort);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Поиск мастер-классов...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchSuggestions = []);
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                if (_searchSuggestions.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _searchSuggestions.map((suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () => _selectSuggestion(suggestion),
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ),
              ],
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
                        onTap: () => _openMasterClassDetail(masterClass),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

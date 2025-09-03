import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../models/masterclass.dart';
import '../widgets/filter_widget.dart';
import '../widgets/masterclass_card.dart';
import '../widgets/sort_widget.dart';
import 'masterclass_detail_screen.dart';
import '../services/cart_manager.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<MasterClass> _filteredMasterClasses = [];
  FilterOptions _filterOptions = FilterOptions();
  SortOption _sortBy = SortOption.date;
  List<String> _searchSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _filteredMasterClasses = dummyMasterClasses;
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions =
          _searchFocusNode.hasFocus && _searchController.text.isNotEmpty;
    });
  }

  void _onSearchChanged() {
    _updateSuggestions();
    _applyFilters();
  }

  void _updateSuggestions() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [
          'Python',
          'Кулинария',
          'Искусство',
          'React',
          'Мария Иванова',
          'Алексей Петров',
          'Иван Сидоров',
          'офлайн',
          'онлайн',
        ];
        _showSuggestions = _searchFocusNode.hasFocus;
      });
      return;
    }

    final suggestions = <String>{};

    for (final masterClass in dummyMasterClasses) {
      if (masterClass.title.toLowerCase().contains(query)) {
        suggestions.add(masterClass.title);
      }
      if (masterClass.instructor.toLowerCase().contains(query)) {
        suggestions.add(masterClass.instructor);
      }
      if (masterClass.category.toLowerCase().contains(query)) {
        suggestions.add(masterClass.category);
      }
      if (masterClass.format.toLowerCase().contains(query)) {
        suggestions.add(masterClass.format);
      }
    }

    setState(() {
      _searchSuggestions = suggestions.toList()..sort();
      _showSuggestions =
          _searchFocusNode.hasFocus && _searchSuggestions.isNotEmpty;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredMasterClasses = dummyMasterClasses.where((masterClass) {
        final searchText = _searchController.text.toLowerCase();
        final matchesSearch =
            searchText.isEmpty ||
            masterClass.title.toLowerCase().contains(searchText) ||
            masterClass.instructor.toLowerCase().contains(searchText) ||
            masterClass.category.toLowerCase().contains(searchText);

        final matchesCategory =
            _filterOptions.categories.isEmpty ||
            _filterOptions.categories.contains(masterClass.category);

        final matchesFormat =
            _filterOptions.formats.isEmpty ||
            _filterOptions.formats.contains(masterClass.format);

        final matchesDifficulty =
            _filterOptions.difficulties.isEmpty ||
            _filterOptions.difficulties.contains(masterClass.difficulty);

        final matchesLanguage =
            _filterOptions.languages.isEmpty ||
            _filterOptions.languages.contains(masterClass.language);

        final matchesPrice =
            (_filterOptions.minPrice == null ||
                masterClass.price >= _filterOptions.minPrice!) &&
            (_filterOptions.maxPrice == null ||
                masterClass.price <= _filterOptions.maxPrice!);

        final matchesRating = masterClass.rating >= _filterOptions.minRating;

        final matchesDate =
            (_filterOptions.minDate == null ||
                masterClass.date.isAfter(
                  _filterOptions.minDate!.subtract(const Duration(days: 1)),
                )) &&
            (_filterOptions.maxDate == null ||
                masterClass.date.isBefore(
                  _filterOptions.maxDate!.add(const Duration(days: 1)),
                ));

        return matchesSearch &&
            matchesCategory &&
            matchesFormat &&
            matchesDifficulty &&
            matchesLanguage &&
            matchesPrice &&
            matchesRating &&
            matchesDate;
      }).toList();

      _sortMasterClasses();
    });
  }

  void _sortMasterClasses() {
    switch (_sortBy) {
      case SortOption.price:
        _filteredMasterClasses.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.rating:
        _filteredMasterClasses.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.date:
        _filteredMasterClasses.sort((a, b) => a.date.compareTo(b.date));
        break;
    }
  }

  void _selectSuggestion(String suggestion) {
    setState(() {
      _searchController.text = suggestion;
      _showSuggestions = false;
      _searchFocusNode.unfocus();
    });
    _applyFilters();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтры'),
        content: FilterWidget(
          initialFilters: _filterOptions,
          onFiltersChanged: (newFilters) {
            setState(() {
              _filterOptions = newFilters;
            });
            _applyFilters();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _filterOptions = FilterOptions();
              });
              _applyFilters();
              Navigator.of(context).pop();
            },
            child: const Text('Сбросить'),
          ),
          ElevatedButton(
            onPressed: () {
              _applyFilters();
              Navigator.of(context).pop();
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сортировка'),
        content: SortWidget(
          currentSort: _sortBy,
          onSortChanged: (newSort) {
            setState(() {
              _sortBy = newSort;
            });
            _applyFilters();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог мастер-классов'),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilters();
                            },
                          )
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      _showSuggestions = true;
                    });
                    _updateSuggestions();
                  },
                ),
                if (_showSuggestions && _searchSuggestions.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(top: 4),
                    child: Column(
                      children: _searchSuggestions.map((suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                          leading: const Icon(Icons.search, size: 20),
                          onTap: () => _selectSuggestion(suggestion),
                          dense: true,
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Фильтры'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: _showSortDialog,
                  icon: const Icon(Icons.sort),
                  label: const Text('Сортировка'),
                ),
              ),
            ],
          ),
          Expanded(
            child: _filteredMasterClasses.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Мастер-классы не найдены',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredMasterClasses.length,
                    itemBuilder: (context, index) {
                      final masterClass = _filteredMasterClasses[index];
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class FilterWidget extends StatefulWidget {
  final FilterOptions initialFilters;
  final Function(FilterOptions) onFiltersChanged;

  const FilterWidget({
    super.key,
    required this.initialFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterWidget> createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  late FilterOptions _currentFilters;

  final List<String> categories = ['кулинария', 'искусство', 'IT'];
  final List<String> formats = ['онлайн', 'офлайн', 'запись'];
  final List<String> difficulties = ['начальный', 'продвинутый'];
  final List<String> languages = ['русский', 'английский'];

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters;
  }

  void _applyFilters() {
    widget.onFiltersChanged(_currentFilters);
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _currentFilters = FilterOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильтры'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFilters,
          ),
          TextButton(
            onPressed: _applyFilters,
            child: const Text('Применить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Категории'),
            Wrap(
              spacing: 8,
              children: categories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: _currentFilters.categories.contains(category),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _currentFilters = _currentFilters.copyWith(
                          categories: [..._currentFilters.categories, category],
                        );
                      } else {
                        _currentFilters = _currentFilters.copyWith(
                          categories: _currentFilters.categories.where((c) => c != category).toList(),
                        );
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Цена'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'От',
                      hintText: '0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final price = double.tryParse(value);
                      if (price != null) {
                        _currentFilters = _currentFilters.copyWith(minPrice: price);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'До',
                      hintText: '10000',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final price = double.tryParse(value);
                      if (price != null) {
                        _currentFilters = _currentFilters.copyWith(maxPrice: price);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Формат'),
            Wrap(
              spacing: 8,
              children: formats.map((format) {
                return FilterChip(
                  label: Text(format),
                  selected: _currentFilters.formats.contains(format),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _currentFilters = _currentFilters.copyWith(
                          formats: [..._currentFilters.formats, format],
                        );
                      } else {
                        _currentFilters = _currentFilters.copyWith(
                          formats: _currentFilters.formats.where((f) => f != format).toList(),
                        );
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Уровень сложности'),
            Wrap(
              spacing: 8,
              children: difficulties.map((difficulty) {
                return FilterChip(
                  label: Text(difficulty),
                  selected: _currentFilters.difficulties.contains(difficulty),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _currentFilters = _currentFilters.copyWith(
                          difficulties: [..._currentFilters.difficulties, difficulty],
                        );
                      } else {
                        _currentFilters = _currentFilters.copyWith(
                          difficulties: _currentFilters.difficulties.where((d) => d != difficulty).toList(),
                        );
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Язык'),
            Wrap(
              spacing: 8,
              children: languages.map((language) {
                return FilterChip(
                  label: Text(language),
                  selected: _currentFilters.languages.contains(language),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _currentFilters = _currentFilters.copyWith(
                          languages: [..._currentFilters.languages, language],
                        );
                      } else {
                        _currentFilters = _currentFilters.copyWith(
                          languages: _currentFilters.languages.where((l) => l != language).toList(),
                        );
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Минимальный рейтинг'),
            Slider(
              value: _currentFilters.minRating,
              min: 0,
              max: 5,
              divisions: 10,
              label: _currentFilters.minRating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _currentFilters = _currentFilters.copyWith(minRating: value);
                });
              },
            ),
            Text('Рейтинг: \+'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

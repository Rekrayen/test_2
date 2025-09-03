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
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late FilterOptions _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = widget.initialFilters.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Категории
            _buildFilterSection(
              'Категории',
              dummyMasterClasses.map((mc) => mc.category).toSet().toList(),
              _currentFilters.categories,
              (category) {
                setState(() {
                  if (_currentFilters.categories.contains(category)) {
                    _currentFilters.categories.remove(category);
                  } else {
                    _currentFilters.categories.add(category);
                  }
                });
                widget.onFiltersChanged(_currentFilters.copyWith());
              },
            ),

            // Форматы
            _buildFilterSection(
              'Форматы',
              dummyMasterClasses.map((mc) => mc.format).toSet().toList(),
              _currentFilters.formats,
              (format) {
                setState(() {
                  if (_currentFilters.formats.contains(format)) {
                    _currentFilters.formats.remove(format);
                  } else {
                    _currentFilters.formats.add(format);
                  }
                });
                widget.onFiltersChanged(_currentFilters.copyWith());
              },
            ),

            // Уровни сложности
            _buildFilterSection(
              'Уровень сложности',
              dummyMasterClasses.map((mc) => mc.difficulty).toSet().toList(),
              _currentFilters.difficulties,
              (difficulty) {
                setState(() {
                  if (_currentFilters.difficulties.contains(difficulty)) {
                    _currentFilters.difficulties.remove(difficulty);
                  } else {
                    _currentFilters.difficulties.add(difficulty);
                  }
                });
                widget.onFiltersChanged(_currentFilters.copyWith());
              },
            ),

            // Языки
            _buildFilterSection(
              'Язык',
              dummyMasterClasses.map((mc) => mc.language).toSet().toList(),
              _currentFilters.languages,
              (language) {
                setState(() {
                  if (_currentFilters.languages.contains(language)) {
                    _currentFilters.languages.remove(language);
                  } else {
                    _currentFilters.languages.add(language);
                  }
                });
                widget.onFiltersChanged(_currentFilters.copyWith());
              },
            ),

            // Цена
            _buildPriceFilter(),

            // Рейтинг
            _buildRatingFilter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    List<String> selectedOptions,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ...options.map((option) => CheckboxListTile(
              title: Text(option),
              value: selectedOptions.contains(option),
              onChanged: (value) => onChanged(option),
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
        const Divider(),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Цена',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Мин. цена',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final newFilters = _currentFilters.copyWith(
                    minPrice: value.isEmpty ? null : double.tryParse(value),
                  );
                  setState(() {
                    _currentFilters = newFilters;
                  });
                  widget.onFiltersChanged(newFilters);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Макс. цена',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final newFilters = _currentFilters.copyWith(
                    maxPrice: value.isEmpty ? null : double.tryParse(value),
                  );
                  setState(() {
                    _currentFilters = newFilters;
                  });
                  widget.onFiltersChanged(newFilters);
                },
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Минимальный рейтинг',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Slider(
          value: _currentFilters.minRating,
          min: 0,
          max: 5,
          divisions: 5,
          label: _currentFilters.minRating.toStringAsFixed(1),
          onChanged: (value) {
            final newFilters = _currentFilters.copyWith(minRating: value);
            setState(() {
              _currentFilters = newFilters;
            });
            widget.onFiltersChanged(newFilters);
          },
        ),
        const Divider(),
      ],
    );
  }
}

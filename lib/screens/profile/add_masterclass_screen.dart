import 'package:flutter/material.dart';
import '../../models/masterclass.dart';
import '../../data/dummy_data.dart';

class AddMasterClassScreen extends StatefulWidget {
  const AddMasterClassScreen({super.key});

  @override
  AddMasterClassScreenState createState() => AddMasterClassScreenState();
}

class AddMasterClassScreenState extends State<AddMasterClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _instructorController = TextEditingController();
  final _durationController = TextEditingController();

  String _selectedCategory = 'кулинария';
  String _selectedFormat = 'офлайн';
  String _selectedDifficulty = 'начальный';
  String _selectedLanguage = 'русский';

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  final double _rating = 4.5;
  final int _reviewsCount = 0;

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final newMasterClass = MasterClass(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      category: _selectedCategory,
      format: _selectedFormat,
      date: _selectedDate,
      difficulty: _selectedDifficulty,
      language: _selectedLanguage,
      rating: _rating,
      reviewsCount: _reviewsCount,
      imageUrl: '',
      instructor: _instructorController.text,
      duration: int.parse(_durationController.text),
    );

    dummyMasterClasses.add(newMasterClass);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Мастер-класс успешно добавлен!')),
    );

    Navigator.of(context).pop();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить мастер-класс')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание*'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите описание';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Цена*'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите цену';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите корректную цену';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _instructorController,
                decoration:
                    const InputDecoration(labelText: 'Имя инструктора*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя инструктора';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration:
                    const InputDecoration(labelText: 'Длительность (мин)*'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите длительность';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Введите корректную длительность';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                items: ['кулинария', 'искусство', 'IT']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: 'Категория'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedFormat,
                items: ['онлайн', 'офлайн', 'запись']
                    .map((format) => DropdownMenuItem(
                          value: format,
                          child: Text(format),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedFormat = value!),
                decoration: const InputDecoration(labelText: 'Формат'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedDifficulty,
                items: ['начальный', 'продвинутый']
                    .map((difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDifficulty = value!),
                decoration:
                    const InputDecoration(labelText: 'Уровень сложности'),
              ),
              DropdownButtonFormField<String>(
                initialValue: _selectedLanguage,
                items: ['русский', 'английский']
                    .map((language) => DropdownMenuItem(
                          value: language,
                          child: Text(language),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedLanguage = value!),
                decoration: const InputDecoration(labelText: 'Язык'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                    'Дата проведения: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Добавить мастер-класс'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

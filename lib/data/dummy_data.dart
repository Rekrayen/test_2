import '../models/masterclass.dart';

final List<MasterClass> dummyMasterClasses = [
  MasterClass(
    id: '1',
    title: 'Итальянская кухня для начинающих',
    description: 'Научитесь готовить пасту и пиццу как в Италии',
    price: 2500,
    category: 'кулинария',
    format: 'офлайн',
    date: DateTime.now().add(const Duration(days: 5)),
    difficulty: 'начальный',
    language: 'русский',
    rating: 4.8,
    reviewsCount: 124,
    imageUrl: '',
    instructor: 'Мария Иванова',
    duration: 120,
  ),
  MasterClass(
    id: '2',
    title: 'Основы программирования на Python',
    description: 'Изучите основы Python с нуля',
    price: 0,
    category: 'IT',
    format: 'онлайн',
    date: DateTime.now().add(const Duration(days: 2)),
    difficulty: 'начальный',
    language: 'русский',
    rating: 4.5,
    reviewsCount: 89,
    imageUrl: '',
    instructor: 'Алексей Петров',
    duration: 180,
  ),
  MasterClass(
    id: '3',
    title: 'Масляная живопись для продвинутых',
    description: 'Продвинутые техники масляной живописи',
    price: 5000,
    category: 'искусство',
    format: 'офлайн',
    date: DateTime.now().add(const Duration(days: 10)),
    difficulty: 'продвинутый',
    language: 'английский',
    rating: 4.9,
    reviewsCount: 67,
    imageUrl: '',
    instructor: 'John Smith',
    duration: 240,
  ),
  MasterClass(
    id: '4',
    title: 'Веб-разработка на React',
    description: 'Создайте современное веб-приложение',
    price: 3000,
    category: 'IT',
    format: 'запись',
    date: DateTime.now().add(const Duration(days: 7)),
    difficulty: 'продвинутый',
    language: 'русский',
    rating: 4.7,
    reviewsCount: 156,
    imageUrl: '',
    instructor: 'Иван Сидоров',
    duration: 210,
  ),
];

class FilterOptions {
  List<String> categories;
  double? minPrice;
  double? maxPrice;
  List<String> formats;
  DateTime? minDate;
  DateTime? maxDate;
  List<String> difficulties;
  List<String> languages;
  double minRating;

  FilterOptions({
    this.categories = const [],
    this.minPrice,
    this.maxPrice,
    this.formats = const [],
    this.minDate,
    this.maxDate,
    this.difficulties = const [],
    this.languages = const [],
    this.minRating = 0,
  });

  FilterOptions copyWith({
    List<String>? categories,
    double? minPrice,
    double? maxPrice,
    List<String>? formats,
    DateTime? minDate,
    DateTime? maxDate,
    List<String>? difficulties,
    List<String>? languages,
    double? minRating,
  }) {
    return FilterOptions(
      categories: categories ?? this.categories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      formats: formats ?? this.formats,
      minDate: minDate ?? this.minDate,
      maxDate: maxDate ?? this.maxDate,
      difficulties: difficulties ?? this.difficulties,
      languages: languages ?? this.languages,
      minRating: minRating ?? this.minRating,
    );
  }
}

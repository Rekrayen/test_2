class MasterClass {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String format;
  final DateTime date;
  final String difficulty;
  final String language;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String instructor;
  final int duration;

  MasterClass({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.format,
    required this.date,
    required this.difficulty,
    required this.language,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.instructor,
    required this.duration,
  });

  bool get isFree => price == 0;
}

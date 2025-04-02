import 'package:suryalita_sales_app/model/ItemPrice.dart';

class Item {
  final String id;
  final String categoryId;
  final String name;
  final String image;
  final String? description; // Ubah menjadi nullable
  final List<ItemPrice>? prices; // Nullable untuk kasus kosong

  Item({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.image,
    this.description,
    this.prices,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      image: json['image'] ?? '', // Nilai default jika null
      description: json['description'], // Bisa null
      prices: (json['prices'] as List?)?.map((price) => ItemPrice.fromJson(price)).toList(),
    );
  }
}

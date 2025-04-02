import 'package:suryalita_sales_app/Components/helper/helper.dart';

class ItemPrice {
  final String id;
  final String unit;
  final int price;
  final String description;

  ItemPrice({
    required this.id,
    required this.unit,
    required this.price,
    required this.description,
  });

  // Factory method untuk parsing dari JSON
  factory ItemPrice.fromJson(Map<String, dynamic> json) {
    return ItemPrice(
      id: json['id'],
      unit: json['unit'],
      price: parseToInt(json['price']),
      description: json['description'],
    );
  }

  // Konversi ke JSON (jika diperlukan)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit': unit,
      'price': price,
      'description': description,
    };
  }
}

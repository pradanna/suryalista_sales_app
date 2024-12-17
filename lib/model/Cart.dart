import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/model/Item.dart';

class Cart {
  final String id;
  final String? transactionId;
  final String itemId;
  final String unit;
  final RxInt qty;
  final int price;
  final int total;
  final Item? item;

  Cart({
    required this.id,
    this.transactionId,
    required this.itemId,
    required this.unit,
    required this.qty,
    required this.price,
    required this.total,
    this.item,
  });

  // Parsing dari JSON atau Map
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      transactionId: json['transaction_id'],
      itemId: json['item_id'],
      unit: json['unit'],
      qty: RxInt(json['qty']),
      price: json['price'],
      total: json['total'],
      item: json['item'] != null ? Item.fromJson(json['item']) : null,
    );
  }

  // Konversi ke JSON atau Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'item_id': itemId,
      'unit': unit,
      'qty': qty.value,
      'price': price,
      'total': total,
    };
  }

  // Method untuk membuat objek Cart dari map
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: dynamicToString(map['id']),
      itemId: map['item_id'],
      qty: (map['qty'] as int).obs,
      price: map['price'],
      total: map['total'],
      unit: map['unit'],
    );
  }

  // Method untuk mengonversi objek Cart ke map
  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'qty': qty.value,
      'price': price,
      'total': total,
      'unit': unit,
    };
  }
}

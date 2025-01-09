import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/model/Item.dart';
import 'package:suryalita_sales_app/model/Customer.dart';

class Cart {
  final String id;
  final String? transactionId;
  final String? userId;           // Menambahkan user_id
  final String? customerId;        // Menambahkan customer_id
  final String itemId;
  final String unit;
  final RxInt qty;
  final RxInt request_qty;
  final int price;
  final int total;
  final String status;            // Menambahkan status
  final Item? item;
  final Customer? customer;
  final String? image; // Menambahkan relasi customer
  final String? itemName; // Menambahkan relasi customer

  Cart({
    required this.id,
    this.transactionId,
    this.userId,
    required this.itemId,
    required this.unit,
    required this.qty,
    required this.request_qty,
    required this.price,
    required this.total,
    required this.status,
    this.customerId,
    this.item,
    this.customer,
    this.image,
    this.itemName,
  });

  // Parsing dari JSON atau Map
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      transactionId: json['transaction_id'],
      userId: json['user_id'],           // Parsing user_id
      customerId: json['customer_id'],   // Parsing customer_id
      itemId: json['item_id'],
      unit: json['unit'],
      qty: RxInt(json['qty']),
      request_qty: RxInt(json['request_qty']),
      price: json['price'],
      total: json['total'],
      status: json['status'] ?? 'pending', // Default ke 'pending' jika tidak ada
      item: json['item'] != null ? Item.fromJson(json['item']) : null,
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      image: json['image'],
      itemName: json['itemName'],
    );
  }

  // Konversi ke JSON atau Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'user_id': userId,                // Menambahkan user_id ke JSON
      'customer_id': customerId,        // Menambahkan customer_id ke JSON
      'item_id': itemId,
      'unit': unit,
      'qty': qty.value,
      'request_qty': request_qty.value,
      'price': price,
      'total': total,
      'status': status,
      'image': image,
      'itemName': itemName,
    };
  }

  // Method untuk membuat objek Cart dari map
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: dynamicToString(map['id']),
      transactionId: map['transaction_id'],    // Menambahkan transaction_id
      userId: map['user_id'],                   // Menambahkan user_id
      customerId: map['customer_id'],           // Menambahkan customer_id
      itemId: map['item_id'],
      qty: (map['qty'] as int).obs,
      request_qty: (map['request_qty'] as int).obs,
      price: map['price'],
      total: map['total'],
      unit: map['unit'],
      status: map['status'] ?? 'pending',      // Default ke 'pending'
      image: map['image'],      // Default ke 'pending'
      itemName: map['item_name'],      // Default ke 'pending'
    );
  }

  // Method untuk mengonversi objek Cart ke map
  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transactionId,      // Menambahkan transaction_id
      'user_id': userId,                     // Menambahkan user_id
      'customer_id': customerId,             // Menambahkan customer_id
      'item_id': itemId,
      'qty': qty.value,
      'request_qty': request_qty.value,
      'price': price,
      'total': total,
      'unit': unit,
      'status': status,                      // Menambahkan status
      'image': image,                      // Menambahkan status
      'itemName': itemName,                      // Menambahkan status
    };
  }
}

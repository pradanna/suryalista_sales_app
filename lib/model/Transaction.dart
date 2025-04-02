import 'package:suryalita_sales_app/model/Cart.dart';
import 'package:suryalita_sales_app/model/Customer.dart';

class Transaction {
  final String id;
  final String referenceNumber;
  final String customerId;
  final String? customerName;  // Nullable jika tidak ada nama customer
  final int total;
  final String date;
  final String status;         // Menambahkan status
  final String? userId;       // Menambahkan userId untuk relasi user
  final List<Cart>? carts;
  final Customer? customer;   // Menambahkan relasi dengan Customer

  Transaction({
    required this.id,
    required this.referenceNumber,
    required this.customerId,
    this.customerName,
    required this.total,
    required this.date,
    required this.status,      // Status ditambahkan
    this.userId,
    this.carts,
    this.customer,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      referenceNumber: json['reference_number'] ?? '',
      customerId: json['customer_id'] ?? '',
      customerName: json['customer']?['name'],  // Nama customer dari relasi customer
      total: json['total'] ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? 'pending',  // Default status 'pending'
      userId: json['user_id'],             // Menambahkan user_id
      carts: (json['carts'] as List?)?.map((cart) => Cart.fromJson(cart)).toList() ?? [],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null, // Relasi dengan Customer
    );
  }
}

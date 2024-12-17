import 'package:suryalita_sales_app/model/Cart.dart';

class Transaction {
  final String id;
  final String referenceNumber;
  final String customerId;
  final String? customerName; // Nullable jika tidak ada nama customer
  final int total;
  final String date;
  final List<Cart>? carts;

  Transaction({
    required this.id,
    required this.referenceNumber,
    required this.customerId,
    this.customerName,
    required this.total,
    required this.date,
    this.carts,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      referenceNumber: json['reference_number'] ?? '',
      customerId: json['customer_id'] ?? '',
      customerName: json['customer']?['name'],
      // Gunakan tanda tanya untuk menghindari null
      total: json['total'] ?? 0,
      date: json['date'] ?? '',
      carts: (json['carts'] as List?)
              ?.map((cart) => Cart.fromJson(cart))
              .toList() ??
          [],
    );
  }
}

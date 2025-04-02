class Customer {
  final String id;
  final String type;
  final String name;
  final String phone;
  final String address;
  final int point;

  Customer({
    required this.id,
    required this.type,
    required this.name,
    required this.phone,
    required this.address,
    required this.point,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      point: json['point'],
    );
  }
}

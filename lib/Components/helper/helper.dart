import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final marginHorizontal = 16.w;

Future<String> getToken() async {
  final GetStorage box = GetStorage();
  String token = await box.read('token_litasurya') ?? '';
  return token;
}

int calculatePercentage(int total, int target) {
  if (target == 0) {
    return 0; // Menghindari pembagian dengan nol
  }
  return ((total / target) * 100).round(); // Membulatkan ke angka terdekat
}

String formatRupiahNumber(num number) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatCurrency.format(number);
}

String formatRupiahInt(int number) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatCurrency.format(number);
}

String getOrderStatusTextSwitch(int status, int paymentStatusText) {
  String statusText;

  switch (status) {
    case 0:
      statusText = 'Menunggu Pembayaran';
    case 1:
      statusText = 'Menunggu Pembayaran';
    case 2:
      statusText = 'Pesanan Sedang Dikirim';
    case 3:
      statusText = 'Selesai';
    case 6:
      statusText = 'Batal';
    default:
      statusText = 'Status Tidak Diketahui';
  }

  if (paymentStatusText == 1 && status == 1) {
    statusText = 'Pesanan Sedang Diproses';
  }
  return statusText;
}

Color getOrderStatusColor(int status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.blue;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.green;
    case 6:
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String formatDate(DateTime date) {
  return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String convertDateTime(String dateTime) {
  final DateTime parsedDateTime = DateTime.parse(dateTime);

  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

  return formatter.format(parsedDateTime);
}

String formatDatedMMMMYYYY(date) {
  // Mengubah string menjadi DateTime
  DateTime parsedDate = DateTime.parse(date);

  // Mendapatkan tanggal hari ini
  DateTime today = DateTime.now();

  // Memeriksa apakah tanggal yang diberikan adalah hari ini
  if (parsedDate.year == today.year &&
      parsedDate.month == today.month &&
      parsedDate.day == today.day) {
    return "Hari ini";
  } else {
    // Memformat tanggal menjadi "25 December 2024"
    return DateFormat('d MMMM yyyy').format(parsedDate);
  }
}

String formatDateTime(String date) {
  final DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateTime a = format.parse(date);
  String dateConvert = DateFormat('dd MMM yyyy, HH:mm').format(a);
  return dateConvert;
}

String formatDateTime2(String dateTimeString,
    {String format = "dd MMM yyyy, HH:mm"}) {
  try {
    final DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    final DateFormat formatter = DateFormat(format);
    return formatter.format(dateTime);
  } catch (e) {
    print("Error formatting date: $e");
    return dateTimeString; // Fallback to the original string
  }
}

int parseToInt(dynamic value) {
  return value is int ? value : int.tryParse(value.toString()) ?? 0;
}

String dynamicToString(dynamic value) {
  return value?.toString() ?? "-";
}

String generateUuid() {
  final Uuid _uuid = Uuid();
  return _uuid.v4();
}

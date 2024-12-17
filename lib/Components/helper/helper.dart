import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      statusText =  'Menunggu Pembayaran';
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

 if(paymentStatusText == 1 && status == 1){
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

String formatDateTime(String date) {
  final DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateTime a =  format.parse(date);
 String dateConvert = DateFormat('dd MMM yyyy, HH:mm').format(a);
  return dateConvert;
}

int parseToInt(dynamic value) {
  return value is int ? value : int.tryParse(value.toString()) ?? 0;
}

String dynamicToString(dynamic value) {
  return value?.toString() ?? "-";
}




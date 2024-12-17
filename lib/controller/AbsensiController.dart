import 'package:get/get.dart';

class AbsensiController extends GetxController {
  // Variabel untuk menyimpan informasi toko yang akan ditampilkan di halaman absensi
  var storeName = ''.obs;
  var storeAddress = ''.obs;
  var storePhone = ''.obs;

  // Fungsi ini akan dipanggil setelah berhasil scan QR untuk mengupdate data toko
  void updateStoreInfo(String name, String address, String phone) {
    storeName.value = name;
    storeAddress.value = address;
    storePhone.value = phone;
  }

  // Fungsi untuk konfirmasi absensi (Anda bisa tambahkan logika lain di sini)
  void confirmAbsensi() {
    // Logika untuk konfirmasi absensi, bisa berupa API call atau penyimpanan lokal
    Get.snackbar("Konfirmasi", "Absensi di toko ${storeName.value} berhasil!");
  }
}

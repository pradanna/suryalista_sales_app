import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JadwalKunjunganWidget extends StatelessWidget {
  final List<Map<String, dynamic>> kunjunganHariIni = [
    {
      'namaToko': 'Toko Sinar Jaya',
      'alamat': 'Jl. Merdeka No. 10, Jakarta',
      'image': 'assets/images/icontoko.png',
      'status': 'Dikunjungi',
    },
    {
      'namaToko': 'Toko Amanah',
      'alamat': 'Jl. Veteran No. 7, Bandung',
      'image': 'assets/images/icontoko.png',
      'status': 'Belum Dikunjungi',
    },
    {
      'namaToko': 'Toko Sejahtera',
      'alamat': 'Jl. Kemerdekaan No. 5, Surabaya',
      'image': 'assets/images/icontoko.png',
      'status': 'Dikunjungi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ScreenUtil

    return Padding(
      padding: EdgeInsets.all(10.w),  // Padding umum
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul "Jadwal Kunjungan Hari Ini"
          Text(
            'Jadwal Kunjungan Hari Ini',
            style: TextStyle(
              fontSize: 14.sp,  // Ukuran teks responsif
              fontWeight: FontWeight.bold,
            ),
          ),  // Penutup Text Judul
          SizedBox(height: 12.h),  // Jarak setelah judul
          // Daftar kunjungan menggunakan Column agar fleksibel
          Column(
            children: kunjunganHariIni.map((kunjungan) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Card(
                  elevation: 2,  // Shadow tipis
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),  // Radius sudut
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),  // Padding dalam card
                    child: Row(
                      children: [
                        // Icon atau gambar toko di sebelah kiri
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(kunjungan['image']!),  // Gambar toko
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),  // Penutup Container Gambar
                        SizedBox(width: 12.w),  // Jarak antara gambar dan konten teks
                        // Konten teks (Nama Toko dan Alamat)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Toko
                              Text(
                                kunjungan['namaToko']!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),  // Penutup Text Nama Toko
                              // Alamat Toko
                              Text(
                                kunjungan['alamat']!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[700],  // Warna teks abu-abu
                                ),
                              ),  // Penutup Text Alamat
                              SizedBox(height: 5.h,),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kunjungan['status'] == 'Dikunjungi'
                                        ? Colors.green
                                        : Colors.red,  // Warna berdasarkan status
                                    borderRadius: BorderRadius.circular(20.r),  // Radius pill
                                  ),
                                  child: Text(
                                    kunjungan['status']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),  // Penutup Text Status
                                ),  // Penutup Container Status
                              ),  // Penutup Align

                            ],  // Penutup Column Children
                          ),  // Penutup Column
                        ),  // Penutup Expanded
                        // Status kunjungan di pojok kanan bawah
                      ],  // Penutup Row Children
                    ),  // Penutup Padding Row
                  ),  // Penutup Padding
                ),  // Penutup Card
              );  // Penutup Padding
            }).toList(),  // Penutup Map
          ),  // Penutup Column
        ],  // Penutup Column Children
      ),  // Penutup Padding Column
    );  // Penutup Padding
  }
}

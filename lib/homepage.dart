import 'package:flutter/material.dart';
import 'detailpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Saldo Kas Awal Warung Madura
  int saldoKas = 0;

  // Fungsi callback untuk mengurangi kas ketika transaksi berhasil
  void kurangiKas(int jumlah) {
    setState(() {
      saldoKas -= jumlah;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warung Madura 24 Jam'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Informasi Saldo Kas Warung
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'PEMASUKKAN WARUNG MADURA',
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${saldoKas.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pilih Layanan Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Grid Menu Transaksi
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMenuItem(
                  context,
                  title: 'Sembako',
                  imageUrl: 'https://cdn-icons-png.flaticon.com/512/3082/3082011.png',
                  type: 'sembako',
                ),
                _buildMenuItem(
                  context,
                  title: 'TopUp & Pulsa',
                  imageUrl: 'https://cdn-icons-png.flaticon.com/512/3659/3659899.png',
                  type: 'topup',
                ),
                _buildMenuItem(
                  context,
                  title: 'Transfer Uang',
                  imageUrl: 'https://cdn-icons-png.flaticon.com/512/2845/2845944.png',
                  type: 'transfer',
                ),
                _buildMenuItem(
                  context,
                  title: 'Bensin Eceran',
                  imageUrl: 'https://cdn-icons-png.flaticon.com/512/2933/2933886.png',
                  type: 'bensin',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Membuat Kartu Menu
  Widget _buildMenuItem(BuildContext context, {required String title, required String imageUrl, required String type}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: title,
              type: type,
              saldoKas: saldoKas,
              onTransaksiBerhasil: kurangiKas,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 64, height: 64, fit: BoxFit.contain),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
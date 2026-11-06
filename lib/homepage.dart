// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'detailpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Saldo kas awal warung
  double _saldoKas = 500;

  // Fungsi untuk memperbarui saldo kas (bisa bertambah atau berkurang)
  void _updateSaldo(double nominal, bool isPenambahan) {
    setState(() {
      if (isPenambahan) {
        _saldoKas += nominal;
      } else {
        _saldoKas -= nominal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WARUNG MADURA IMAN',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red.shade800,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Informasi Kas / Saldo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Buka Setiap Hari 24 Jam Kecuali Hari Kiamat', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text('Pemasukan dan Pengeluaran Warung Muda Iman', style: TextStyle(color: Colors.white, fontSize: 14)),
                  Text(
                    'Rp ${_saldoKas.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Layanan Utama',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Grid Menu Layanan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuItem(context, 'Sembako', Icons.shopping_basket, Colors.orange),
                _buildMenuItem(context, 'Topup & Pulsa', Icons.phone_android, Colors.blue),
                _buildMenuItem(context, 'Transfer', Icons.account_balance_wallet, Colors.green),
                _buildMenuItem(context, 'Bensin', Icons.local_gas_station, Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // Banner Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Dapatkan promo menarik setiap hari! Jangan lewatkan kesempatan untuk berbelanja dengan harga terbaik di Warung Madura Iman.', style: TextStyle(color: Colors.orange, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () async {
        // Navigasi ke halaman detail dan menunggu hasil callback untuk update kas
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(title: title, themeColor: color),
          ),
        );

        // Jika ada data transaksi yang dikembalikan, update saldo kas
        if (result != null && result is Map<String, dynamic>) {
          double nominal = result['nominal'];
          bool isPenambahan = result['isPenambahan'];
          _updateSaldo(nominal, isPenambahan);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
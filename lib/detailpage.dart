import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String type;
  final int saldoKas;
  final Function(int) onTransaksiBerhasil;

  const DetailPage({
    super.key,
    required this.title,
    required this.type,
    required this.saldoKas,
    required this.onTransaksiBerhasil,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _noTujuanController = TextEditingController();

  // Data Sembako (Nama & Harga)
  final List<Map<String, dynamic>> listSembako = [
    {'nama': 'Beras 5 kg', 'harga': 75000},
    {'nama': 'Minyak Goreng 1L', 'harga': 10000},
    {'nama': 'Gula Pasir 1 kg', 'harga': 5000},
    {'nama': 'Telur Ayam 1 kg', 'harga': 28000},
    {'nama': 'Mie Instan 1 Kardus', 'harga': 45000},
  ];

  void _prosesTransaksi(int nominal, String deskripsi) {
    if (nominal > widget.saldoKas) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi gagal: Saldo Kas Warung tidak mencukupi!')),
      );
      return;
    }

    widget.onTransaksiBerhasil(nominal);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Berhasil: $deskripsi sebesar Rp $nominal dimasukkan/dikurangi dari Kas.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (widget.type) {
      // 1. Tampilan Sembako
      case 'sembako':
        return ListView.builder(
          itemCount: listSembako.length,
          itemBuilder: (context, index) {
            final item = listSembako[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.shopping_bag, color: Colors.redAccent),
                title: Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Rp ${item['harga']}'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () => _prosesTransaksi(item['harga'], 'Beli ${item['nama']}'),
                  child: const Text('Beli', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        );

      // 2. Tampilan TopUp & Pulsa
      case 'topup':
        return Column(
          children: [
            TextField(
              controller: _noTujuanController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Nomor HP / ID Game', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nominal TopUp/Pulsa (Rp)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size.fromHeight(48)),
              onPressed: () {
                int? nominal = int.tryParse(_inputController.text);
                if (nominal != null && nominal > 0) {
                  _prosesTransaksi(nominal, 'Topup/Pulsa ke ${_noTujuanController.text}');
                }
              },
              child: const Text('Proses TopUp', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        );

      // 3. Tampilan Transfer (Maksimal Rp 1.000.000)
      case 'transfer':
        return Column(
          children: [
            TextField(
              controller: _noTujuanController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Nomor Rekening Tujuan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Transfer (Maks Rp 1.000.000)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size.fromHeight(48)),
              onPressed: () {
                int? nominal = int.tryParse(_inputController.text);
                if (nominal == null || nominal <= 0) return;
                
                if (nominal > 1000000) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Batas maksimal transfer adalah Rp 1.000.000!')),
                  );
                } else {
                  _prosesTransaksi(nominal, 'Transfer ke ${_noTujuanController.text}');
                }
              },
              child: const Text('Kirim Uang', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        );

      // 4. Tampilan Bensin (Pertalite Rp 11.000 & Pertamax Rp 17.000)
      case 'bensin':
        return Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_gas_station, color: Colors.green),
                title: const Text('Pertalite'),
                subtitle: const Text('Rp 11.000 / Liter'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => _prosesTransaksi(11000, 'Beli Pertalite 1 Liter'),
                  child: const Text('Beli 1L', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_gas_station, color: Colors.blue),
                title: const Text('Pertamax'),
                subtitle: const Text('Rp 17.000 / Liter'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => _prosesTransaksi(17000, 'Beli Pertamax 1 Liter'),
                  child: const Text('Beli 1L', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        );

      default:
        return const Center(child: Text('Layanan tidak ditemukan'));
    }
  }
}
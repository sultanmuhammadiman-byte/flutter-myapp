import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final Color themeColor;

  const DetailPage({
    super.key,
    required this.title,
    required this.themeColor,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // 1. Sembako Data
  final List<Map<String, dynamic>> _listSembako = [
    {'nama': 'Beras Premium (5 kg)', 'harga': 75000},
    {'nama': 'Minyak Goreng (1 Liter)', 'harga': 7000},
    {'nama': 'Gula Pasir (1 kg)', 'harga': 10000},
    {'nama': 'Telur Ayam (1 kg)', 'harga': 24500},
    {'nama': 'Mi Instan (1 Dus)', 'harga': 15000},
  ];
  String? _selectedSembako;
  double _hargaSembako = 0;

  // 2. Transfer Data
  final TextEditingController _noRekController = TextEditingController();
  final TextEditingController _nominalTransferController = TextEditingController();
  String _selectedBank = 'BCA';
  final List<String> _listBank = ['BCA', 'Mandiri', 'BRI', 'BNI', 'DANA', 'OVO', 'GoPay'];

  // 3. Bensin Data
  String _selectedBensin = 'Pertalite';
  final double _hargaPertalite = 11000;
  final double _hargaPertamax = 17000;
  int _literBensin = 1;

  // 4. Topup & Pulsa Data
  final TextEditingController _nomorHpController = TextEditingController();
  int _selectedPulsa = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu ${widget.title}', style: const TextStyle(color: Colors.white)),
        backgroundColor: widget.themeColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Konten dinamis berdasarkan jenis menu yang dipilih
            if (widget.title == 'Sembako') _buildSembakoSection(),
            if (widget.title == 'Transfer') _buildTransferSection(),
            if (widget.title == 'Bensin') _buildBensinSection(),
            if (widget.title == 'Topup & Pulsa') _buildTopupSection(),
          ],
        ),
      ),
    );
  }

  // --- TAMPILAN SEMBAKO ---
  Widget _buildSembakoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pilih Barang Sembako:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedSembako,
          decoration: const InputDecoration(border: OutlineInputBorder(), filled: true),
          hint: const Text('-- Pilih Sembako --'),
          items: _listSembako.map((item) {
            return DropdownMenuItem<String>(
              value: item['nama'].toString(),
              child: Text('${item['nama']} (Rp ${item['harga']})'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSembako = value;
              final selectedItem = _listSembako.firstWhere((element) => element['nama'] == value);
              _hargaSembako = (selectedItem['harga'] as int).toDouble();
            });
          },
        ),
        const SizedBox(height: 20),
        if (_selectedSembako != null)
          Text('Harga Satuan: Rp $_hargaSembako', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.themeColor, minimumSize: const Size(double.infinity, 50)),
          onPressed: _selectedSembako == null
              ? null
              : () {
                  // Sembako dibeli = Stok keluar / Kas bertambah karena pembeli bayar ke warung
                  Navigator.pop(context, {
                    'nominal': _hargaSembako,
                    'isPenambahan': true,
                    'message': 'Penjualan $_selectedSembako berhasil! Kas bertambah.'
                  });
                },
          child: const Text('Beli Sembako (Bayar)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // --- TAMPILAN TRANSFER ---
  Widget _buildTransferSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Layanan Transfer Tunai & E-Wallet (Maks. Rp 1.000.000)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _selectedBank,
          decoration: const InputDecoration(labelText: 'Tujuan Bank / E-Wallet', border: OutlineInputBorder()),
          items: _listBank.map((bank) => DropdownMenuItem(value: bank, child: Text(bank))).toList(),
          onChanged: (val) => setState(() => _selectedBank = val!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _noRekController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nomor Rekening / Nomor Tujuan', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nominalTransferController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nominal Transfer (Maks 1.000.000)', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.themeColor, minimumSize: const Size(double.infinity, 50)),
          onPressed: () {
            double nominal = double.tryParse(_nominalTransferController.text) ?? 0;
            if (nominal <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nominal dengan benar!')));
              return;
            }
            if (nominal > 1000000) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Batas maksimal transfer adalah Rp 1.000.000!')));
              return;
            }
            // Transfer uang: Pelanggan setor tunai ke warung, kas warung BERTAMBAH sejumlah uang transfer
            Navigator.pop(context, {
              'nominal': nominal,
              'isPenambahan': true,
              'message': 'Transfer ke $_selectedBank sebesar Rp $nominal berhasil diproses!'
            });
          },
          child: const Text('Proses Transfer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // --- TAMPILAN BENSIN ---
  Widget _buildBensinSection() {
    double totalBensin = (_selectedBensin == 'Pertalite' ? _hargaPertalite : _hargaPertamax) * _literBensin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pilih Jenis Bahan Bakar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedBensin,
          decoration: const InputDecoration(border: OutlineInputBorder(), filled: true),
          items: const [
            DropdownMenuItem(value: 'Pertalite', child: Text('Pertalite (Rp 11.000 / Liter)')),
            DropdownMenuItem(value: 'Pertamax', child: Text('Pertamax (Rp 17.000 / Liter)')),
          ],
          onChanged: (val) => setState(() => _selectedBensin = val!),
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Jumlah Liter', border: OutlineInputBorder()),
          onChanged: (val) {
            setState(() {
              _literBensin = int.tryParse(val) ?? 1;
            });
          },
        ),
        const SizedBox(height: 16),
        Text('Total Bayar: Rp $totalBensin', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.themeColor, minimumSize: const Size(double.infinity, 50)),
          onPressed: () {
            // Jual bensin = kas bertambah
            Navigator.pop(context, {
              'nominal': totalBensin,
              'isPenambahan': true,
              'message': 'Penjualan $_selectedBensin $_literBensin Liter berhasil!'
            });
          },
          child: const Text('Jual Bensin Eceran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // --- TAMPILAN TOPUP & PULSA ---
  Widget _buildTopupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Isi Ulang Pulsa / Paket Data / Game:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        TextField(
          controller: _nomorHpController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Nomor HP / ID Tujuan', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: _selectedPulsa,
          decoration: const InputDecoration(labelText: 'Nominal Voucher', border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 10000, child: Text('Rp 10.000')),
            DropdownMenuItem(value: 20000, child: Text('Rp 20.000')),
            DropdownMenuItem(value: 50000, child: Text('Rp 50.000')),
            DropdownMenuItem(value: 100000, child: Text('Rp 100.000')),
          ],
          onChanged: (val) => setState(() => _selectedPulsa = val!),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.themeColor, minimumSize: const Size(double.infinity, 50)),
          onPressed: () {
            Navigator.pop(context, {
              'nominal': _selectedPulsa.toDouble(),
              'isPenambahan': true,
              'message': 'Top-up senilai Rp $_selectedPulsa berhasil diproses!'
            });
          },
          child: const Text('Proses Top-up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
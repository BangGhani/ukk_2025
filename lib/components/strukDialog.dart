import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StrukDialog extends StatelessWidget {
  final Map<String, dynamic>? selectedPelanggan;
  final List<Map<String, dynamic>> listPesanan;
  final int totalPesanan;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const StrukDialog({
    super.key,
    required this.selectedPelanggan,
    required this.listPesanan,
    required this.totalPesanan,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final currentDate = dateFormat.format(DateTime.now());

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Struk
            const Center(
              child: Text(
                'STRUK TRANSAKSI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('Tanggal: $currentDate'),
            Text('Pelanggan: ${selectedPelanggan?['namaPelanggan'] ?? 'Tanpa Pelanggan'}'),
            const Divider(thickness: 2),
            
            // Daftar Produk
            const Text(
              'Daftar Pesanan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listPesanan.length,
                itemBuilder: (context, index) {
                  final item = listPesanan[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['namaProduk']} (x${item['total']})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,###').format(item['harga'] * item['total'])}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Total
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp ${NumberFormat('#,###').format(totalPesanan)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      side: BorderSide(color: Colors.red.shade300),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                    ),
                    child: const Text(
                      'Konfirmasi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
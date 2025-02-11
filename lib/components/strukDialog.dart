import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/themes.dart';

class StrukDialog extends StatelessWidget {
  final String? selectedPelanggan;
  final String? date;
  final List<Map<String, dynamic>> cartItems;
  final int totalPesanan;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final bool showButton;

  const StrukDialog({
    super.key,
    required this.date,
    required this.selectedPelanggan,
    required this.cartItems,
    required this.totalPesanan,
    required this.onCancel,
    required this.onConfirm,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ThemeColor.putih,
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
            Text('Tanggal: $date'),
            Text(
              'Pelanggan: $selectedPelanggan',
            ),
            const Divider(thickness: 2),

            // Daftar Produk
            const Text(
              'Daftar Pesanan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Gunakan SizedBox dengan tinggi tertentu agar ListView memiliki batas tinggi
            SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['namaproduk']} (x${item['total']})',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,##0', 'id').format(item['harga'] * item['total'])}',
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
                  'Rp ${NumberFormat('#,##0', 'id').format(totalPesanan)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tombol Aksi
            if (showButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: ThemeColor.background,
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
                        backgroundColor: ThemeColor.hijau,
                      ),
                      child: const Text(
                        'Konfirmasi',
                        style: TextStyle(color: ThemeColor.putih),
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

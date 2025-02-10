import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukk_2025/components/themes.dart';

class StrukDialog extends StatelessWidget {
  final int totalItem;
  final String totalPrice;
  final String customer;
  final String tanggalPenjualan;

  const StrukDialog({
    Key? key,
    required this.totalItem,
    required this.totalPrice,
    required this.customer,
    required this.tanggalPenjualan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.parse(tanggalPenjualan);
    final String formattedDate = DateFormat('HH.mm, d MMMM yyyy', 'id_ID').format(date);

    return AlertDialog(
      backgroundColor: ThemeColor.putih,
      title: Text(
        "Struk Transaksi",
        style: TextStyle(
          color: ThemeColor.hijau,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tanggal:"),
              Text(formattedDate),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pelanggan:"),
              Text(customer),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total barang:"),
              Text(totalItem.toString()),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Harga:"),
              Text(totalPrice),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            "Batal",
            style: TextStyle(color: ThemeColor.hijau),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeColor.hijau,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Ya"),
        ),
      ],
    );
  }
}

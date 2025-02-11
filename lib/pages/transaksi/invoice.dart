// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:intl/intl.dart';
import '../../components/themes.dart';
import '../../components/list.dart'; // Pastikan CustomList tersedia di sini
import '../../logic/controller.dart';
import '../../components/strukDialog.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  final TransaksiController transaksiController = TransaksiController();
  late Future<List<dynamic>> listPenjualan;

  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    listPenjualan = transaksiController.fetchPenjualan();
  }

  void refreshInvoice() {
    setState(() {
      listPenjualan = transaksiController.fetchPenjualan();
    });
  }

  void searchInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeColor.background,
        content: AwesomeSnackbarContent(
          title: 'Info',
          message: 'Fungsi search belum diimplementasikan.',
          contentType: ContentType.warning,
        ),
      ),
    );
  }

  void showInvoice(Map<String, dynamic> penjualan) async {
    final penjualanID = penjualan['penjualanID'];
    try {
      final detailResponse =
          await transaksiController.fetchDetailPenjualan(penjualanID);
      cartItems = detailResponse.map<Map<String, dynamic>>((item) {
        final produk = item['produk'] as Map<String, dynamic>? ?? {};
        return {
          'namaproduk': produk['namaproduk'] ?? '',
          'harga': produk['harga'] ?? 0,
          'total': item['jumlahproduk'] ?? 0,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching detail penjualan: $e');
      cartItems = [];
    }

    final tanggalPenjualan = penjualan['tanggalpenjualan'];
    final formattedDate = tanggalPenjualan != null
        ? DateFormat('dd MMMM yyyy', 'id')
            .format(DateTime.parse(tanggalPenjualan.toString()))
        : '';

    String customerName =
        penjualan['pelanggan']['namapelanggan']?.toString() ?? 'Non Member';

    final totalHarga = penjualan['totalharga'] ?? 0;

    showDialog(
      context: context,
      builder: (context) => StrukDialog(
        date: formattedDate,
        selectedPelanggan: customerName,
        cartItems: cartItems,
        totalPesanan: totalHarga,
        onCancel: () => Navigator.pop(context),
        onConfirm: () => Navigator.pop(context),
        showButton: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeColor.background,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          decoration: BoxDecoration(
            color: ThemeColor.putih,
            borderRadius: ThemeSize.borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Text(
            "Invoice",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ThemeSize.padding),
        child: FutureBuilder<List<dynamic>>(
          future: listPenjualan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Tidak ada data transaksi"));
            }
            final invoices = snapshot.data!;
            return ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final penjualan = invoices[index] as Map<String, dynamic>;
                final penjualanID = penjualan['penjualanID'];
                final totalHarga = penjualan['totalharga'] ?? 0;
                final tanggalPenjualan = penjualan['tanggalpenjualan'];
                final formattedDate = tanggalPenjualan != null
                    ? DateFormat('dd MMMM yyyy', 'id')
                        .format(DateTime.parse(tanggalPenjualan.toString()))
                    : '';

                String customerName = 'Non Member';
                if (penjualan.containsKey('pelanggan') &&
                    penjualan['pelanggan'] is Map<String, dynamic>) {
                  customerName =
                      penjualan['pelanggan']['namapelanggan']?.toString() ??
                          'Non Member';
                }
                return CustomList(
                  id: penjualanID,
                  title: customerName,
                  text1: formattedDate,
                  text2: 'Rp ${NumberFormat("#,###", "id").format(totalHarga)}',
                  delete: () {},
                  edit: () => showInvoice(penjualan),
                );
              },
            );
          },
        ),
      ),
      // floatingActionButton: IconButton(
      //   icon: const Icon(Icons.search),
      //   color: ThemeColor.hijau,
      //   onPressed: searchInvoice,
      // ),
    );
  }
}

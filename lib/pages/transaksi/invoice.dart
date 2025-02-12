// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw; // untuk pembuatan PDF
import 'package:printing/printing.dart'; // untuk membagikan/download PDF
import '../../components/themes.dart';
import '../../components/list.dart';
import '../../components/strukDialog.dart';
import '../../logic/controller.dart';

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

  // Fungsi search (sementara)
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

  Future<String> getCustomerName(Map<String, dynamic> penjualan) async {
    if (penjualan['pelanggan'] != null) {
      final dynamic dataPelanggan = penjualan['pelanggan'];
      if (dataPelanggan is List && dataPelanggan.isNotEmpty) {
        return dataPelanggan.first['namapelanggan']?.toString() ?? 'Non Member';
      } else if (dataPelanggan is Map<String, dynamic>) {
        return dataPelanggan['namapelanggan']?.toString() ?? 'Non Member';
      }
    }
    return await transaksiController
        .fetchCustomerName(penjualan['pelangganID']);
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

    final customerName = await getCustomerName(penjualan);
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
        createPDF: () =>
            createPDF(formattedDate, customerName, cartItems, totalHarga),
      ),
    );
  }

  /// Fungsi createPDF: Membuat file PDF yang meniru tampilan struk/invoice dan otomatis membagikan (atau mendownload) file PDF tersebut.
  Future<void> createPDF(String date, String customer,
      List<Map<String, dynamic>> items, int totalHarga) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'STRUK TRANSAKSI',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Tanggal: $date'),
              pw.Text('Pelanggan: $customer'),
              pw.Divider(),
              pw.Text('Daftar Pesanan:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Column(
                children: items.map((item) {
                  final subtotal =
                      (item['harga'] as int) * (item['total'] as int);
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                            child: pw.Text(
                                '${item['namaproduk']} (x${item['total']})')),
                        pw.Text(
                            'Rp ${NumberFormat("#,##0", "id").format(subtotal)}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      'Rp ${NumberFormat("#,##0", "id").format(totalHarga)}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: 'invoice.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColor.background,
        title: const Center(
          child: Text(
            'Invoice',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ThemeSize.padding),
        child: FutureBuilder<List<dynamic>>(
          future: listPenjualan,
          builder: (context, item) {
            if (item.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!item.hasData || item.data!.isEmpty) {
              return const Center(child: Text("Tidak ada data transaksi"));
            }
            final invoices = item.data!;
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

                return FutureBuilder<String>(
                  future: getCustomerName(penjualan),
                  builder: (context, item) {
                    final customerName = item.data ?? 'Non Member';
                    return CustomList(
                      id: penjualanID,
                      title: customerName,
                      text1: formattedDate,
                      text2:
                          'Rp ${NumberFormat("#,##0", "id").format(totalHarga)}',
                      delete: () {},
                      edit: () => showInvoice(penjualan),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      // Jika diperlukan, aktifkan floatingActionButton untuk fungsi search
      // floatingActionButton: IconButton(
      //   icon: const Icon(Icons.search),
      //   color: ThemeColor.hijau,
      //   onPressed: searchInvoice,
      // ),
    );
  }
}

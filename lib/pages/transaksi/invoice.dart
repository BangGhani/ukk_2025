import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:intl/intl.dart';
import '../../components/themes.dart';
import '../../components/list.dart';
import '../../logic/controller.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  final TransaksiController transaksiController = TransaksiController();
  late Future<List<dynamic>> penjualanFuture;

  @override
  void initState() {
    super.initState();
    penjualanFuture = transaksiController.fetchPenjualan();
  }

  void refreshInvoice() {
    setState(() {
      penjualanFuture = transaksiController.fetchPenjualan();
    });
  }

  // Fungsi search (untuk sementara) hanya menampilkan pesan
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
                // ignore: deprecated_member_use
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
          future: penjualanFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Tidak ada invoice"));
            }

            final penjualanList = snapshot.data!;
            return ListView.builder(
              itemCount: penjualanList.length,
              itemBuilder: (context, index) {
                final penjualan = penjualanList[index] as Map<String, dynamic>;
                final penjualanID = penjualan['penjualanID'];
                final totalHarga = penjualan['totalharga'];
                final tanggalPenjualan = penjualan['tanggalpenjualan'];
                final formattedDate = tanggalPenjualan != null
                    ? DateFormat('dd MMMM yyyy', 'id').format(
                        DateTime.parse(tanggalPenjualan.toString()))
                    : '';

                // Mendapatkan nama pelanggan dari relasi (asumsi data join ada di key 'pelanggan')
                String customerName = '';
                if (penjualan.containsKey('pelanggan') &&
                    penjualan['pelanggan'] is Map<String, dynamic>) {
                  customerName =
                      penjualan['pelanggan']['namapelanggan']?.toString() ?? '';
                }
                return CustomList(
                  id: penjualanID,
                  title: customerName,
                  text1: formattedDate,
                  text2: 'Rp $totalHarga',
                  delete: () {}, 
                  edit: () {}, 
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.search),
        color: ThemeColor.hijau,
        onPressed: searchInvoice,
      ),
    );
  }
}

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../components/themes.dart';
import '../../components/strukDialog.dart';
import 'listTransaksi.dart';
import '../../logic/controller.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});

  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  List<Map<String, dynamic>> listProduk = [];
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> listPelanggan = [];
  late Future<List<dynamic>> listPenjualan;
  String? pelanggan;
  int total = 0;
  int totalHarga = 0;

  final TransaksiController transaksicontroller = TransaksiController();
  final PelangganController pelanggancontroller = PelangganController();
  final ProdukController produkcontroller = ProdukController();
  final TextEditingController _lainnyaBiayaController = TextEditingController();
  final TextEditingController _lainnyaDiskonController = TextEditingController();


  Map<String, bool> biayaOptions = {
    "Layanan": false,
    "PPN": false,
    "Lainnya": false,
  };
  Map<String, bool> diskonOptions = {
    "Tahun Baru": false,
    "Ramadhan": false,
    "Idul Fitri": false,
    "Idul Adha": false,
    "Hari Raya Imlek": false,
    "Natal": false,
    "Lainnya": false,
  };

  @override
  void initState() {
    super.initState();
    fetchInitialData();
    listPenjualan = transaksicontroller.fetchPenjualan();
  }

  @override
  void dispose() {
    _lainnyaBiayaController.dispose();
    _lainnyaDiskonController.dispose();
    super.dispose();
  }

  Future<void> fetchInitialData() async {
    listProduk =
        (await produkcontroller.fetchProduk()).cast<Map<String, dynamic>>();
    listPelanggan = (await pelanggancontroller.fetchPelanggan())
        .cast<Map<String, dynamic>>();
    setState(() {});
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      int index = cartItems
          .indexWhere((item) => item['produkID'] == product['produkID']);
      if (index >= 0) {
        cartItems[index]['total'] += 1;
      } else {
        product['total'] = 1;
        cartItems.add(product);
      }
      calculateTotals();
    });
  }

  void calculateTotals() {
    total = 0;
    totalHarga = 0;
    for (var item in cartItems) {
      total += item['total'] as int;
      totalHarga += (item['harga'] as int) * (item['total'] as int);
    }
  }

  void onAdd(int index) {
    setState(() {
      final currentQuantity = cartItems[index]['total'] as int;
      final productStock = cartItems[index]['stok'] as int;
      if (currentQuantity < productStock) {
        cartItems[index]['total'] = currentQuantity + 1;
        calculateTotals();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ThemeColor.background,
            content: AwesomeSnackbarContent(
              title: 'Stok tidak cukup',
              message: 'Jumlah produk sudah mencapai stok maksimum.',
              contentType: ContentType.warning,
            ),
          ),
        );
      }
    });
  }

  void onRemove(int index) {
    setState(() {
      if (cartItems[index]['total'] > 1) {
        cartItems[index]['total'] -= 1;
      } else {
        cartItems.removeAt(index);
      }
      calculateTotals();
    });
  }

  void onDelete(int index) {
    setState(() {
      cartItems.removeAt(index);
      calculateTotals();
    });
  }

  void showInvoice(Map<String, dynamic> penjualan) async {
    final penjualanID = penjualan['penjualanID'];
    try {
      final detailResponse =
          await transaksicontroller.fetchDetailPenjualan(penjualanID);
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

    // Ambil nama pelanggan dari field join jika tersedia; jika tidak, gunakan fetchCustomerName dari controller.
    String customerName = 'Non Member';
    if (penjualan.containsKey('pelanggan') && penjualan['pelanggan'] != null) {
      final dynamic dataPelanggan = penjualan['pelanggan'];
      if (dataPelanggan is List && dataPelanggan.isNotEmpty) {
        customerName =
            dataPelanggan.first['namapelanggan']?.toString() ?? 'Non Member';
      } else if (dataPelanggan is Map<String, dynamic>) {
        customerName =
            dataPelanggan['namapelanggan']?.toString() ?? 'Non Member';
      }
    } else {
      customerName =
          await transaksicontroller.fetchCustomerName(penjualan['pelangganID']);
    }

    final totalHarga = penjualan['totalharga'] ?? 0;

    showDialog(
      context: context,
      builder: (context) => StrukDialog(
        date: formattedDate,
        selectedPelanggan: customerName,
        cartItems: cartItems,
        totalPesanan: totalHarga,
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          runTransaction();
        },
        showButton: false,
        createPDF: () =>
            createPDF(formattedDate, customerName, cartItems, totalHarga),
      ),
    );
  }

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

  void runTransaction() async {
    try {
      final pelangganData = listPelanggan
          .firstWhere((customer) => customer['namapelanggan'] == pelanggan);
      if (cartItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ThemeColor.background,
            content: AwesomeSnackbarContent(
              title: 'Keranjang kosong',
              message: 'Tambahkan barang terlebih dahulu',
              contentType: ContentType.warning,
            ),
          ),
        );
        return;
      }
      await transaksicontroller.addTransaction(
        pelangganID: pelangganData['pelangganID'],
        totalHarga: totalHarga,
        cartItems: cartItems,
      );
      setState(() {
        cartItems.clear();
        total = 0;
        totalHarga = 0;
        pelanggan = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.background,
          content: AwesomeSnackbarContent(
            title: 'Transaksi Berhasil',
            message: 'Transaksi berhasil dilakukan.',
            contentType: ContentType.success,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.background,
          content: AwesomeSnackbarContent(
            title: 'Gagal',
            message: 'Terjadi kesalahan saat melakukan transaksi',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColor.background,
        title: const Center(
          child: Text(
            'Transaksi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: InkWell(
                onTap: () {
                  final List<SelectedListItem<String>> items = listProduk
                      .map((produk) => SelectedListItem<String>(
                            data: produk['namaproduk'] as String,
                          ))
                      .toList();
                  DropDownState<String>(
                    dropDown: DropDown<String>(
                      enableMultipleSelection: true,
                      data: items,
                      onSelected: (selectedItems) {
                        if (selectedItems.isNotEmpty) {
                          for (final selected in selectedItems) {
                            final selectedName = selected.data;
                            Map<String, dynamic>? selectedProduct;
                            for (var produk in listProduk) {
                              if (produk['namaproduk'] == selectedName) {
                                selectedProduct = produk;
                                break;
                              }
                            }
                            if (selectedProduct != null) {
                              addToCart(selectedProduct);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Produk tidak ditemukan: $selectedName'),
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ).showModal(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeColor.hijau),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: ThemeColor.hijau),
                      const SizedBox(width: 8),
                      Text(
                        'Cari Produk',
                        style: TextStyle(color: ThemeColor.hijau),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...cartItems.map((item) {
                      int itemIndex = cartItems.indexOf(item);
                      double subtotal =
                          (item['harga'] * item['total']).toDouble();
                      return SingleCartItemTile(
                        title: item['namaproduk'],
                        price: subtotal,
                        total: item['total'],
                        onAdd: () => onAdd(itemIndex),
                        onRemove: () => onRemove(itemIndex),
                        onDelete: () => onDelete(itemIndex),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    //checkbox
                    Padding(
                      padding: const EdgeInsets.all(ThemeSize.padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Komponen checkbox untuk Biaya lainnya dan Diskon
                          CheckboxGroupWidget(
                            title: "Biaya lainnya",
                            options: biayaOptions,
                            otherController: _lainnyaBiayaController,
                            onChanged: (option, value) {
                              setState(() {
                                biayaOptions[option] = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          CheckboxGroupWidget(
                            title: "Diskon",
                            options: diskonOptions,
                            
                            otherController: _lainnyaDiskonController,
                            onChanged: (option, value) {
                              setState(() {
                                diskonOptions[option] = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Pelanggan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ThemeColor.hijau,
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            value: pelanggan,
                            isExpanded: true,
                            hint: const Text('Pilih Pelanggan'),
                            items: listPelanggan.map((customer) {
                              return DropdownMenuItem<String>(
                                value: customer['namapelanggan'],
                                child: Text(customer['namapelanggan']),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                pelanggan = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    ItemTotalsAndPrice(
                      totalItem: total,
                      totalPrice:
                          'Rp ${NumberFormat("#,###", "id").format(totalHarga)}',
                      customer: pelanggan ?? 'Non Member',
                    ),
                    AcceptButton(
                      onPressed: () {
                        final String currentDate =
                            DateFormat('dd MMMM yyyy', 'id')
                                .format(DateTime.now());
                        dynamic pelangganID;
                        if (pelanggan != null) {
                          final found = listPelanggan.firstWhere(
                            (customer) =>
                                customer['namapelanggan'] == pelanggan,
                            orElse: () => {},
                          );
                          if (found != null && found.isNotEmpty) {
                            pelangganID = found['pelangganID'];
                          }
                        }
                        final Map<String, dynamic> currentPenjualan = {
                          'penjualanID': 0, // Dummy karena belum tersimpan
                          'totalharga': totalHarga,
                          'tanggalpenjualan': DateTime.now().toIso8601String(),
                          'pelanggan': null,
                          'pelangganID': pelangganID,
                        };
                        showInvoice(currentPenjualan);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

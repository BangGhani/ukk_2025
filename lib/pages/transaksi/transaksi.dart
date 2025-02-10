import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:drop_down_list/drop_down_list.dart';
import '../../components/themes.dart';
import '../../logic/controller.dart';
import 'listTransaksi.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({super.key});

  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  List<Map<String, dynamic>> listProduk = [];
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> customerList = [];
  String? selectedCustomer;
  int total = 0;
  int totalPrice = 0;

  final TransaksiController transaksicontroller = TransaksiController();
  final PelangganController pelanggancontroller = PelangganController();
  final ProdukController produkcontroller = ProdukController();

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    listProduk =
        (await produkcontroller.fetchProduk()).cast<Map<String, dynamic>>();
    customerList = (await pelanggancontroller.fetchPelanggan())
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
    totalPrice = 0;
    for (var item in cartItems) {
      total += item['total'] as int;
      totalPrice += (item['harga'] as int) * (item['total'] as int);
    }
  }

  void onAdd(int index) {
    setState(() {
      cartItems[index]['total'] += 1;
      calculateTotals();
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

  void runTransaction() async {
    try {
      final selectedCustomerData = customerList.firstWhere(
          (customer) => customer['namapelanggan'] == selectedCustomer);
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
        pelangganID: selectedCustomerData['pelangganID'],
        totalHarga: totalPrice,
        cartItems: cartItems,
      );
      setState(() {
        cartItems.clear();
        total = 0;
        totalPrice = 0;
        selectedCustomer = null;
      });
      showSuccessDialog(context);
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

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColor.putih,
        title: Text(
          "Berhasil",
          style: TextStyle(color: ThemeColor.hijau),
        ),
        content: const Text("Transaksi berhasil dilakukan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: ThemeColor.hijau),
            ),
          )
        ],
      ),
    );
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
                      return SingleCartItemTile(
                        title: item['namaproduk'],
                        price: item['harga'],
                        total: item['total'],
                        onAdd: () => onAdd(itemIndex),
                        onRemove: () => onRemove(itemIndex),
                        onDelete: () => onDelete(itemIndex),
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    Align(
                      child: Text(
                        'Pelanggan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.hijau,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(ThemeSize.padding),
                      child: DropdownButton<String>(
                        value: selectedCustomer,
                        isExpanded: true,
                        hint: const Text('Pilih Pelanggan'),
                        items: customerList.map((customer) {
                          return DropdownMenuItem<String>(
                            value: customer['namapelanggan'],
                            child: Text(customer['namapelanggan']),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCustomer = newValue;
                          });
                        },
                      ),
                    ),
                    ItemTotalsAndPrice(
                      totalItem: total,
                      totalPrice: 'Rp. $totalPrice',
                      customer: selectedCustomer ?? 'Non Member',
                    ),
                    AcceptButton(
                      onPressed: runTransaction,
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

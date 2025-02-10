import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../../components/themes.dart';
import '../../components/listProduk.dart';
import '../../logic/controller.dart';
import 'editproduk.dart';
import 'addproduk.dart';
import 'search.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final ProdukController produkController = ProdukController();
  late Future<List<dynamic>> produkData;

  @override
  void initState() {
    super.initState();
    produkData = produkController.fetchProduk();
  }

  void refreshProduk() {
    setState(() {
      produkData = produkController.fetchProduk();
    });
  }

  void searchProduk() async {
    final produkData = await produkController.fetchProduk();
    showDialog(
      context: context,
      builder: (context) => SearchProdukDialog(
        produkList: produkData,
        onSelect: (selectedProduk) {
          editProduk(selectedProduk);
        },
      ),
    );
  }

  void addProduk() {
    showDialog(
      context: context,
      builder: (context) => TambahProdukDialog(
        onSave: (newProduk) async {
          try {
            await produkController.createProduk(newProduk);
            refreshProduk();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: ThemeColor.background,
                content: AwesomeSnackbarContent(
                  title: 'Berhasil',
                  message: 'Produk berhasil ditambahkan',
                  contentType: ContentType.success,
                ),
              ),
            );
          } catch (e) {
            if (e.toString().contains('null')) {
              refreshProduk();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ThemeColor.background,
                  content: AwesomeSnackbarContent(
                    title: 'Berhasil',
                    message: 'Produk berhasil diperbarui',
                    contentType: ContentType.success,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ThemeColor.background,
                  content: AwesomeSnackbarContent(
                    title: 'Gagal',
                    message: 'Terjadi kesalahan saat memperbarui produk: $e',
                    contentType: ContentType.failure,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void editProduk(Map<String, dynamic> produk) {
    showDialog(
      context: context,
      builder: (context) => EditProdukDialog(
        produk: produk,
        onSave: (updatedProduk) async {
          try {
            await produkController.updateProduk(
              produk['produkID'] as int,
              updatedProduk,
            );
            refreshProduk();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: ThemeColor.background,
                content: AwesomeSnackbarContent(
                  title: 'Berhasil',
                  message: 'Produk berhasil diperbarui',
                  contentType: ContentType.success,
                ),
              ),
            );
          } catch (e) {
            if (e.toString().contains('null')) {
              refreshProduk();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ThemeColor.background,
                  content: AwesomeSnackbarContent(
                    title: 'Berhasil',
                    message: 'Produk berhasil diperbarui',
                    contentType: ContentType.success,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ThemeColor.background,
                  content: AwesomeSnackbarContent(
                    title: 'Gagal',
                    message: 'Terjadi kesalahan saat memperbarui produk: $e',
                    contentType: ContentType.failure,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> deleteProduk(Map<String, dynamic> produk) async {
    try {
      await produkController.deleteProduk(produk['produkID'] as int);
      refreshProduk();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.background,
          content: AwesomeSnackbarContent(
            title: 'Berhasil',
            message: 'Produk berhasil dihapus',
            contentType: ContentType.success,
          ),
        ),
      );
    } catch (e) {
      if (e.toString().contains('null')) {
        refreshProduk();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ThemeColor.background,
            content: AwesomeSnackbarContent(
              title: 'Berhasil',
              message: 'Produk berhasil dihapus',
              contentType: ContentType.success,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ThemeColor.background,
            content: AwesomeSnackbarContent(
              title: 'Gagal',
              message: 'Terjadi kesalahan saat menghapus produk: $e',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    }
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
            "Produk",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ThemeSize.padding),
        child: FutureBuilder<List<dynamic>>(
          future: produkData,
          builder: (context, item) {
            if (item.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!item.hasData || item.data!.isEmpty) {
              return const Center(child: Text("Tidak ada produk"));
            }

            final produkList = item.data!;

            return ListView.builder(
              itemCount: produkList.length,
              itemBuilder: (context, index) {
                final produk = produkList[index];
                return CustomList(
                  id: produk['produkID'] as int,
                  name: produk['namaproduk'] as String,
                  stok: produk['stok'].toString(),
                  price: produk['harga'].toString(),
                  delete: () => deleteProduk(produk),
                  edit: () => editProduk(produk),
                );
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.list),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: ThemeColor.putih,
          backgroundColor: ThemeColor.hijau,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.small,
          foregroundColor: ThemeColor.putih,
          backgroundColor: ThemeColor.hijau,
          shape: const CircleBorder(),
        ),
        children: [
          FloatingActionButton(
            heroTag: 'Tambah',
            onPressed: () => addProduk(),
            foregroundColor: ThemeColor.putih,
            backgroundColor: ThemeColor.hijau,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'Cari',
            onPressed: () => searchProduk(),
            foregroundColor: ThemeColor.putih,
            backgroundColor: ThemeColor.hijau,
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

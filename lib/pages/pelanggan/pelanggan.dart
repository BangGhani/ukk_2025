import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../../components/themes.dart';
import '../../components/list.dart';
import '../../logic/controller.dart';
import 'editpelanggan.dart';
import 'addpelanggan.dart';
import 'search.dart';

class Pelanggan extends StatefulWidget {
  const Pelanggan({super.key});

  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan> {
  final PelangganController pelangganController = PelangganController();
  late Future<List<dynamic>> pelangganFuture;

  @override
  void initState() {
    super.initState();
    pelangganFuture = pelangganController.fetchPelanggan();
  }

  void refreshPelanggan() {
    setState(() {
      pelangganFuture = pelangganController.fetchPelanggan();
    });
  }

  void searchPelanggan() async {
    final pelangganData = await pelangganController.fetchPelanggan();
    showDialog(
      context: context,
      builder: (context) => SearchPelangganDialog(
        pelangganList: pelangganData,
        onSelect: (selectedPelanggan) {
          editPelanggan(selectedPelanggan);
        },
      ),
    );
  }

  void addPelanggan() {
    showDialog(
      context: context,
      builder: (context) => TambahPelangganDialog(
        onSave: (newPelanggan) async {
          try {
            await pelangganController.createPelanggan(newPelanggan);
            refreshPelanggan();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: ThemeColor.background,
                content: AwesomeSnackbarContent(
                  title: 'Berhasil',
                  message: 'Pelanggan berhasil ditambahkan',
                  contentType: ContentType.success,
                ),
              ),
            );
          } catch (e) {
            if (e.toString().contains('null')) {
              refreshPelanggan();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ThemeColor.background,
                  content: AwesomeSnackbarContent(
                    title: 'Berhasil',
                    message: 'Pelanggan berhasil diperbarui',
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
                    message: 'Terjadi kesalahan saat memperbarui pelanggan: $e',
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

  void editPelanggan(Map<String, dynamic> pelanggan) {
    showDialog(
      context: context,
      builder: (context) => EditPelangganDialog(
        pelanggan: pelanggan,
        onSave: (updatedPelanggan) async {
          try {
            await pelangganController.updatePelanggan(
              pelanggan['pelangganID'] as int,
              updatedPelanggan,
            );
            refreshPelanggan();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: ThemeColor.background,
                content: AwesomeSnackbarContent(
                  title: 'Berhasil',
                  message: 'Pelanggan berhasil diperbarui',
                  contentType: ContentType.success,
                ),
              ),
            );
          } catch (e) {
            if (e.toString().contains('null')) {
              refreshPelanggan();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: ThemeColor.background,
                  content: AwesomeSnackbarContent(
                    title: 'Berhasil',
                    message: 'Pelanggan berhasil diperbarui',
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
                    message: 'Terjadi kesalahan saat memperbarui pelanggan: $e',
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

  Future<void> deletePelanggan(Map<String, dynamic> pelanggan) async {
    try {
      await pelangganController.deletePelanggan(pelanggan['pelangganID'] as int);
      refreshPelanggan();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.background,
          content: AwesomeSnackbarContent(
            title: 'Berhasil',
            message: 'Pelanggan berhasil dihapus',
            contentType: ContentType.success,
          ),
        ),
      );
    } catch (e) {
      if (e.toString().contains('null')) {
        refreshPelanggan();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ThemeColor.background,
            content: AwesomeSnackbarContent(
              title: 'Berhasil',
              message: 'Pelanggan berhasil dihapus',
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
              message: 'Terjadi kesalahan saat menghapus pelanggan: $e',
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
            "Pelanggan",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ThemeSize.padding),
        child: FutureBuilder<List<dynamic>>(
          future: pelangganFuture,
          builder: (context, item) {
            if (item.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!item.hasData || item.data!.isEmpty) {
              return const Center(child: Text("Tidak ada pelanggan"));
            }

            final pelangganList = item.data!;

            return ListView.builder(
              itemCount: pelangganList.length,
              itemBuilder: (context, index) {
                final pelanggan = pelangganList[index];
                return CustomList(
                  id: pelanggan['pelangganID'] as int,
                  title: pelanggan['namapelanggan'] as String,
                  text1: pelanggan['alamat'].toString(),
                  text2: pelanggan['nomortelepon'].toString(),
                  delete: () => deletePelanggan(pelanggan),
                  edit: () => editPelanggan(pelanggan),
                );
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.people_outline_outlined),
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
            heroTag: 'TambahPelanggan',
            onPressed: () => addPelanggan(),
            foregroundColor: ThemeColor.putih,
            backgroundColor: ThemeColor.hijau,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'CariPelanggan',
            onPressed: () => searchPelanggan(),
            foregroundColor: ThemeColor.putih,
            backgroundColor: ThemeColor.hijau,
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

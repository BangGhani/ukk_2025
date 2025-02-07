import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../components/themes.dart';
import '../../components/form.dart';
import '../../logic/controller.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final ProdukController controller = ProdukController();
  List<dynamic> products = [];
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    try {
      final data = await controller.fetchProduk();
      setState(() {
        products = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: 'Terjadi kesalahan saat mengambil data: $e',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }

  void showEditDialog(Map<String, dynamic> product) {
    nameController = TextEditingController(text: product['namaproduk']);
    stockController = TextEditingController(text: product['stok'].toString());
    priceController = TextEditingController(text: product['harga'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Produk'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Nama Produk',
                hintText: 'Nama Produk',
                controller: nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Kolom tidak boleh kosong' : null,
              ),
              CustomTextField(
                label: 'Stok',
                hintText: 'Stok',
                controller: nameController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Kolom tidak boleh kosong' : null,
              ),
              CustomTextField(
                label: 'Harga',
                hintText: 'Harga',
                controller: nameController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Kolom tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await controller.updateProduk(
                    product['produkID'],
                    {
                      'namaproduk': nameController.text,
                      'stok': int.tryParse(stockController.text),
                      'harga': double.tryParse(priceController.text),
                    },
                  );
                  fetchProduk();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AwesomeSnackbarContent(
                        title: 'Error',
                        message: 'Terjadi kesalahan saat memperbarui data: $e',
                        contentType: ContentType.failure,
                      ),
                    ),
                  );
                }
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    ).then((_) {
      nameController.dispose();
      stockController.dispose();
      priceController.dispose();
    });
  }

  void showAddDialog() {
    nameController = TextEditingController();
    stockController = TextEditingController();
    priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Produk'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Nama Produk',
                hintText: 'Nama Produk',
                controller: nameController,
                validator: (value) =>
                    value!.isEmpty ? 'Kolom tidak boleh kosong' : null,
              ),
              CustomTextField(
                label: 'Stok',
                hintText: 'Stok',
                controller: nameController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Kolom tidak boleh kosong' : null,
              ),
              CustomTextField(
                label: 'Harga',
                hintText: 'Harga',
                controller: nameController,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Kolom tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await controller.createProduk({
                    'namaproduk': nameController.text,
                    'stok': int.tryParse(stockController.text),
                    'harga': double.tryParse(priceController.text),
                  });
                  fetchProduk();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AwesomeSnackbarContent(
                        title: 'Error',
                        message: 'Terjadi kesalahan saat menambah data: $e',
                        contentType: ContentType.failure,
                      ),
                    ),
                  );
                }
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        title: Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: showAddDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['namaproduk']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stok: ${product['stok']}'),
                Text('Harga: Rp ${product['harga'].toStringAsFixed(2)}'),
              ],
            ),
            onTap: () => showEditDialog(product),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                try {
                  await controller.deleteProduk(product['produkID']);
                  fetchProduk();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: IconButton(onPressed: showAddDialog, icon: Icon(Icons.add)),
    );
  }
}

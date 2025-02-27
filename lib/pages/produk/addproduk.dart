import 'package:flutter/material.dart';
import 'package:ukk_2025/components/themes.dart';

class TambahProdukDialog extends StatefulWidget {
  final Function(Map<String, dynamic> newProduk) onSave;

  const TambahProdukDialog({
    super.key,
    required this.onSave,
  });

  @override
  _TambahProdukDialogState createState() => _TambahProdukDialogState();
}

class _TambahProdukDialogState extends State<TambahProdukDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColor.putih,
      title: const Text("Tambah Produk"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _stokController,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newProduk = {
                'namaproduk': _nameController.text,
                'harga': int.tryParse(_hargaController.text) ?? 0,
                'stok': _stokController.text.isEmpty
                    ? 0
                    : int.tryParse(_stokController.text) ?? 0,
              };
              widget.onSave(newProduk);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}

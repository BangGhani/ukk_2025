import 'package:flutter/material.dart';
import '../../components/themes.dart';

class EditProdukDialog extends StatefulWidget {
  final Map<String, dynamic> produk;
  final Function(Map<String, dynamic> updatedProduk) onSave;

  const EditProdukDialog({
    super.key,
    required this.produk,
    required this.onSave,
  });

  @override
  _EditProdukDialogState createState() => _EditProdukDialogState();
}

class _EditProdukDialogState extends State<EditProdukDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hargaController;
  late TextEditingController _stokController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.produk['namaproduk']?.toString() ?? '',
    );
    _hargaController = TextEditingController(
      text: widget.produk['harga']?.toString() ?? '',
    );
    _stokController = TextEditingController(
      text: widget.produk['stok']?.toString() ?? '',
    );
  }

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
      title: const Text("Edit Produk"),
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
                    return 'Field ini tidak boleh kosong';
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
                    return 'Field ini tidak boleh kosong';
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
              final updatedProduk = {
                'namaproduk': _nameController.text,
                'harga': int.tryParse(_hargaController.text) ?? 0,
                'stok': _stokController.text.isEmpty
                    ? 0
                    : int.tryParse(_stokController.text) ?? 0
              };
              widget.onSave(updatedProduk);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}

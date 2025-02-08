import 'package:flutter/material.dart';
import 'package:ukk_2025/components/themes.dart';

class TambahPelangganDialog extends StatefulWidget {
  final Function(Map<String, dynamic> newPelanggan) onSave;

  const TambahPelangganDialog({
    super.key,
    required this.onSave,
  });

  @override
  _TambahPelangganDialogState createState() => _TambahPelangganDialogState();
}

class _TambahPelangganDialogState extends State<TambahPelangganDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _alamatController.dispose();
    _nomorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColor.putih,
      title: const Text("Tambah Pelanggan"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pelanggan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nomorController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
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
              final newPelanggan = {
                'namapelanggan': _nameController.text,
                'alamat': _alamatController.text,
                'nomortelepon': _nomorController.text,
              };
              widget.onSave(newPelanggan);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}

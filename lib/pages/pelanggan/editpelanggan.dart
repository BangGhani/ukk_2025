import 'package:flutter/material.dart';
import '../../components/themes.dart';

class EditPelangganDialog extends StatefulWidget {
  final Map<String, dynamic> pelanggan;
  final Function(Map<String, dynamic> updatedPelanggan) onSave;

  const EditPelangganDialog({
    super.key,
    required this.pelanggan,
    required this.onSave,
  });

  @override
  _EditPelangganDialogState createState() => _EditPelangganDialogState();
}

class _EditPelangganDialogState extends State<EditPelangganDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _alamatController;
  late TextEditingController _nomorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.pelanggan['namapelanggan']?.toString() ?? '',
    );
    _alamatController = TextEditingController(
      text: widget.pelanggan['alamat']?.toString() ?? '',
    );
    _nomorController = TextEditingController(
      text: widget.pelanggan['nomortelepon']?.toString() ?? '',
    );
  }

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
      title: const Text("Edit Pelanggan"),
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
                    return 'Field ini tidak boleh kosong';
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
                    return 'Field ini tidak boleh kosong';
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
                    return 'Field ini tidak boleh kosong';
                  }
                  // Validasi tambahan untuk nomor telepon bisa ditambahkan di sini
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
              final updatedPelanggan = {
                'namapelanggan': _nameController.text,
                'alamat': _alamatController.text,
                'nomortelepon': _nomorController.text,
              };
              widget.onSave(updatedPelanggan);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}

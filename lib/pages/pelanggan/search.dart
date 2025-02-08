import 'package:flutter/material.dart';
import '../../components/themes.dart';

class SearchPelangganDialog extends StatefulWidget {
  final List<dynamic> pelangganList;
  final Function(Map<String, dynamic> pelanggan) onSelect;

  const SearchPelangganDialog({
    Key? key,
    required this.pelangganList,
    required this.onSelect,
  }) : super(key: key);

  @override
  _SearchPelangganDialogState createState() => _SearchPelangganDialogState();
}

class _SearchPelangganDialogState extends State<SearchPelangganDialog> {
  String query = "";
  late List<dynamic> filteredPelanggan;

  @override
  void initState() {
    super.initState();
    filteredPelanggan = widget.pelangganList;
  }

  void updateList(String newQuery) {
    setState(() {
      query = newQuery;
      filteredPelanggan = widget.pelangganList.where((pelanggan) {
        final name = pelanggan['namapelanggan'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cari Pelanggan"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Ketik nama pelanggan",
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          updateList("");
                        },
                      )
                    : null,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ThemeColor.hijau),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ThemeColor.hijau),
                ),
              ),
              onChanged: updateList,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: filteredPelanggan.isEmpty
                  ? Center(
                      child: Text(
                        "Tidak ada pelanggan yang cocok",
                        style: TextStyle(color: ThemeColor.hijau),
                      ),
                    )
                  : ListView.builder(
                      primary: false,
                      itemCount: filteredPelanggan.length,
                      itemBuilder: (context, index) {
                        final pelanggan = filteredPelanggan[index];
                        return ListTile(
                          title: Text(pelanggan['namapelanggan'].toString()),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSelect(pelanggan);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}

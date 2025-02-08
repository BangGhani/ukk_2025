import 'package:flutter/material.dart';
import '../../components/themes.dart';

class SearchProdukDialog extends StatefulWidget {
  final List<dynamic> produkList;
  final Function(Map<String, dynamic> produk) onSelect;

  const SearchProdukDialog({
    super.key,
    required this.produkList,
    required this.onSelect,
  });

  @override
  _SearchProdukDialogState createState() => _SearchProdukDialogState();
}

class _SearchProdukDialogState extends State<SearchProdukDialog> {
  String query = "";
  late List<dynamic> filteredProduk;

  @override
  void initState() {
    super.initState();
    filteredProduk = widget.produkList;
  }

  void updateList(String newQuery) {
    setState(() {
      query = newQuery;
      filteredProduk = widget.produkList.where((produk) {
        final name = produk['namaproduk'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColor.putih,
      title: const Text("Cari Produk"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Ketik nama produk",
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
              child: filteredProduk.isEmpty
                  ? Center(
                      child: Text(
                        "Tidak ada produk yang cocok",
                        style: TextStyle(color: ThemeColor.hijau),
                      ),
                    )
                  : ListView.builder(
                      // Hilangkan shrinkWrap dan gunakan primary: false
                      primary: false,
                      itemCount: filteredProduk.length,
                      itemBuilder: (context, index) {
                        final produk = filteredProduk[index];
                        return ListTile(
                          title: Text(produk['namaproduk'].toString()),
                          onTap: () {
                            Navigator.pop(context);
                            widget.onSelect(produk);
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

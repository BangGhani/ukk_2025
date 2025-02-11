import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'themes.dart';

class CustomList extends StatelessWidget {
  const CustomList({
    super.key,
    required this.id,
    required this.name,
    required this.stok,
    required this.price,
    required this.delete,
    required this.edit,
  });

  final int id;
  final String name;
  final String stok;
  final String price;
  final VoidCallback delete;
  final VoidCallback edit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeSize.borderRadius,
      ),
      color: ThemeColor.putih,
      child: InkWell(
        onTap: edit,
        borderRadius: ThemeSize.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(ThemeSize.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stok: $stok',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Rp ${NumberFormat('#,###', 'id').format(int.parse(price))}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: SvgPicture.asset('assets/icons/delete.svg'),
                    onPressed: delete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
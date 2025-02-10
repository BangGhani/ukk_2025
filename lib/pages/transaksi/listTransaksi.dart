import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/themes.dart';

class SingleCartItemTile extends StatelessWidget {
  const SingleCartItemTile({
    super.key,
    required this.title,
    required this.price,
    required this.total,
    required this.onRemove,
    required this.onAdd,
    required this.onDelete,
  });

  final String title;
  final double price;
  final int total;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeSize.padding,
        vertical: ThemeSize.padding / 2,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onRemove,
                        icon: SvgPicture.asset("assets/icons/remove.svg"),
                        constraints: const BoxConstraints(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          total.toString(),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                      IconButton(
                        onPressed: onAdd,
                        icon: SvgPicture.asset("assets/icons/add_quantity.svg"),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                    icon: SvgPicture.asset("assets/icons/delete.svg"),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${price.toString()}',
                  ),
                ],
              ),
            ],
          ),
          const Divider(thickness: 0.1),
        ],
      ),
    );
  }
}

class ItemTotalsAndPrice extends StatelessWidget {
  const ItemTotalsAndPrice({
    super.key,
    required this.totalItem,
    required this.totalPrice,
    required this.customer,
  });

  final int totalItem;
  final String customer;
  final String totalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeSize.padding),
      child: Column(
        children: [
          ItemRow(
            title: 'Total Barang',
            value: totalItem.toString(),
          ),
          ItemRow(
            title: 'Pelanggan',
            value: customer,
          ),
          const DottedDivider(),
          ItemRow(
            title: 'Total Harga',
            value: totalPrice,
          ),
        ],
      ),
    );
  }
}

class ItemRow extends StatelessWidget {
  const ItemRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class DottedDivider extends StatelessWidget {
  const DottedDivider({
    super.key,
    this.isVertical = false,
    this.color,
  });

  final Color? color;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            30,
            (index) => Container(
              margin: const EdgeInsets.all(3),
              width: 1,
              height: 8,
              color: color ?? Colors.black,
            ),
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            30,
            (index) => Container(
              margin: const EdgeInsets.all(3),
              width: 8,
              height: 0.3,
              color: color ?? Colors.black,
            ),
          ),
        ),
      );
    }
  }
}

class AcceptButton extends StatelessWidget {
  const AcceptButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeSize.padding),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(ThemeSize.padding),
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text('Konfirmasi'),
          ),
        ),
      ),
    );
  }
}

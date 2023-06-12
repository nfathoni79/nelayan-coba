import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';

class MartDropdown extends StatelessWidget {
  const MartDropdown({
    super.key,
    required this.martList,
    required this.currentMartId,
    this.onChanged,
  });

  final List<Mart> martList;
  final int currentMartId;
  final Function(int?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.store),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton(
            value: currentMartId,
            isExpanded: true,
            items: [
              ...martList.map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(e.name),
              )).toList()
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

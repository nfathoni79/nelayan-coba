import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/fish.dart';

class FishDropdown extends StatelessWidget {
  const FishDropdown({
    super.key,
    required this.fishList,
    required this.currentFishId,
    this.onChanged,
  });

  final List<Fish> fishList;
  final int currentFishId;
  final Function(int?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.set_meal),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton(
            value: currentFishId,
            isExpanded: true,
            items: [
              ...fishList.map((e) => DropdownMenuItem(
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

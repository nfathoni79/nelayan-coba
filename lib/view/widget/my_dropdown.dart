import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class MyDropdown<T> extends StatelessWidget {
  const MyDropdown({
    super.key,
    required this.items,
    required this.itemAsString,
    required this.compareFn,
    this.prefixIcon,
    this.labelText,
    this.onChanged,
    this.selectedItem,
    this.itemBuilder,
  });

  final List<T> items;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final Widget? prefixIcon;
  final String? labelText;
  final Function(T?)? onChanged;
  final T? selectedItem;
  final Widget Function(BuildContext, T, bool)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
        ),
        itemBuilder: itemBuilder,
      ),
      items: items,
      itemAsString: itemAsString,
      compareFn: compareFn,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: prefixIcon,
          labelText: labelText,
        ),
      ),
      onChanged: onChanged,
      selectedItem: selectedItem,
    );
  }
}

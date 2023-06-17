import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class MyDropdown<T> extends StatelessWidget {
  const MyDropdown({
    super.key,
    this.items = const [],
    this.asyncItems,
    this.itemAsString,
    this.compareFn,
    this.prefixIcon,
    this.labelText,
    this.onChanged,
    this.selectedItem,
    this.itemBuilder,
    this.showSelectedItems = false,
    this.validator,
  });

  final List<T> items;
  final Future<List<T>> Function(String)? asyncItems;
  final String Function(T)? itemAsString;
  final bool Function(T, T)? compareFn;
  final Widget? prefixIcon;
  final String? labelText;
  final Function(T?)? onChanged;
  final T? selectedItem;
  final Widget Function(BuildContext, T, bool)? itemBuilder;
  final bool showSelectedItems;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      popupProps: PopupProps.menu(
        showSelectedItems: showSelectedItems,
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
        ),
        itemBuilder: itemBuilder,
      ),
      items: items,
      asyncItems: asyncItems,
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
      validator: validator,
    );
  }
}

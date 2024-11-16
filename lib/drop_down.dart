import 'package:flutter/material.dart';
import 'drop_down_item.dart';

class DropDown extends StatelessWidget {
  final double itemHeight;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final List<String> itemsText;
  final List<IconData>? itemIcons;
  final List<String>? initialValues;
  final Function(List<String>)? onSelectionChange;

  const DropDown({
    Key? key,
    this.itemHeight = 20.0,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
    this.borderRadius = 0.0,
    required this.itemsText,
    this.itemIcons,
    this.initialValues,
    this.onSelectionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> selectedValues = List<String>.from(initialValues as Iterable) ?? [];
    return Material(
      elevation: 30,
      color: backgroundColor!.withOpacity(0.5),
      borderRadius: BorderRadius.circular(borderRadius!),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(itemsText.length, (index) => DropDownItem(
              text: itemsText[index],
              isSelected: selectedValues.contains(itemsText[index]),
              iconData: itemIcons != null ? itemIcons![index] : null,
              color: backgroundColor,
              textColor: textColor,
              onSelected: (isSelected) {
                if (isSelected) {
                  selectedValues.add(itemsText[index]);
                } else {
                  selectedValues.remove(itemsText[index]);
                }
                onSelectionChange?.call(selectedValues);
              },
            ),
            ),
          ),
        ),
      ),
    );
  }
}
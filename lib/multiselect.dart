library multiselect;

import 'package:flutter/material.dart';
import 'drop_down.dart';


class Multiselect extends StatefulWidget {
  final String labelText;
  final TextStyle labelTextStyle;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final List<String> itemText;
  final List<IconData>? itemIcons;
  final List<String>? initialValues;
  final Function(List<String>)? onValueChange;

  final Color optionListBackgroundColor;
  final Color optionListTextColor;
  final double optionListBorderRadius;

  const Multiselect({
    Key? key,
    this.labelText = 'Wybierz',
    this.labelTextStyle = const TextStyle(color: Colors.black),
    this.backgroundColor = Colors.grey,
    this.borderColor = Colors.grey,
    this.borderRadius = 0.0,
    this.optionListBackgroundColor = Colors.grey,
    this.optionListTextColor = Colors.black,
    this.optionListBorderRadius = 0.0,
    required this.itemText,
    this.itemIcons,
    this.initialValues,
    this.onValueChange,
  }) : super(key: key);

  @override
  _MultiselectState createState() => _MultiselectState();
}

class _MultiselectState extends State<Multiselect> {
  GlobalKey actionKey = GlobalKey();
  bool isDropdownOpened = false;
  late double _height, _width, _xPosition, _yPosition;
  late OverlayEntry floatingDropdown;
  late List<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.initialValues ?? [];
  }

  void findDropdownData() {
    final renderBox = actionKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _height = renderBox.size.height;
      _width = renderBox.size.width;
      final offset = renderBox.localToGlobal(Offset.zero);
      _xPosition = offset.dx;
      _yPosition = offset.dy;
    }
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (isDropdownOpened) {
                    floatingDropdown.remove();
                    isDropdownOpened = false;
                  }
                });
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              left: _xPosition,
              top: _yPosition + _height,
              width: _width,
              height: 240,
              child: DropDown(
                itemsText: widget.itemText,
                itemIcons: widget.itemIcons,
                borderRadius: widget.optionListBorderRadius,
                backgroundColor: widget.optionListBackgroundColor,
                textColor: widget.optionListTextColor,
                initialValues: selectedValues,
                onSelectionChange: (updatedValues) {
                  setState(() {
                    selectedValues = updatedValues;
                  });
                  widget.onValueChange?.call(updatedValues);
                },
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Color iconColor = widget.labelTextStyle?.color ?? Colors.black;
    return WillPopScope(
      onWillPop: () async {
        if (isDropdownOpened) {
          setState(() {
            floatingDropdown.remove();
            isDropdownOpened = false;
          });
          return false;
        }
        return true;
      },
      child: GestureDetector(
          key: actionKey,
          onTap: (){
            setState(() {
              if (isDropdownOpened) {
                floatingDropdown.remove();
              } else {
                findDropdownData();
                floatingDropdown = _createFloatingDropdown();
                Overlay.of(context).insert(floatingDropdown);
              }
              isDropdownOpened = !isDropdownOpened;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              border: Border.all(
                color: widget.borderColor!,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius!),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    selectedValues.isNotEmpty
                        ? selectedValues.join(', ')
                        : widget.labelText,
                    style: widget.labelTextStyle,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(width: 8),
                isDropdownOpened
                    ? Icon(Icons.arrow_drop_up, color: iconColor)
                    : Icon(Icons.arrow_drop_down, color: iconColor),
              ],
            ),
          )
      ),
    );
  }
}
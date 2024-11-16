import 'package:flutter/material.dart';

class DropDownItem extends StatefulWidget {
  final String text;
  final IconData? iconData;
  bool isSelected;
  final Color color;
  final Color textColor;
  final Function(bool isSelected)? onSelected;

  DropDownItem({
    super.key,
    required this.text,
    this.iconData,
    this.isSelected = false,
    this.color = Colors.grey,
    this.textColor = Colors.black,
    this.onSelected,
  });

  @override
  _DropDownItemState createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
        widget.onSelected?.call(widget.isSelected);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.isSelected ? lightenColor(widget.color) : widget.color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Row(
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Icon(widget.iconData, color: Colors.black),
          ],
        ),
      ),
    );
  }
}

Color lightenColor(Color color, [double amount = 0.2]) {
  assert(amount >= 0.0 && amount <= 1.0);

  int r = (color.red * (1 + amount)).toInt();
  int g = (color.green * (1 + amount)).toInt();
  int b = (color.blue * (1 + amount)).toInt();

  return Color.fromRGBO(r, g, b, color.opacity);
}
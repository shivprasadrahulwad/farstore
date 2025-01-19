import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final bool isSelected;
  final Function(bool) onChanged;

  const CustomRadioButton({
    Key? key,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isSelected);
      },
      child: Container(
        width: 20, // Overall size of the radio button
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isSelected ? Colors.black : Colors.grey,
            width: widget.isSelected ? 6 : 1,
          ),
        ),
      ),
    );
  }
}

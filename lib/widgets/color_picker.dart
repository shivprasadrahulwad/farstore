import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  const ColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Pick a Color'),
              content: SingleChildScrollView(
                child: MaterialPicker(
                  pickerColor: widget.pickerColor,
                  onColorChanged: widget.onColorChanged,
                  enableLabel: true,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        primary: widget.pickerColor,
      ),
      child: Text(
        'Pick Color',
        style: TextStyle(
          color: useWhiteForeground(widget.pickerColor)
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}



class BlockColorPicker extends StatefulWidget {
  const BlockColorPicker({super.key});

  @override
  State<BlockColorPicker> createState() => _BlockColorPickerState();
}

class _BlockColorPickerState extends State<BlockColorPicker> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
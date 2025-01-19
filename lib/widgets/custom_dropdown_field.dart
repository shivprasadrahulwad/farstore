import 'package:farstore/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String hintText;
  final String? value;
  final List items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final String placeholderText;

  const CustomDropdownField({
    Key? key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.isEnabled = true,
    required this.placeholderText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: TextEditingController(text: value),
          hintText: hintText,
          readOnly: true,
          validator: validator,
          onTap: isEnabled ? () {
            _showDropdownDialog(context);
          } : null,
          // Create the suffix icon using decoration
          suffixIcon: Icons.keyboard_arrow_down,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
          fillColor: isEnabled ? Colors.white : Colors.grey.shade200,
        ),
      ],
    );
  }

  Future<void> _showDropdownDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  'Select $hintText',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              color: item == value ? Colors.green : Colors.black87,
                              fontWeight: item == value ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          selected: item == value,
                          onTap: () {
                            Navigator.of(context).pop(item);
                          },
                        ),
                        if (index < items.length - 1)
                          const Divider(height: 1),
                      ],
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }
}
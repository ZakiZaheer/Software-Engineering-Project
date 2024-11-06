import 'package:flutter/material.dart';
import 'package:task_manager/customWidgets/NewList.dart';

class DropDownField extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final Function(String) onChanged;
  final Function(String) onAddItem;

  const DropDownField(
      {super.key,
      required this.items,
      required this.onChanged,
      required this.onAddItem,
      this.initialValue});

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedItem = widget.initialValue;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Color(0xFFE2E2E2), Color(0xFF051A33)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFF0A1A2A),
            value: _selectedItem,
            items: [
              ...widget.items.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )),
              const DropdownMenuItem(
                value: 'New List',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New List',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value == 'New List') {
                _showNewListDialog();
              } else {
                setState(() {
                  _selectedItem = value;
                  widget.onChanged(value!);
                });
              }
            },
            decoration: const InputDecoration(
              hintText: 'Category',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  void _showNewListDialog() {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
          title: "Create New List",
          hintText: "New List",
          errorText: "Duplicate Category Not Allowed",
          onSaved: (newCategory) async {
            await widget.onAddItem(newCategory);
            setState(() {
              _selectedItem = newCategory;
            });
          }),
    );
  }
}

import 'package:flutter/material.dart';

import '../Custom_Fonts.dart';

class SelectionField extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function()? onTap;

  const SelectionField({super.key, required this.title, required this.initialValue , required this.onTap });

  @override
  State<SelectionField> createState() => _SelectionFieldState();
}

class _SelectionFieldState extends State<SelectionField> {
  late String value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TimeLeftContent(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TimeContentRight(),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
      onTap: widget.onTap != null ? ()async{
        String? newVal =await widget.onTap!();
        if(newVal != null){
          setState(() {
            value = newVal;
            print("newVale: $newVal");
          });
        }
      } : null,
    );
  }
}

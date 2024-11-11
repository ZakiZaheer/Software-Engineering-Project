import 'package:flutter/material.dart';

import '../Custom_Fonts.dart';

class SelectionField extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function()? onTap;
  final bool isActive;

  const SelectionField({super.key, required this.title, required this.initialValue , required this.onTap , required this.isActive });

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
      contentPadding:const  EdgeInsets.symmetric(vertical: 0),
      title: Text(
        widget.title,
        style: widget.isActive ? timeLeftContent() : timeLeftContentDisabled(),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: timeContentRight(),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
      onTap: widget.isActive ? ()async{
        String? newVal =await widget.onTap!();
        if(newVal != null){
          setState(() {
            value = newVal;
            print("${widget.title} value changed to $value");
          });
        }
      } : null,
    );
  }
}

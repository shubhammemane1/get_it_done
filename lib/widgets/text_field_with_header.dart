import 'package:flutter/material.dart';
import 'package:get_it_done/utils/appColors.dart';

class TextFieldWithHeader extends StatefulWidget {
  final String? header;
  final TextEditingController? controller;
  const TextFieldWithHeader({super.key, this.header, this.controller});

  @override
  State<TextFieldWithHeader> createState() => _TextFieldWithHeaderState();
}

class _TextFieldWithHeaderState extends State<TextFieldWithHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.header!,
            style: const TextStyle(
                fontFamily: "Nexa",
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: widget.controller,
            cursorColor: AppColors.primaryColor,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 5),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> selectDate(BuildContext context , DateTime date) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: date,
    firstDate: DateTime.now(),
    lastDate: DateTime(2101),
  );

  return picked;
}

String formatDate(String dateString) {
  // Parse the input date string into a DateTime object
  DateTime inputDate = DateTime.parse(dateString);

  // Define the desired date format
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  // Format the DateTime object to the desired format
  String formattedDate = formatter.format(inputDate);

  return formattedDate;
}

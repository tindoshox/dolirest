import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;
  final String labelText;
  final String hintText;
  final FormFieldValidator<String>? validator;

  const PeriodDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelText = 'Period',
    this.hintText = 'Select Period',
    this.validator,
  });

  List<String> _generatePeriods() {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year - 2, now.month);

    List<String> periods = [];
    DateTime current = start;

    while (!current.isAfter(now)) {
      periods.add(DateFormat('MMM-yyyy').format(current));
      current = DateTime(current.year, current.month + 1);
    }

    return periods.reversed.toList(); // Latest first
  }

  @override
  Widget build(BuildContext context) {
    final periods = _generatePeriods();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        validator: validator,
        decoration: InputDecoration(
          labelText: 'Report',
          prefixIcon: Icon(
            Icons.picture_as_pdf_outlined,
            color: Colors.brown,
          ),
        ),
        hint: Text(hintText),
        items: periods.map((period) {
          return DropdownMenuItem<String>(
            value: period,
            child: Text(period),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

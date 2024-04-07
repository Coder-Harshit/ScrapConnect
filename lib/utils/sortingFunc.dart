import 'package:flutter/material.dart';

void sortDataRows(List<DataRow> rows, int columnIndex, bool ascending) {
  rows.sort((a, b) {
    String aValue = a.cells[columnIndex].child.toString();
    String bValue = b.cells[columnIndex].child.toString();
    return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
  });
}

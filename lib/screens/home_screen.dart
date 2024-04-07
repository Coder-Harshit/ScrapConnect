import 'package:flutter/material.dart';
import '../utils/sortingFunc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}!'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          RateListPage(),
          DealersListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Rate List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Dealers List',
          ),
        ],
      ),
    );
  }
}

class RateListPage extends StatefulWidget {
  @override
  _RateListPageState createState() => _RateListPageState();
}

class _RateListPageState extends State<RateListPage> {
  List<DataRow> _rows = [
    DataRow(cells: [
      DataCell(Text('Iron')),
      DataCell(Text('50')),
    ]),
    DataRow(cells: [
      DataCell(Text('Gold')),
      DataCell(Text('750')),
    ]),
    DataRow(cells: [
      DataCell(Text('Paper')),
      DataCell(Text('10')),
    ]),
    // Add more DataRow widgets for additional items
  ];

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort(int columnIndex) {
    if (columnIndex == _sortColumnIndex) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumnIndex = columnIndex;
      _sortAscending = true;
    }

    sortDataRows(_rows, columnIndex, _sortAscending);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            child: DataTable(
              columnSpacing: 8.0,
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: Text('Item'),
                  numeric: true,
                  tooltip: 'Item Name',
                  onSort: (columnIndex, ascending) {
                    _sort(columnIndex);
                  },
                ),
                DataColumn(
                  label: Text('Price'),
                  numeric: true,
                  tooltip: 'Rate of Item',
                  onSort: (columnIndex, ascending) {
                    _sort(columnIndex);
                  },
                ),
                // Add more DataColumn widgets for additional columns
              ],
              rows: _rows,
            ),
          ),
        ),
      ),
    );
  }
}

class DealersListPage extends StatefulWidget {
  @override
  _DealersListPageState createState() => _DealersListPageState();
}

class _DealersListPageState extends State<DealersListPage> {
  List<DataRow> _rows = [
    DataRow(cells: [
      DataCell(Text('1')),
      DataCell(Text('2180')),
      DataCell(Text('Anmol')),
      DataCell(Text('6.9')),
      DataCell(Text('Karnal')),
      DataCell(Text('Karnal')),
      DataCell(Text('Karnal')),
    ]),
    DataRow(cells: [
      DataCell(Text('2')),
      DataCell(Text('1823')),
      DataCell(Text('ABCD')),
      DataCell(Text('9.1')),
      DataCell(Text('A')),
      DataCell(Text('B')),
      DataCell(Text('C')),
    ]),
    DataRow(cells: [
      DataCell(Text('3')),
      DataCell(Text('777')),
      DataCell(Text('HV')),
      DataCell(Text('9.7')),
      DataCell(Text('K')),
      DataCell(Text('O')),
      DataCell(Text('!')),
    ]),
    DataRow(cells: [
      DataCell(Text('4')),
      DataCell(Text('3018')),
      DataCell(Text('Rohit')),
      DataCell(Text('9.9')),
      DataCell(Text('UP')),
      DataCell(Text('IDK')),
      DataCell(Text('India')),
    ]),
    // Add more DataRow widgets for additional dealers
  ];

  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void _sort(int columnIndex) {
    if (columnIndex == _sortColumnIndex) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumnIndex = columnIndex;
      _sortAscending = true;
    }

    sortDataRows(_rows, columnIndex, _sortAscending);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: DataTable(
            columnSpacing: 8.0,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: [
              DataColumn(
                label: Text('Srno'),
                numeric: true,
                tooltip: 'Serial Number',
                onSort: (columnIndex, ascending) {
                  _sort(columnIndex);
                },
              ),
              DataColumn(
                label: Text('ID'),
                tooltip: 'Identification Number',
                onSort: (columnIndex, ascending) {
                  _sort(columnIndex);
                },
              ),
              DataColumn(
                label: Text('Name'),
                tooltip: 'Name of the Dealer',
                onSort: (columnIndex, ascending) {
                  _sort(columnIndex);
                },
              ),
              DataColumn(
                label: Text('Rating'),
                numeric: true,
                tooltip: 'Rating of the Dealer',
                onSort: (columnIndex, ascending) {
                  _sort(columnIndex);
                },
              ),
              DataColumn(
                label: Text('Location'),
                tooltip: 'Location of the Dealer',
                onSort: (columnIndex, ascending) {
                  _sort(columnIndex);
                },
              ),
              DataColumn(
                label: Text('Location2'),
                tooltip: 'Location of the Dealer',
                onSort: (columnIndex, ascending) {
                  _sort(columnIndex);
                },
              ),
              DataColumn(
                label: Text('Location3'),
                tooltip: 'Location of the Dealer',
                onSort: (columnIndex, ascending) {
                  _sort(columnIndex);
                },
              ),
            ],
            rows: _rows,
          ),
        ),
      ),
    );
  }
}

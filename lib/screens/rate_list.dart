import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class RateListPage extends StatefulWidget {
  @override
  _RateListPageState createState() => _RateListPageState();
}

class _RateListPageState extends State<RateListPage> {
  List<DataRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Call function to fetch data when the widget is initialized
  }

  // Function to fetch data from Firestore
  Future<void> _fetchData() async {
    // Access Firestore document
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Default_Ratelist')
        .doc('vShDY9mv8siYe3DccWmy')
        .get();

    // Extract data from document
    Map<String, dynamic> data = snapshot.data() ?? {};

    // Loop through data and populate _rows list
    data.forEach((itemName, rate) {
      // Determine the image path based on the item name
      String imagePath = _getImagePath(itemName);

      // Create DataRow and add it to _rows list
      _rows.add(
        DataRow(cells: [
          DataCell(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 100, // Set the width of the imagew
                    height: 100, // Set the height of the image
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        imagePath, // Display the image from assets
                        fit: BoxFit.cover, // Cover the entire space
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 16), // Add some spacing between the image and text
                  Text(
                    itemName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          DataCell(
            Text(
              rate.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ]),
      );
    });

    // Update the UI with the fetched data
    setState(() {});
  }

  // Function to determine the image path based on the item name
  String _getImagePath(String itemName) {
    // Convert the item name to lowercase and remove spaces
    String imageName = itemName.toLowerCase().replaceAll(' ', '');
    // Return the image path
    return 'assets/images/$imageName.jpg'; // Assuming all images have a .png extension
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // scrollDirection: Axis.horizontal,
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 16.0,
              headingRowHeight: 56,
              dataRowMinHeight: 10,
              dataRowMaxHeight: 70,
              headingTextStyle:
                  TextStyle(letterSpacing: 2, fontFamily: 'MonaSans'),
              columns: [
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'ITEM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  numeric: false,
                  tooltip: 'Item Name',
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'PRICE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  numeric: true,
                  tooltip: 'Rate of Item',
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

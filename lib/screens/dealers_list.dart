import 'package:flutter/material.dart';
import '../utils/bookAppointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class DealersListPage extends StatefulWidget {
  final String username;
  DealersListPage({required this.username});
  @override
  _DealersListPageState createState() => _DealersListPageState();
}

class _DealersListPageState extends State<DealersListPage> {
  List<DataRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Kabadi_walas').get();

      querySnapshot.docs.forEach((doc) {
        // Extract data from each document
        String srno = (doc.data()['ID'] ?? '').toString();
        String name = (doc.data()['Name'] ?? '').toString();
        String rating = (doc.data()['Rating'] ?? '').toString();
        String Contact_Number = (doc.data()['Contact_Number'] ?? '').toString();

        // Create DataRow and add it to _rows list
        _rows.add(
          DataRow(cells: [
            DataCell(Text(srno)),
            // DataCell(Text(id)),
            DataCell(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DealerRatePage(
                        dealerId: doc.data()['ID'].toString(),
                        username: widget.username,
                      ),
                    ),
                  );
                },
                child: Text(name),
              ),
            ),
            DataCell(Text(rating)),
            DataCell(Text(Contact_Number)),
          ]),
        );
      });

      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 8.0,
              columns: [
                DataColumn(label: Text('Srno'), numeric: true),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Rating'), numeric: true),
                DataColumn(label: Text('Contact_Number')),
              ],
              rows: _rows,
            ),
          ),
        ),
      ),
    );
  }
}

class DealerRatePage extends StatefulWidget {
  final String dealerId;
  final String username;

  DealerRatePage({required this.dealerId, required this.username});

  @override
  State<DealerRatePage> createState() => _DealerRatePageState();
}

class _DealerRatePageState extends State<DealerRatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dealer Rates'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Kabadi_walas_ratelist')
            .doc(widget.dealerId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Center(child: Text('No rates found for this dealer.'));
          }

          // Extract rate data from the document
          Map<String, dynamic> rates =
              snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: rates.entries.map((entry) {
                    String itemName = entry.key;
                    dynamic itemRate = entry.value;
                    String imagePath = _getImagePath(itemName);

                    return ListTile(
                      leading: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          )),
                      title: Text(
                        itemName,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ), // Item name
                      subtitle: Text(itemRate.toString()), // Item rate
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Book appointment logic
                    bookAppointment(context, widget.dealerId, widget.username);
                  },
                  child: Text("BOOK APPOINTMENT"),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // Function to determine the image path based on the item name
  String _getImagePath(String itemName) {
    // Convert the item name to lowercase and remove spaces
    String imageName = itemName.toLowerCase().replaceAll(' ', '');
    // Return the image path
    return 'assets/images/$imageName.jpg'; // Assuming all images have a .png extension
  }
}

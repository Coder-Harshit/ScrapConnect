import 'package:flutter/material.dart';
import '../utils/bookAppointment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

class DealersListPage extends StatefulWidget {
  final String username;
  DealersListPage({required this.username});
  @override
  _DealersListPageState createState() => _DealersListPageState();
}

class _DealersListPageState extends State<DealersListPage> {
  List<DataRow> _rows = [];
  bool _sortAscendingSrno = true;
  bool _sortAscendingRating = true;
  late BuildContext _context; // Declare a variable to store the context
  // Default sorting order
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _sortRowsBySrno() {
    _rows.sort((a, b) {
      int srnoA = int.parse((a.cells[0].child as Text).data!);
      int srnoB = int.parse((b.cells[0].child as Text).data!);
      return _sortAscendingSrno
          ? srnoA.compareTo(srnoB)
          : srnoB.compareTo(srnoA);
    });
  }

  void _sortRowsByRating() {
    _rows.sort((a, b) {
      String ratingA = a.cells[2].child.toString();
      String ratingB = b.cells[2].child.toString();
      return _sortAscendingRating
          ? ratingA.compareTo(ratingB)
          : ratingB.compareTo(ratingA);
    });
  }

  void _sortRows(int columnIndex) {
    if (columnIndex == 0) {
      _sortAscendingSrno = !_sortAscendingSrno;
      _sortRowsBySrno();
    } else if (columnIndex == 2) {
      _sortAscendingRating = !_sortAscendingRating;
      _sortRowsByRating();
    }
    setState(() {});
  }

  void _sortRowsDefault() {
    _sortRowsBySrno(); // Default sorting by Srno
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Kabadi_walas').get();

      QuerySnapshot<Map<String, dynamic>> querySnapshot2 =
          await FirebaseFirestore.instance.collection('users').get();

      querySnapshot.docs.forEach((doc) {
        // Extract data from each document
        String srno = (doc.data()['ID'] ?? '').toString();
        String name = (doc.data()['Name'] ?? '').toString();
        String rating = (doc.data()['Rating'] ?? '').toString();
        String Contact_Number = (doc.data()['Contact_Number'] ?? '').toString();
        String mail = '';

        querySnapshot2.docs.forEach((element) {
          if (element.data()['username'] == widget.username) {
            mail = element.data()['email'];
          }
        });
        // Create DataRow and add it to _rows list
        _rows.add(
          DataRow(cells: [
            DataCell(Text(srno)),
            // DataCell(Text(id)),
            DataCell(
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    _context,
                    MaterialPageRoute(
                      builder: (context) => DealerRatePage(
                        dealerId: doc.data()['ID'].toString(),
                        username: widget.username,
                        mailID: mail,
                      ),
                    ),
                  );
                },
                child: Text(name),
              ),
            ),
            DataCell(Text(rating)),
            DataCell(Text(
              Contact_Number,
              textAlign: TextAlign.right,
            )),
          ]),
        );
      });

      _sortRowsDefault(); // Sort rows after fetching data

      setState(() {});
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
              columnSpacing: 7.0,
              columns: [
                DataColumn(
                  label: Text('Srno'.toUpperCase()),
                  numeric: true,
                  onSort: (columnIndex, _) {
                    _sortRows(columnIndex);
                  },
                ),
                DataColumn(label: Text('Name'.toUpperCase())),
                DataColumn(
                  label: Text('Rating'.toUpperCase()),
                  numeric: true,
                  onSort: (columnIndex, _) {
                    _sortRows(columnIndex);
                  },
                ),
                DataColumn(
                    label: Text('Contact_Number'.toUpperCase()), numeric: true),
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
  final String mailID;

  DealerRatePage(
      {required this.dealerId, required this.username, required this.mailID});

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

          Map<String, dynamic> rates =
              snapshot.data!.data() as Map<String, dynamic>;
          List<Map<String, dynamic>> items =
              List<Map<String, dynamic>>.from(rates['items'] ?? []);
          // Extract rate data from the document
          // Map<String, dynamic> rates =
          // snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      String itemName = (items[index].keys.first).toUpperCase();
                      dynamic itemRate = items[index].values.first;
                      String imgPath = _getImagePath(itemName);

                      return ListTile(
                        leading: imgPath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  imgPath,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover, // Use cover fit
                                ),
                              )
                            : Container(
                                width: 32, // Adjust width as needed
                                height: 32, // Adjust height as needed
                                color: Colors.grey, // Placeholder color
                                child: Icon(
                                  Icons.image, // Placeholder icon
                                  color: Colors.white, // Icon color
                                ),
                              ),
                        title: Text(
                          itemName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          itemRate.toString(),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Book appointment logic
                    bookAppointment(context, widget.dealerId, widget.mailID);
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

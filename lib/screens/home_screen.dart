import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import '../utils/sortingFunc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package

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
          DealersListPage(username: widget.username),
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
            label: 'Market Price',
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
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 124, // Set the width of the image
                    height: 124, // Set the height of the image
                    child: Image.asset(
                      imagePath, // Display the image from assets
                      fit: BoxFit.cover, // Cover the entire space
                    ),
                  ),
                  SizedBox(
                    width: 8,
                    // height: 8,
                  ), // Add some spacing between the image and text
                  Text(
                    itemName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          DataCell(Text(rate.toString())),
        ]),
      );
    });
    //     DataRow(cells: [
    //       DataCell(Text(itemName)),
    //       DataCell(Text(rate.toString())),
    //     ]),
    //   );
    // });

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

  // int _sortColumnIndex = 0;
  // bool _sortAscending = true;

  // void _sort(int columnIndex) {
  // if (columnIndex == _sortColumnIndex) {
  //   _sortAscending = !_sortAscending;
  // } else {
  //   _sortColumnIndex = columnIndex;
  //   _sortAscending = true;
  // }

  // _rows.sort(
  //   (a, b) {
  //     String aValue = a.cells[_sortColumnIndex].child.toString();
  //     String bValue = b.cells[_sortColumnIndex].child.toString();
  //     return _sortAscending
  //         ? aValue.compareTo(bValue)
  //         : bValue.compareTo(aValue);
  //   },
  // );

  // setState(() {});
  // }

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
                DataColumn(
                  label: Text('Item'),
                  numeric: false,
                  tooltip: 'Item Name',
                ),
                DataColumn(
                  label: Text('Price'),
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
        // String id = (doc.id ?? '').toString();
        // print(id);
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
                // DataColumn(label: Text('ID')),
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

  // Function to book appointment
  Future<void> bookAppointment(
      BuildContext context, String dealerId, String username) async {
    // Appointment booking logic goes here
  }
}

// Function to book appointment
Future<void> bookAppointment(
    BuildContext context, String dealerId, String username) async {
  DateTime? selectedDateTime;

  // Function to show date picker
  Future<void> _selectDateTime() async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  // Show date and time picker
  await _selectDateTime();

  if (selectedDateTime != null) {
    try {
      // Check if the appointment already exists for the same user and date & time
      QuerySnapshot<Map<String, dynamic>> existingAppointments =
          await FirebaseFirestore.instance
              .collection('Appointments')
              .where('dealerId', isEqualTo: dealerId)
              .where('userName', isEqualTo: username)
              .where('appointmentDateTime', isEqualTo: selectedDateTime)
              .get();

      if (existingAppointments.docs.isEmpty) {
        // Create a new appointment document
        await FirebaseFirestore.instance.collection('Appointments').add({
          'dealerId': dealerId, // ID of the dealer
          'userName': username, // Username of the user
          'appointmentDateTime':
              selectedDateTime, // Date & time of the appointment
          'timestamp':
              FieldValue.serverTimestamp(), // Timestamp for the appointment
        });

        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointment Booked'),
            content: Text('Your appointment has been booked successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show error message if appointment already exists
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointment Already Booked'),
            content: Text(
                'An appointment already exists for the same user and date & time.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error booking appointment: $e');
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to book appointment. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

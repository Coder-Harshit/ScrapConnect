import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TenderReleaseForm extends StatefulWidget {
  final String currentUserName;

  TenderReleaseForm({required this.currentUserName});

  @override
  _TenderReleaseFormState createState() => _TenderReleaseFormState();
}

class _TenderReleaseFormState extends State<TenderReleaseForm> {
  String? selectedItem;
  Map<String, int> itemPrices = {};
  List<Map<String, dynamic>> selectedItems = [];
  List<String> availableItems = [];

  List<Map<String, dynamic>> items = [];
  Map<int, int> finalAmt = {};
  String mailID = '';

  @override
  void initState() {
    super.initState();
    _fetchAvailableItems();
    _fetchUserEmail();
    _fetchAuctionData();
  }

  void _fetchAvailableItems() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('Default_Ratelist')
            .doc('vShDY9mv8siYe3DccWmy')
            .get();

    final data = snapshot.data();
    if (data != null) {
      setState(() {
        availableItems = data.keys.toList();
      });
    }
  }

  void _fetchUserEmail() async {
    try {
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('username', isEqualTo: widget.currentUserName)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        mailID = userSnapshot.docs.first.data()['email'] ?? '';
        print(mailID.toString());
      } else {
        print('No user found with email: ${widget.currentUserName}');
      }
    } catch (e) {
      print("Error fetching user email: $e");
    }
  }

  void _fetchAuctionData() async {
    print("User email: $mailID"); // Add this line
    try {
      DocumentSnapshot<Map<String, dynamic>> auctionSnapshot =
          await FirebaseFirestore.instance
              .collection('Tender')
              .doc(mailID)
              .get();

      if (auctionSnapshot.exists) {
        Map<String, dynamic> data = auctionSnapshot.data()!;
        if (data.containsKey('finalAmt')) {
          setState(() {
            finalAmt = Map<int, int>.from(data['finalAmt']);
          });
        }
        if (data.containsKey('items')) {
          setState(() {
            items = List<Map<String, dynamic>>.from(data['items']);
          });
        }
      } else {
        print('No auction data found for user: $mailID');
      }
    } catch (e) {
      print("Error fetching auction data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select items and enter prices:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedItem,
              decoration: InputDecoration(
                labelText: 'Select Item',
                border: OutlineInputBorder(),
              ),
              items: availableItems
                  .where((item) =>
                      !selectedItems.any((element) => element['item'] == item))
                  .map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedItem = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Price (in Rupees)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (selectedItem != null) {
                  itemPrices[selectedItem!] = int.tryParse(value) ?? 0;
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedItem != null &&
                    selectedItem!.isNotEmpty &&
                    itemPrices[selectedItem!] != null) {
                  if (selectedItems.length < 20) {
                    setState(() {
                      selectedItems.add({
                        'item': selectedItem!,
                        'price': itemPrices[selectedItem],
                      });
                      availableItems.remove(selectedItem!);
                      selectedItem = null;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Maximum of 20 items allowed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Text('Add Item'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedItems[index]['item']),
                    trailing: Text('₹ ${selectedItems[index]['price']}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedItems.length >= 2) {
                  storeItemDetails(mailID);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please add at least 2 items'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Finish'),
            ),
            SizedBox(height: 20),
            AuctionSummary(items: items, finalAmt: finalAmt),
          ],
        ),
      ),
    );
  }

  void storeItemDetails(String userEmail) async {
    try {
      CollectionReference auctionRef =
          FirebaseFirestore.instance.collection('Tender');

      // Store the selected items directly under the document ID in Firestore
      await auctionRef.doc(userEmail).set({
        'items': selectedItems,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Items added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors
      print('Error adding items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding items: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class AuctionSummary extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Map<int, int> finalAmt;

  AuctionSummary({required this.items, required this.finalAmt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Items for Auction:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title:
                    Text('${items[index]['item']} - ${items[index]['price']}'),
              );
            },
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Amounts:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: finalAmt.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Implement selection logic
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  '${finalAmt.values.toList()[index]}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Implement logic to finalize selection
          },
          child: Text('Finalize Selection'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TenderForm extends StatefulWidget {
  final String userId;

  const TenderForm({Key? key, required this.userId}) : super(key: key);

  @override
  _TenderFormState createState() => _TenderFormState();
}

class _TenderFormState extends State<TenderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  DateTime? _selectedDate;
  Map<String, dynamic>? _items;
  String mailID = '';

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
   }

  void _fetchUserEmail() async {
    try {
      print(widget.userId);
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('username', isEqualTo: widget.userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        print(userSnapshot.docs.first.data()['email'].toString());
        mailID = userSnapshot.docs.first.data()['email'] ?? '';
        print(mailID.toString());
      } else {
        print('No user found with email: ${widget.userId}');
      }
    } catch (e) {
      print("Error fetching user email: $e");
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to save data
      FirebaseFirestore.instance.collection('Auction').doc(mailID).set({
        'Auction_filldate': _selectedDate,
        'Auction_selectuserdate': _selectedDate != null ? _selectedDate!.add(Duration(days: 2)) : null,
        'title': _titleController.text,
        'finalAmt': {}, // Empty map
        'items': _items,
        'dealer_selected': 0,
      }).then((_) {
        // Data saved successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tender details saved successfully!'),
          ),
        );
      }).catchError((error) {
        // Error saving data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save tender details: $error'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tender Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DateTimePicker(
                labelText: 'Auction Fill Date',
                selectedDate: _selectedDate,
                selectDate: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addItem();
                  }
                },
                child: Text('Add Item'),
              ),
              SizedBox(height: 16),
              if (_items != null && _items!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Items:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _items!.length,
                      itemBuilder: (context, index) {
                        final item = _items!.keys.toList()[index];
                        final weight = _items![item];
                        return ListTile(
                          title: Text('Item: $item, Weight: $weight kgs'),
                        );
                      },
                    ),
                  ],
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _itemController = TextEditingController();
        final TextEditingController _weightController = TextEditingController();
        return AlertDialog(
          title: Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _itemController,
                decoration: InputDecoration(labelText: 'Item'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Weight (kgs)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the weight';
                  }
                  int weight = int.tryParse(value) ?? 0;
                  if (weight <= 10000) {
                    return 'Weight must be greater than 10000';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_itemController.text.isNotEmpty && _weightController.text.isNotEmpty) {
                  int weight = int.tryParse(_weightController.text) ?? 0;
                  if (weight > 10000) {
                    _items = {
                      _itemController.text: weight,
                    };
                    setState(() {});
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Weight must be greater than 10000 kgs'),
                      ),
                    );
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> selectDate;

  const DateTimePicker({
    Key? key,
    required this.labelText,
    required this.selectedDate,
    required this.selectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat.yMd().add_jm().format(selectedDate!)
                      : 'Select Date and Time',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
      );

      if (time != null) {
        selectDate(DateTime(picked.year, picked.month, picked.day, time.hour, time.minute));
      }
    }
  }
}

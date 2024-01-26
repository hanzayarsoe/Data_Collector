import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helper/screens/data_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<void> showAlarmDialog(
    BuildContext context, String message, bool isError) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(isError ? 'Error' : 'Success'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController myanmar = TextEditingController();
  TextEditingController myeik = TextEditingController();

  Future<void> handleSubmit() async {
    final key = myanmar.text.trim();
    final value = myeik.text.trim();
    if (key.isEmpty || value.isEmpty) {
      // Prompt the user to enter both values
      await showAlarmDialog(
          context, 'Please enter both Myanmar and Myeik', true);
      return;
    }
    try {
      // Check if the key already exists
      DocumentSnapshot doc = await firestore.collection('data').doc(key).get();
      if (doc.exists) {
        myanmar.clear();
        myeik.clear();
        // Show error dialog and return from the function
        await showAlarmDialog(
            context, 'Data with key "$key" already exists!', true);
        return;
      }

      // If the key doesn't exist, proceed with storing the data
      await firestore.collection('data').doc(key).set({'value': value});
      // Show success message with dialog
      await showAlarmDialog(context, 'Data submitted successfully!', false);
      // Clear fields and reset state
      myanmar.clear();
      myeik.clear();
    } catch (error) {
      // Show error message with dialog
      await showAlarmDialog(context, 'Error submitting data: $error', true);
    }
  }

  @override
  void initState() {
    Firebase.initializeApp()
        .whenComplete(() => debugPrint("Firebase initialized"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modern background color
      appBar: AppBar(
        leading: const Icon(Icons.folder_copy_outlined),
        title: const Text(
          "Data Converter",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: false, // Vibrant app bar color
      ),
      body: (_selectedIndex == 0)
          ? Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24), // Add padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: myanmar,
                      decoration: InputDecoration(
                        labelText: 'Myanmar',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        filled: true,
                        fillColor:
                            Colors.blue[50], // Lighter blue for text field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: myeik,
                      decoration: InputDecoration(
                        labelText: 'Myeik',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const DataList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined), label: 'Data Lists'),
        ],
        currentIndex: _selectedIndex, // Keep track of current page
        onTap: _onItemTapped,
      ),
    );
  }
}

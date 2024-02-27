import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataList extends StatefulWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  void _showEditDialog(String currentKey, String currentValue) {
    TextEditingController keyController =
        TextEditingController(text: currentKey);
    TextEditingController valueController =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: const Text(
            'Edit Data',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                enabled: false,
                style: Theme.of(context).textTheme.titleSmall,
                controller: keyController,
                decoration: const InputDecoration(helperText: 'Myanmar'),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                style: Theme.of(context).textTheme.bodySmall,
                controller: valueController,
                decoration: const InputDecoration(helperText: 'Myeik'),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                // Update data in Firestore
                FirebaseFirestore.instance
                    .collection('data')
                    .doc(currentKey)
                    .update({
                  'value': valueController.text,
                });

                Navigator.of(context).pop();
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Color.fromARGB(185, 255, 86, 34)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final dataList = snapshot.data!.docs.map((doc) {
            return MapEntry(doc.id, doc['value']);
          }).toList();

          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              MapEntry<String, dynamic> data = dataList[index];
              int currntRow = index + 1;
              return Column(
                children: [
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        '$currntRow.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ), // Leading row number
                    title: Text(
                      data.key,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        data.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    trailing: IconButton(
                      color: Theme.of(context).appBarTheme.iconTheme?.color,
                      icon: const Icon(Icons.edit_note_rounded),
                      onPressed: () {
                        _showEditDialog(data.key, data.value);
                      },
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color.fromARGB(192, 204, 62, 51),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

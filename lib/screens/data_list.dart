import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataList extends StatefulWidget {
  const DataList({super.key});

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
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
            itemCount: 1,
            itemBuilder: (context, index) {
              return DataTable(
                columns: const [
                  DataColumn(
                      label: Text(
                    'Myanmar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )),
                  DataColumn(
                    label: Text(
                      'Myeik',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
                rows: dataList
                    .map((data) => DataRow(
                          key: ValueKey(data.key),
                          cells: [
                            DataCell(Text(data.key)),
                            DataCell(Text(data.value)),
                          ],
                        ))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}

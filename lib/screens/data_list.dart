import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataList extends StatefulWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  final ScrollController _scrollController = ScrollController();
  final int _batchSize = 100;
  List<MapEntry<String, dynamic>> _dataList = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;
  int _documentCount = 0; // Document count variable

  @override
  void initState() {
    super.initState();
    _fetchData(); // Load the first batch of data
    _getDocumentCount(); // Get the total count of documents in the collection
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to fetch the total count of documents in the collection
  Future<void> _getDocumentCount() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('data').get();
    setState(() {
      _documentCount = snapshot.docs.length; // Update the document count
    });
  }

  // Function to fetch data from Firestore with pagination
  Future<void> _fetchData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('data')
        .orderBy(FieldPath.documentId)
        .limit(_batchSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        final newDataList = snapshot.docs.map((doc) {
          return MapEntry(doc.id, doc['value']);
        }).toList();

        setState(() {
          _dataList.addAll(newDataList);
        });

        // If the number of fetched documents is less than batch size, we have loaded all the data
        if (snapshot.docs.length < _batchSize) {
          _hasMoreData = false;
        }
      } else {
        _hasMoreData = false; // No more data
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Function to detect when user scrolls to the end of the list
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMoreData) {
      _fetchData();
    }
  }

  // Show edit dialog when user clicks the edit button
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
            'Total Data: $_documentCount'), // Show total document count in AppBar
        centerTitle: true,
      ),
      body: _dataList.isEmpty && !_isLoading
          ? const Center(child: Text('No data available'))
          : ListView.builder(
              controller: _scrollController,
              itemCount: _dataList.length + 1, // +1 for the loading indicator
              itemBuilder: (context, index) {
                if (index == _dataList.length) {
                  // Show a circular progress indicator at the end of the list
                  return _hasMoreData
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox(); // No more data to load
                }

                MapEntry<String, dynamic> data = _dataList[index];
                int currentRow = index + 1;

                return Column(
                  children: [
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          '$currentRow.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
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
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color.fromARGB(192, 204, 62, 51),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

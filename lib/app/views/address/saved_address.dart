import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavedAddressesScreen extends StatefulWidget {
  @override
  _SavedAddressesScreenState createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteAddress(String docId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(docId)
        .delete();
  }

  Future<void> _setDefaultAddress(String selectedDocId) async {
    final addressCollection =
        _firestore.collection('users').doc(uid).collection('addresses');

    final snapshot = await addressCollection.get();
    for (var doc in snapshot.docs) {
      await addressCollection.doc(doc.id).update({
        'isDefault': doc.id == selectedDocId,
      });
    }
  }

  void _editAddress(String docId, Map<String, dynamic> data) {
    final _address = TextEditingController(text: data['address']);
    final _city = TextEditingController(text: data['city']);
    final _pincode = TextEditingController(text: data['pincode']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Address'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _address,
                decoration: InputDecoration(hintText: 'Address')),
            TextField(
                controller: _city,
                decoration: InputDecoration(hintText: 'City')),
            TextField(
                controller: _pincode,
                decoration: InputDecoration(hintText: 'Pincode')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firestore
                  .collection('users')
                  .doc(uid)
                  .collection('addresses')
                  .doc(docId)
                  .update({
                'address': _address.text.trim(),
                'city': _city.text.trim(),
                'pincode': _pincode.text.trim(),
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAddress(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAddress(docId);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Addresses")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text('No addresses saved.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (_, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;
              final isDefault = data['isDefault'] == true;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on,
                          color: isDefault ? Colors.green : Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data['address'] ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isDefault)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Default',
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${data['city']} - ${data['pincode']}'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editAddress(id, data),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDeleteAddress(id),
                          ),
                          if (!isDefault)
                            TextButton(
                              onPressed: () => _setDefaultAddress(id),
                              child: Text(
                                "Make Default",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

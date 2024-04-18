import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NonFoodDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Item Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final itemData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(itemData['item_name']),
                subtitle: Text(itemData['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndividualItemDetailsPage(
                        itemId: snapshot.data!.docs[index].id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class IndividualItemDetailsPage extends StatelessWidget {
  final String itemId;

  IndividualItemDetailsPage({required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .doc(itemId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Item not found.'));
          }

          final itemData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    itemData['item_name'],
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  if (itemData['item_image'] != null)
                    Image.network(
                      itemData['item_image'],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 20.0),
                  Text('Date of Purchase: ${itemData['date_of_purchase']}'),
                  SizedBox(height: 10.0),
                  Text('Amount: ${itemData['amount']}'),
                  SizedBox(height: 10.0),
                  Text('Description: ${itemData['description']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

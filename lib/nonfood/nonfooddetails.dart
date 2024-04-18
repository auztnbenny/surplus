//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surplus/food/foodelaborate.dart';
import 'package:url_launcher/url_launcher.dart'; // Corrected import

class NonFoodDetailsPage extends StatelessWidget {
  Future<void> _openInGoogleMaps(double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      String googleURL =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      await canLaunch(googleURL)
          ? await launch(googleURL)
          : throw 'Could not launch $googleURL';
    } else {
      throw 'Latitude and longitude are null.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
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
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No food items found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final itemData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  // Navigate to the FoodDetailImagePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndividualItemDetailsPage(
                        itemName: itemData['item_name'],
                        description: itemData['description'],
                        dateOfPurchase: itemData['date_of_purchase'],
                        amount: itemData['amount'],
                        itemImage: itemData['item_image'],
                      ),
                    ),
                  );
                },
                child: Padding(
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
                        Text('Description: ${itemData['description']}'),
                        SizedBox(height: 10.0),
                        Text('Expiry Date: ${itemData['date_of_purchase']}'),
                        SizedBox(height: 10.0),
                        Text('Amount: ${itemData['amount']}'),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _openInGoogleMaps(
                                  itemData['latitude'], itemData['longitude']);
                            },
                            icon: Icon(Icons.map, color: Colors.white),
                            label: Text(
                              'Open in Google Maps',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                          ),
                        ),
                      ],
                    ),
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

class IndividualItemDetailsPage extends StatelessWidget {
  // final String? itemId;
  final String itemName;
  final String itemImage;
  final String dateOfPurchase;
  final String amount;
  final String description;

  IndividualItemDetailsPage({
    //required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.dateOfPurchase,
    required this.amount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Padding(
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
                itemName,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              if (itemImage.isNotEmpty)
                Image.network(
                  itemImage,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 20.0),
              Text('Date of Purchase: $dateOfPurchase'),
              SizedBox(height: 10.0),
              Text('Amount: $amount'),
              SizedBox(height: 10.0),
              Text('Description: $description'),
            ],
          ),
        ),
      ),
    );
  }
}

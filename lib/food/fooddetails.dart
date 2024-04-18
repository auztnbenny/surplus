//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surplus/food/foodelaborate.dart';
import 'package:url_launcher/url_launcher.dart'; // Corrected import

class FoodDetailsPage extends StatelessWidget {
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
        title: Text('Food Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foods').snapshots(),
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
              final foodData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  // Navigate to the FoodDetailImagePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetailImagePage(
                        foodName: foodData['food_name'],
                        description: foodData['description'],
                        expiryDate: foodData['expiry_date'],
                        kilogram: foodData['kilogram'],
                        imageUrl: foodData['image_url'],
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
                          foodData['food_name'],
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        if (foodData['image_url'] != null)
                          Image.network(
                            foodData['image_url'],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        SizedBox(height: 20.0),
                        Text('Description: ${foodData['description']}'),
                        SizedBox(height: 10.0),
                        Text('Expiry Date: ${foodData['expiry_date']}'),
                        SizedBox(height: 10.0),
                        Text('Kilogram: ${foodData['kilogram']}'),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _openInGoogleMaps(
                                  foodData['latitude'], foodData['longitude']);
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surplus/food/fooddetails.dart';
import 'package:surplus/location/mylocation.dart';
//import 'package:surplus/my_location.dart'; // Import MyLocation widget

class UserInputPage extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  UserInputPage({required this.latitude, required this.longitude});

  final foodNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final expiryDateController = TextEditingController();
  final kilogramController = TextEditingController();
  final imageController = TextEditingController(); // For food image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to MyLocation widget to get current location
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyLocation()),
                );
              },
              child: Text('Get Current Location'),
            ),
            TextFormField(
              controller: foodNameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: expiryDateController,
              decoration:
                  InputDecoration(labelText: 'Expiry Date (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: kilogramController,
              decoration: InputDecoration(labelText: 'Kilogram'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'Food Image URL'),
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Add data to Firestore
                final docRef =
                    await FirebaseFirestore.instance.collection('foods').add({
                  'food_name': foodNameController.text,
                  'description': descriptionController.text,
                  'expiry_date': expiryDateController.text,
                  'kilogram': kilogramController.text,
                  'image_url': imageController.text,
                  'latitude': latitude, // Include latitude
                  'longitude': longitude,
                });

                // Get the foodId of the newly added food

                // Navigate to FoodDetailsPage with the foodId
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FoodDetailsPage()));
              },
              child: Text('Add Food'),
            ),
          ],
        ),
      ),
    );
  }
}

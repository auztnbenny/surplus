import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:surplus/nonfood/nonfooddetails.dart';

class UserInputPagen extends StatelessWidget {
  final itemNameController = TextEditingController();
  final itemImageController = TextEditingController();
  final dateOfPurchaseController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: itemImageController,
              decoration: InputDecoration(labelText: 'Item Image URL'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: dateOfPurchaseController,
              decoration: InputDecoration(labelText: 'Date of Purchase'),
              onTap: () async {
                // Show date picker when text field is tapped
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  dateOfPurchaseController.text = pickedDate
                      .toString(); // Set selected date to the text field
                }
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Add data to Firestore
                final docRef =
                    await FirebaseFirestore.instance.collection('items').add({
                  'item_name': itemNameController.text,
                  'item_image': itemImageController.text,
                  'date_of_purchase': dateOfPurchaseController.text,
                  'amount': amountController.text,
                  'description': descriptionController.text,
                });

                // Get the itemId of the newly added item

                // Navigate to ItemDetailsPage with the itemId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NonFoodDetailsPage(),
                  ),
                );
              },
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}

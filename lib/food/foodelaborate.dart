import 'package:flutter/material.dart';

class FoodDetailImagePage extends StatelessWidget {
  final String foodName;
  final String description;
  final String expiryDate;
  final String kilogram;
  final String imageUrl;

  FoodDetailImagePage({
    required this.foodName,
    required this.description,
    required this.expiryDate,
    required this.kilogram,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Food image
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 200,
          ),
          // Food details
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  foodName,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Text('Description: $description'),
                SizedBox(height: 10.0),
                Text('Expiry Date: $expiryDate'),
                SizedBox(height: 10.0),
                Text('Kilogram: $kilogram'),
              ],
            ),
          ),
          // Button at the bottom
          ElevatedButton(
            onPressed: () {
              // Implement the button's functionality
            },
            child: Text('Button Text'),
          ),
        ],
      ),
    );
  }
}

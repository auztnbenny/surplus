import 'package:flutter/material.dart';
import 'package:surplus/food/foodinput.dart';
import 'package:surplus/nonfood/nonfood.dart';

class CustomPopup extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  CustomPopup({this.latitude, this.longitude});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Handle Food button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInputPage(
                            latitude: latitude, longitude: longitude)),
                  );
                },
                child: Text('Food'),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Handle Non-Food button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInputPagen(
                            latitude: latitude, longitude: longitude)),
                  );
                },
                child: Text('Non-Food'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

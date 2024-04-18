import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:surplus/add.dart';
import 'package:surplus/chat/chat_main.dart';
import 'package:surplus/food/fooddetails.dart';
import 'package:surplus/food/foodelaborate.dart';
import 'package:surplus/login.dart';
import 'package:surplus/nonfood/nonfooddetails.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Set to false to remove back arrow
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(height: 10.0),
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      'User',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width - 40.0,
                    color: Colors.grey[200],
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search for items...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          top: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Positioned(
            top: 120.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.green[400]!,
                    Colors.green[700]!,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 180.0,
            left: 40.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Give back,',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                Text(
                  'change lives now!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Positioned(
            top: 280.0,
            left: 40.0,
            child: ElevatedButton(
              onPressed: () {
                // Handle button press action
              },
              child: Text(
                "Share now",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                minimumSize: Size(100.0, 30.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          Positioned(
            top: 380.0,
            left: 20.0,
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 420.0,
            left: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodDetailsPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double>(3),
                  ),
                  child: Text(
                    'Food',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NonFoodDetailsPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all<double>(3),
                  ),
                  child: Text(
                    'Non-food',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 480.0,
            left: 20.0,
            right: 20.0,
            bottom: 40.0,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('foods').snapshots(),
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
                    final foodData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRect(
        child: Container(
          height: 60.0,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.home),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CustomPopup()),
                      );
                    },
                    icon: Icon(Icons.add),
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(UserListScreen());
                  },
                  icon: Icon(Icons.message),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.account_circle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

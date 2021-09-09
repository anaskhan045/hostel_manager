import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/Screens/home_page.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final String password = 'Hm @ khan 2020';
  String newPassword = '';
  bool isLoggedIn = false;
  DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> getData() async {
    List<UserData> user = await dbHelper.getUser();

    isLoggedIn = user[0].isLoggedIn == 1 ? true : false;
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141026),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome toHostel Manager',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            'Please Enter Password To Use This App',
            style: TextStyle(color: Colors.red, fontSize: 16.0),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              onChanged: (newValue) {
                newPassword = newValue;
              },
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0))),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          RaisedButton(
            color: Colors.white10,
            onPressed: () async {
              if (newPassword == password) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
                await dbHelper.updateUser(1);
              } else {
                Fluttertoast.showToast(
                    msg:
                        'Incorrect Password! Please Enter Correct password And Try Again',
                    textColor: Colors.red,
                    fontSize: 18.0,
                    gravity: ToastGravity.TOP);
              }
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hostel_manager/Screens/home_page.dart';
import 'package:hostel_manager/Screens/welcome_screen.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool isLoggedIn = false;
  bool isLoading = true;
  DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> getData() async {
    List<UserData> user = await dbHelper.getUser();
    setState(() {
      isLoggedIn = user[0].isLoggedIn == 1 ? true : false;
      isLoading = false;
    });
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
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white10),
              )
            : isLoggedIn
                ? MyHomePage()
                : WelcomeScreen(),
      ),
    );
  }
}

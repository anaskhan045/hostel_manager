import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_manager/Screens/rooms_screen.dart';
import 'package:hostel_manager/widgets/database_helper.dart';
import 'package:hostel_manager/widgets/hotel_data_sample.dart';

class AddRooms extends StatefulWidget {
  final List roomNames;
  final String sFloor;
  AddRooms({this.roomNames, this.sFloor});
  @override
  _AddRoomsState createState() => _AddRoomsState();
}

class _AddRoomsState extends State<AddRooms> {
  String newRoomName;
  int newRoomCapacity;
  String selectedFloor;
  int sFloorIndex = 0;
  List floorsList = [
    'GROUND FLOOR',
    'BASEMENT',
    '1ST FLOOR',
    '2ND FLOOR',
    '3RD FLOOR',
    '4TH FLOOR',
    '5TH FLOOR',
    '6TH FLOOR',
    '7TH FLOOR',
    '8TH FLOOR',
    '9TH FLOOR',
    '10TH FLOOR',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedFloor = widget.sFloor;
  }

  void selectFloor(int direction) {
    if (direction == 1) {
      if (sFloorIndex < floorsList.length - 1) {
        sFloorIndex = sFloorIndex + 1;
        setState(() {
          selectedFloor = floorsList[sFloorIndex];
        });
      }
    } else {
      if (sFloorIndex > 0) {
        sFloorIndex = sFloorIndex - 1;
        setState(() {
          selectedFloor = floorsList[sFloorIndex];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Color(0xff141026),
        child: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text(
                'Add New Room',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  'Room Name',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                ),
                textCapitalization: TextCapitalization.words,
                autocorrect: true,
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  newRoomName = value;
                },
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  'Capacity',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                ),
                keyboardType: TextInputType.numberWithOptions(),
                style: TextStyle(color: Colors.white, fontSize: 22.0),
                onChanged: (value) {
                  newRoomCapacity = double.parse(value).toInt();
                },
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(
                  top: 10.0,
                ),
                child: Text(
                  'Choose Floor',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        selectFloor(-1);
                      }),
                  Text(
                    selectedFloor,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        selectFloor(1);
                      }),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
                color: Colors.white10,
                onPressed: () async {
                  if (newRoomName != null && newRoomCapacity != null) {
                    if (widget.roomNames.contains(newRoomName)) {
                      Fluttertoast.showToast(
                          msg:
                              'this Room is already added to the list, please Add another room',
                          textColor: Colors.redAccent,
                          gravity: ToastGravity.TOP);
                    } else {
                      DatabaseHelper dbHelper = DatabaseHelper();
                      await dbHelper
                          .insertListToRoom(RoomData(
                        roomName: newRoomName,
                        roomCapacity: newRoomCapacity,
                        floorName: selectedFloor,
                        reserved: 0,
                      ))
                          .whenComplete(() async {
                        Navigator.of(context).pop();
                      });
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Please provide valid values',
                        textColor: Colors.redAccent,
                        gravity: ToastGravity.TOP);
                  }
                },
              ),
              TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RoomsScreen()));
                },
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xff141026),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}

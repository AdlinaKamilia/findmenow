import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:findmenow/model/user.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../MyConfig.dart';

class CheckInScreen extends StatefulWidget {
  final User user;
  const CheckInScreen({super.key, required this.user});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late double screenHeight, screenWidth;
  late Position _currentPosition;

  String currAddress = "";
  String currState = "";
  String prlat = "";
  String prlong = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Check In",
          style: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Check in now to record location info",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Icon(
                Icons.location_history,
                size: 100,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                minWidth: screenWidth / 3,
                height: 40,
                elevation: 10,
                onPressed: checkIn,
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.onError,
                child: const Text(
                  "Check-In",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  child: Column(
                children: [
                  Text("Locality: " + currAddress),
                  Text("State: " + currState),
                  Text("Latitude: " + prlat),
                  Text("Longitude: " + prlong),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  checkIn() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("In Process of Adding New Item"),
          content: LinearProgressIndicator(),
        );
      },
    );
    _determinePosition();
    String userId = widget.user.id.toString();
    String latitude = prlat;
    String longitude = prlong;
    String locality = currAddress;
    String state = currState;

    Uri uri = Uri.parse("${MyConfig().server}/location_user.php?"
        "user_id=$userId&latitude=$latitude&longitude=$longitude&locality=$locality&state=$state");

    print(uri.toString());
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Check-In Successful")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Check-In Failed")));
        }
        Navigator.pop(context);
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Check-In Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Location service are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission are denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission are permanently denied.");
    }
    _currentPosition = await Geolocator.getCurrentPosition();
    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(Position currentPosition) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    setState(() {
      currAddress = placemarks[0].locality.toString();
      currState = placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    });
    print(currAddress + " " + currState + " " + prlat + " " + prlong);
  }
}

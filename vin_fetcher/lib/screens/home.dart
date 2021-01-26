import 'package:vin_fetcher/services/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vin_fetcher/components/rounded_button.dart';

import 'package:vin_fetcher/vehicle.dart';

import 'package:vin_fetcher/screens/info.dart';
import 'package:vin_fetcher/screens/stored.dart';

String apiURL = 'http://api.carmd.com/v3.0';

NetworkHelper _networkHelper = NetworkHelper();
String _vin = "";

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text('Vehicle Fetcher',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      )),
                )
              ],
            ),
            SizedBox(height: 48.0),
            TextField(
              onChanged: (text) {
                _vin = text;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter the VIN',
                focusColor: Colors.white,
              ),
            ),
            RoundedButton(
              title: 'Lookup New Vehicle',
              color: Colors.lightBlueAccent,
              onPressed: () async {
                if (_vin.isNotEmpty) {
                  var data = await _networkHelper.getData(_vin);
                  var year = 0;
                  var make = '';
                  var model = '';
                  var manufacturer = '';
                  var engine = '';
                  var trim = '';
                  var transmission = '';
                  if (data == null) {
                    _onAlertButtonPressed(context);
                  } else {
                    if (data["data"] == null) {
                      _onAlertButtonPressed(context);
                    } else {
                      //real data

                      print(data);
                      year = data["data"]["year"];
                      make = data["data"]["make"];
                      model = data["data"]["model"];
                      manufacturer = data["data"]["manufacturer"];
                      engine = data["data"]["engine"];
                      trim = data["data"]["trim"];
                      transmission = data["data"]["transmission"];

                      //fake hard-coded data for testing
                      /*
                      _vin = "1GNALDEK9FZ108495";
                      year = 2015;
                      make = "CHEVROLET";
                      model = "EQUINOX";
                      manufacturer = "GENERAL MOTORS";
                      engine = "L4, 2.4L";
                      trim = "LTZ";
                      transmission = "AUTOMATIC";
                      */

                      print(year);
                      print(make);
                      print(model);
                      print(manufacturer);
                      print(engine);
                      print(trim);
                      print(transmission);

                      Vehicle vehicle = new Vehicle();
                      vehicle.vin = _vin;
                      vehicle.year = year;
                      vehicle.trim = trim;
                      vehicle.model = model;
                      vehicle.manufacturer = manufacturer;
                      vehicle.make = make;
                      vehicle.engine = engine;
                      vehicle.transmission = transmission;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InfoScreen(vehicle)),
                      );
                      _vin = "";
                    }
                  }
                }
              },
            ),
            RoundedButton(
              title: 'View Stored Vehicle Searches',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoredScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

_onAlertButtonPressed(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "NO VEHICLE FOUND",
    desc: "Make sure the vehicle identification number was entered correctly",
    buttons: [
      DialogButton(
        child: Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

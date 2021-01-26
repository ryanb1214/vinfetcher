import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:vin_fetcher/components/rounded_button.dart';
import 'package:flutter/rendering.dart';
import 'package:vin_fetcher/vehicle.dart';
import 'package:vin_fetcher/screens/stored.dart';

class InfoScreen extends StatefulWidget {
  InfoScreen(this.vehicle);
  final Vehicle vehicle;

  @override
  _InfoState createState() => _InfoState(vehicle);
}

class _InfoState extends State<InfoScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  _InfoState(this.vehicle);
  final Vehicle vehicle;

  @override
  void initState() {
    runTheCode();
    super.initState();
  }

  void runTheCode() async {
    await databaseHelper.getOrCreateDatabaseHandle();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Vehicle Lookup Results'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: <Widget>[
              Image(image: AssetImage('images/car.png'), width: 250),
              Align(
                alignment: Alignment.center,
                child: Text(
                    vehicle.year.toString() +
                        ' ' +
                        vehicle.make +
                        ' ' +
                        vehicle.model,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    )),
              ),
              Text(vehicle.manufacturer,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300)),
              Text(vehicle.vin,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300)),
              SizedBox(height: 40.0),
              Text('Trim: ' + vehicle.trim,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400)),
              Text('Engine: ' + vehicle.engine,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400)),
              Text('Transmission: ' + vehicle.transmission,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400)),
              SizedBox(height: 40.0),
              RoundedButton(
                title: 'Store Vehicle',
                color: Colors.blueAccent,
                onPressed: () async {
                  await databaseHelper.insertVehicle(vehicle);
                  _onAlertButtonPressed(context);
                  print("Sucessfully stored");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
    _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "VEHICLE STORED",
      desc:
          "Vehicle was successfully stored, go to the stored vehicles screen to view stored data",
      buttons: [
        DialogButton(
          child: Text(
            "Go to screen",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoredScreen())),
          width: 120,
        )
      ],
    ).show();
  }
}


class DatabaseHelper {
  sqflitePackage.Database db;

  Future<void> getOrCreateDatabaseHandle() async {
    var databasesPath = await sqflitePackage.getDatabasesPath();
    var path = pathPackage.join(databasesPath, 'vehicles.db');
    print('$path');
    db = await sqflitePackage.openDatabase(
      path,
      onCreate: (sqflitePackage.Database db1, int version) async {
        await db1.execute(
          "CREATE TABLE vehicles(vin TEXT PRIMARY KEY, year INTEGER, make TEXT, model TEXT, manufacturer TEXT, engine TEXT, trim TEXT, transmission TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertVehicle(Vehicle vehicle) async {
    await db.insert(
      'vehicles',
      vehicle.toMap(),
      conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace,
    );
  } //close databasehelper
}


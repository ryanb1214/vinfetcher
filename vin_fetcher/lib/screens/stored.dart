import 'package:flutter/material.dart';
import 'dart:async';

import 'package:vin_fetcher/vehicle_list.dart';
import 'package:vin_fetcher/vehicle.dart';

import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqflite.dart' as sqflitePackage;

class StoredScreen extends StatefulWidget {
  StoredScreen({
    Key key,
  }) : super(key: key);

  @override
  _StoredState createState() => _StoredState();
}

class _StoredState extends State<StoredScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Vehicle> _vehicleList = List<Vehicle>();

  @override
  void initState() {
    super.initState();
    runTheCode();
  }

  void runTheCode() async {
    await databaseHelper.getOrCreateDatabaseHandle();
    _vehicleList = await getList();
    setState((){
    });
  }

  Future getList() async{
    var list = await databaseHelper.vehicle();
    return list;
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Stored Vehicles'),
      ),
      body: new Container(
        child: new Center(
          child: new VehicleList(vehicles: _vehicleList),
        ),
      ),
    );
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

  Future<List<Vehicle>> vehicle() async {
    final List<Map<String, dynamic>> maps = await db.query('vehicles');
    return List.generate(maps.length, (i) {
      return Vehicle(
        vin: maps[i]['vin'],
        year: maps[i]['year'],
        make: maps[i]['make'],
        model: maps[i]['model'],
        manufacturer: maps[i]['manufacturer'],
        engine: maps[i]['engine'],
        trim: maps[i]['trim'],
        transmission: maps[i]['transmission'],
      );
    });
  }
}

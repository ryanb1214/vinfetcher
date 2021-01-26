import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'vehicle.dart';

class VehicleList extends StatefulWidget {
  VehicleList({Key key, this.vehicles}) : super(key: key);

  final List<Vehicle> vehicles;

  @override
  State<StatefulWidget> createState() {
    return new _VehicleListState();
  }
}

class _VehicleListState extends State<VehicleList> {
  @override
  Widget build(BuildContext context) {
    return _buildVehicleList(context, widget.vehicles);
  }

  ListView _buildVehicleList(context, List<Vehicle> vehicles) {
    return new ListView.builder(
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text('${vehicles[index].year} ${vehicles[index].make} ${vehicles[index].model}'),
            trailing: Text('${vehicles[index].trim}, ${vehicles[index].engine}, ${vehicles[index].transmission}'),
            subtitle: Text('VIN: ${vehicles[index].vin ?? "VIN not found"}'));
      },
    );
  }
}
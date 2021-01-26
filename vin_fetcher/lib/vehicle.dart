  class Vehicle
  {
    String vin;
    int year;
    String make;
    String model;
    String manufacturer;
    String engine;
    String trim;
    String transmission;

    Vehicle({this.vin, this.year, this.make, this.model, this.manufacturer, this.engine, this.trim, this.transmission});

    Map<String, dynamic> toMap()
    {
      return
      {
      'vin': vin,
      'year': year,
      'make': make,
      'model': model,
      'manufacturer': manufacturer,
      'engine': engine,
      'trim': trim,
      'transmission': transmission
      };
    }
  }          
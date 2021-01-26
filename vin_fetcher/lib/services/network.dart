import 'package:http/http.dart' as http;
import 'dart:convert';

String partnerToken = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
String authKey = 'Basic XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';

class NetworkHelper {
  Future getData(String vin) async {
    print('Vehicle Identification Number supplied = $vin');

    String url = 'http://api.carmd.com/v3.0/decode?vin=$vin';
    http.Response response = await http.get(url, headers: {
      "content-type": "application/json",
      "authorization": authKey,
      "partner-token": partnerToken
    });
    if (response.statusCode == 200) {
      String data = response.body;
      print(response.statusCode);
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

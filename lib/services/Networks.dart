import 'dart:convert';

import 'package:http/http.dart' as http;


class Networks{
  static String apiurl ="http://localhost:8080/api/Students/";


  static Future<bool> loginandgetUserData(String email) async{
    http.Response response = await http.get(apiurl+email);
    print(response.body);
    print("found data");
    var data = response.body;
    print(data);
    var myjson = jsonDecode(data);
    print(myjson);

    return true;

  }
}
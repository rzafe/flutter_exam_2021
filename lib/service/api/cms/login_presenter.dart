
import 'dart:convert';

import 'package:flutter_exam_2021/model/api_result.dart';
import 'package:http/http.dart' as http;

class LoginPresentation {

  Future postLoginAPI(String mobileNo, String password) async {
    final String baseUrl = 'https://stable-api.pricelocq.com/mobile/v2/sessions';
    final http.Response response = await http.post(Uri.parse(baseUrl),
      body: jsonEncode(<String, dynamic>{
        'mobile': mobileNo,//'09021234567',
        'password': password,//'123456',
      }),);

    try {
      return APIResult.fromMap(jsonDecode(response.body));
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }

    // if (response.statusCode == 200) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    //   print(response.body);
    //   return response.body;
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    //   throw Exception('Failed to load album');
    // }
  }

}

import 'dart:convert';

import 'package:flutter_exam_2021/model/station.dart';
import 'package:http/http.dart' as http;

class StationPresenter {

  Future<List<Station>> getStationListAPI(String accessToken) async {
    final String baseUrl = 'https://stable-api.pricelocq.com/mobile/stations?all';
    final http.Response response = await http.get(Uri.parse(baseUrl),
      headers: <String, String>{'Authorization': accessToken},
      /*body: jsonEncode(<String, dynamic>{
        'mobile': '09021234567',
        'password': '123456',
      }),*/);

    List<Station> stationList = <Station>[];

    try {
      final List<dynamic> jsonDataList = jsonDecode(response.body)['data'] as List<dynamic>;
      stationList = jsonDataList.map((dynamic data) => Station.fromMap(data)).toList();

      return stationList;
    } on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }
  }

}
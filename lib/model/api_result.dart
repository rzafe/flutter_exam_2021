import 'package:flutter/material.dart';

class APIResult {
  String? status;
  dynamic result;

  APIResult({this.status, this.result});

  factory APIResult.fromMap(Map<String, dynamic> json) => APIResult(
      status: json["status"],
      result: json["data"],
  );

  @override
  String toString() {
    return 'APIResult{status: $status, result: $result}';
  }
}








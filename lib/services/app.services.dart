import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';

class AppServices {
  final endPoint = serverHost();

  Future<String> post(Map<String, String> headers, Object body) async {
    final Response response = await http.post(
        Uri.parse(this.endPoint), headers: headers, body: body, encoding: Encoding.getByName("latin1"));

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['status'] == true) {
      return json['data'];
    } else {
      throw Exception(json['message']);
    }
  }

  Future<String> put(Map<String, String> headers, Object body) async {
    final Response response = await http.put(
        Uri.parse(this.endPoint), headers: headers, body: body, encoding: Encoding.getByName("latin1"));

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['status'] == true) {
      return json['data'];
    } else {
      throw Exception(json['message']);
    }
  }

  Future<String> get(Map<String, String> headers, {Object filter}) async {
    final Response response = await http.get(Uri.parse(
        this.endPoint + "&filtro=" + base64.encode(utf8.encode(filter))),
        headers: headers);

    if(response.statusCode > 299){
      throw Exception(response.body);
    }

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['status'] == true) {
      return jsonEncode(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }

  Future<String> delete(Map<String, String> headers, Object body) async {
    final Response response = await http.delete(
        Uri.parse(this.endPoint), headers: headers, body: body, encoding: Encoding.getByName("latin1"));

    Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode == 200 && json['status'] == true) {
      return json['data'];
    } else {
      throw Exception(json['message']);
    }
  }

}

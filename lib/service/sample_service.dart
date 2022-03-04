import 'dart:convert';

import 'package:access_token_service/model/outlet.dart';
import 'package:http/http.dart' as http;

Future<List<Outlet>> fetchOutlets(String idToken) async {
  final response = await http.get(
    Uri.parse('https://api.hfcapp.techilasoftware.com/v1/outlet/all'),
    headers: <String, String>{'Authorization': idToken},
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Outlet.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error!');
  }
}

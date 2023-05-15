import 'dart:async';
import 'dart:io'; //InternetAddress utility

import 'package:http/http.dart' as http;

import '../helpers/api.dart';

class Network {
  static Future<bool> check() async {
    try {
      await http.get(Uri.parse(Api.url + 'status'));

      return true;
    } on SocketException catch (_) {
      return false;
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../constants/app_constants.dart';
import '/models/update.dart';

import 'package:http/http.dart' as http;

Future checkForUpdate(String api) async {
  UpdateChecker updateChecker;
  try {
    var res = await retryOptions.retry(
      (() => http.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = jsonDecode(res.body);
    updateChecker = UpdateChecker.fromJson(decodeRes);
  } finally {
    client.close();
  }
  return updateChecker;
}

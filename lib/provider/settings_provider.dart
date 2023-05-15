import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../constants/api_constants.dart';

class SettingsProvider with ChangeNotifier {

  bool _isAdult = false;
  bool get isAdult => _isAdult;

  bool _isMaterial3Enabled = false;
  bool get isMaterial3Enabled => _isMaterial3Enabled;

  bool _darktheme = false;
  bool get darktheme => _darktheme;

  int _defaultValue = 0;
  int get defaultValue => _defaultValue;

  String _imageQuality = "w500/";
  String get imageQuality => _imageQuality;

  String _defaultCountry = 'US';
  String get defaultCountry => _defaultCountry;

  String _defaultView = 'list';
  String get defaultView => _defaultView;

  Mixpanel mixpanel;

  // mixpanel
  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init(mixpanelKey,
        optOutTrackingDefault: false, trackAutomaticEvents: true);
    notifyListeners();
  }

}

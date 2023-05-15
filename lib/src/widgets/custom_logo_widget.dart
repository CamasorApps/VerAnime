import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../helpers/api.dart';
import '../helpers/screen.dart';
import '../providers/settings_provider.dart';

class CustomLogo extends StatefulWidget {
  @override
  _CustomLogoState createState() => _CustomLogoState();
}

class _CustomLogoState extends State<CustomLogo>
    with AutomaticKeepAliveClientMixin<CustomLogo> {
  final SettingsProvider settingsProvider = SettingsProvider();
  Future<String> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _future = settingsProvider.logoType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }
        if (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.data == 'svg') {
          return SizedBox(
            height: Screen.logoSize(context),
            child: FutureBuilder<Uint8List>(
              future: http
                  .get(Uri.parse(Api.url + 'image/logo'))
                  .then((response) => response.bodyBytes),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return SvgPicture.memory(
                    snapshot.data,
                    height: Screen.logoSize(context),
                  );
                }
                return SizedBox(
                  height: Screen.logoSize(context),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          );
        } else {
          return Image(
            image: AdvancedNetworkImage(Api.url + 'image/logo',
                useDiskCache: true),
            height: Screen.logoSize(context),
          );
        }
      },
    );
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../providers/livetv_provider.dart';
import '../providers/movies_provider.dart';
import '../providers/series_provider.dart';

class Notifications {
  static final _moviesProvider = MoviesProvider();
  static final _seriesProvider = SeriesProvider();
  static final _livetvProvider = LivetvProvider();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static init(GlobalKey<NavigatorState> navigatorKey) async {
    //requesting permissions to the device to receive push notifications
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // subscribe all customers to a topic to send global notifications.
    _firebaseMessaging.subscribeToTopic('all');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;
      if (data['instanceof'] == 'movie') {
        _moviesProvider.show(data['id'].toString()).then((movie) => {
              movie.uniqueId = '${movie.id}-' + 'onMessage',
              navigatorKey.currentState
                  .pushNamed('movie.detail', arguments: movie)
            });
      }
      if (data['instanceof'] == 'serie') {
        _seriesProvider.show(data['id'].toString()).then((serie) => {
              serie.uniqueId = '${serie.id}-' + 'onMessage',
              navigatorKey.currentState
                  .pushNamed('serie.detail', arguments: serie)
            });
      }
      if (data['instanceof'] == 'livetv') {
        _livetvProvider.show(data['id'].toString()).then((livetv) => {
              livetv.uniqueId = '${livetv.id}-' + 'onMessage',
              navigatorKey.currentState
                  .pushNamed('livetv.detail', arguments: livetv)
            });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final data = message.data;
      if (data['instanceof'] == 'movie') {
        _moviesProvider.show(data['id'].toString()).then((movie) => {
              movie.uniqueId = '${movie.id}-' + 'onResume',
              navigatorKey.currentState
                  .pushNamed('movie.detail', arguments: movie)
            });
      }
      if (data['instanceof'] == 'serie') {
        _seriesProvider.show(data['id'].toString()).then((serie) => {
              serie.uniqueId = '${serie.id}-' + 'onResume',
              navigatorKey.currentState
                  .pushNamed('serie.detail', arguments: serie)
            });
      }
      if (data['instanceof'] == 'livetv') {
        _livetvProvider.show(data['id'].toString()).then((livetv) => {
              livetv.uniqueId = '${livetv.id}-' + 'onResume',
              navigatorKey.currentState
                  .pushNamed('livetv.detail', arguments: livetv)
            });
      }
    });
  }
}

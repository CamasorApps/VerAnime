import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../helpers/lang.dart';
import '../helpers/network.dart';
import '../helpers/screen.dart';
import '../helpers/search.dart';
import '../models/settings_model.dart';
import '../views/browser_view.dart';
import '../views/index_view.dart';
import '../views/kids_view.dart';
import '../views/livetv_view.dart';
import '../views/movies_view.dart';
import '../views/series_view.dart';
import '../widgets/custom_logo_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import '/screens/common/update_screen.dart';
// HomeView is the widget that contains all the main views,
// displaying them within the scaffold controlled by the _body method

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  AnimationController _animationController;
  Animation<Offset> _animation;
  DateTime currentBackPressTime;
  int _currentTab = 0;
  final List<Widget> _listTabs = [
    IndexView(),
    BrowserView(),
    MoviesView(),
    SeriesView(),
    KidsView(),
    LivetvView()
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _listTabs.length);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0))
        .animate(CurvedAnimation(
            curve: Curves.easeOut, parent: _animationController));
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context);
    // Check the network, if there is no connection it shows a snackbar.
    Network.check().then((onValue) => {
          if (!onValue)
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(Lang.noNetwork)))
        });

    return WillPopScope(
      onWillPop: () => _willPopCallback(context),
      child: Scaffold(
        key: _scaffoldkey,
        body: Stack(
          children: [
            NotificationListener<UserScrollNotification>(
              child: TabBarView(
                  children: _listTabs,
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics()),
              onNotification: (UserScrollNotification notification) {
                if (settings.appBarAnimation) {
                  if (notification.direction == ScrollDirection.reverse &&
                      notification.metrics.extentAfter > kToolbarHeight &&
                      notification.metrics.axis == Axis.vertical) {
                    _animationController.forward();
                  } else if (notification.direction ==
                      ScrollDirection.forward) {
                    _animationController.reverse();
                  }
                }
                return true;
              },
            ),
            _appbar(context)
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar(settings),
      ),
    );
  }

// custom application menu, contains the logo in image or vector according to the option of settings and the iconbutton that run the search method.
  Widget _appbar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      width: Screen.width(context),
      child: SlideTransition(
        position: _animation,
        child: AppBar(
          titleSpacing: 10.0,
          title: Container(child: CustomLogo()),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.build),
                onPressed: () {
                  _detailDialogSocial1(context);
                }
            ),
            IconButton(
                icon: Icon(Icons.feedback),
                onPressed: () {
                  _detailDialogSocial(context);
                }
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
            ),
          ],
        ),
      ),
    );
  }

//Grupo de Telegram
  _launchURLTelegram() async {
    const url = 'https://t.me/VPSOF';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo obtener el enlace $url';
    }
  }

  //Pagina de Facebook
  _launchURLFacebook() async {
    const url = 'https://www.facebook.com/VerPeliculasOficial/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo obtener el enlace $url';
    }
  }

  //Instagram
  _launchURLInstagram() async {
    const url = 'https://www.instagram.com/ver.peliculas/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo obtener el enlace $url';
    }
  }

  //Sitio web
  _launchURLSitioWeb() async {
    const url = 'https://veranime-9ec01.web.app/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo obtener el enlace $url';
    }
  }

  //VerAnime
  _launchURLVerAnime() async {
    const url = 'https://verpeliculas.ml/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo obtener el enlace $url';
    }
  }

  //Invita un cafe a los desarrolladores
  void _detailDialogSocial(BuildContext context) {

    showDialog(

        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Soporte mediante:'),
            content: new Text('Les recomendamos seguirnos en nuestras redes sociales para estar al pendiente de noticias y actualizaciones de la app'),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Facebook"),
                style : ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: _launchURLFacebook,
              ),
              ElevatedButton(
                child: Text("Instagram"),
                style : ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: _launchURLInstagram,
              ),
              ElevatedButton(
                child: Text("Telegram"),
                style : ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: _launchURLTelegram,
              ),
            ],
          );
        }
    );
  }

  //Invita un cafe a los desarrolladores
  void _detailDialogSocial1(BuildContext context) {

    showDialog(

        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Sitio Web:'),
            content: new Text('Desde nuestro sitio web podran descargar la ultima version de la app y futuras actualizaciones. '
                'Contamos con diferentes opciones para que elijas la de tu preferencia... '
                'Verifica que tienes la ultima version de la app: 1.7.5. '),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Sitio Web"),
                style : ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: _launchURLSitioWeb,
              ),
           /*   ElevatedButton(
                child: Text("VerPeliculas"),
                style : ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: _launchURLVerAnime,
              ), */
              ElevatedButton(
                child: Text("Comprobar si hay una actualicación"),
                style : ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                        return const UpdateScreen();
                      })));
                },
              ),
            ],
          );
        }
    );
  }

// bottom navigation bar, when selecting, assign the index of the item to the _currentTab property. The _body method receives this property as an argument.
  Widget _bottomNavigationBar(Settings settings) {
    return BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
            _tabController.animateTo(_currentTab);
            _animationController.reverse();
          });
        },
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: Lang.home),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: Lang.browser),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: Lang.movies),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: Lang.series),
          if (settings.kids)
            BottomNavigationBarItem(
                icon: Icon(Icons.child_care), label: Lang.kids),
          if (settings.livetv)
            BottomNavigationBarItem(
                icon: Icon(Icons.live_tv), label: Lang.livetv)
        ]);
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    DateTime now = DateTime.now();
    if (_currentTab != 1) {
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 4)) {
        currentBackPressTime = now;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(Lang.exit)));
        return Future.value(false);
      }
    }
    return Future.value(true);
  }
}

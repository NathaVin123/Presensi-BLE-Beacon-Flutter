import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presensiblebeacon/UI/Login/LoginWidgets/LoginDosen.dart';
import 'package:presensiblebeacon/UI/Login/LoginWidgets/LoginMahasiswa.dart';
import 'package:presensiblebeacon/utils/bubble_indicator_painter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        body: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Color.fromRGBO(23, 75, 137, 1)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 75.0, bottom: 20),
                  child: Image(
                      height: MediaQuery.of(context).size.height > 800
                          ? 150.0
                          : 120,
                      fit: BoxFit.fill,
                      image: const AssetImage(
                          'assets/png/SplashPage_LogoAtmaJaya.png')),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Center(
                    child: Text('Sistem Presensi UAJY',
                        style: const TextStyle(
                            fontFamily: 'WorkSansMedium',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (int i) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const LoginMahasiswa(),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const LoginDosen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        // color: Color(0x552B2B2B),
        color: Color.fromRGBO(247, 180, 7, 1),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              offset: Offset(0, 10),
              blurRadius: 10)
        ],
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onLoginMahasiswaButtonPress,
                child: Text(
                  'MAHASISWA',
                  style: TextStyle(
                      color: left,
                      fontSize: 17.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onLoginDosenButtonPress,
                child: Text(
                  'DOSEN',
                  style: TextStyle(
                      color: right,
                      fontSize: 17.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginMahasiswaButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
  }

  void _onLoginDosenButtonPress() {
    _pageController?.animateToPage(1,
        duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
  }
}

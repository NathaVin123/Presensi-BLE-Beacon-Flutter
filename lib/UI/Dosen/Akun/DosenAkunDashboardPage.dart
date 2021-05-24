import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/UI/Login/LoginPage.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:presensiblebeacon/MODEL/LoginDosenModel.dart';

class DosenAkunDashboardPage extends StatefulWidget {
  DosenAkunDashboardPage({Key key}) : super(key: key);

  @override
  _DosenAkunDashboardPageState createState() => _DosenAkunDashboardPageState();
}

class _DosenAkunDashboardPageState extends State<DosenAkunDashboardPage> {
  LoginDosenRequestModel loginDosenRequestModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Akun'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              onPressed: () {
                Get.offAll(LoginPage());
              },
            )
          ],
        ),
        body: Container(
            child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'person-male'.png,
                  height: 150.0,
                  width: 100.0,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(''),
            )
          ],
        )),
      ),
    );
  }
}

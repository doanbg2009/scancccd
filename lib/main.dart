import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scancccd/page/qr_create_page.dart';
import 'package:scancccd/page/qr_photo_page.dart';
import 'package:scancccd/page/qr_scan_page.dart';
import 'package:scancccd/page/qr_scan_setting.dart';
import 'package:scancccd/widget/button_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'SCAN CĂN CƯỚC CÔNG DÂN';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(
      primaryColor: Colors.green,
      //scaffoldBackgroundColor: Colors.limeAccent,
    ),
    home: MainPage(title: title),
  );
}

class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget(
            text: 'Tạo QR Code',
            onClicked: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => QRCreatePage(),
            )),
          ),
          const SizedBox(height: 32),
          ButtonWidget(
            text: 'Scan QR Code',
            onClicked: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => QRScanPage(),
            )),
          ),
          const SizedBox(height: 32),
          ButtonWidget(
            text: 'Chụp CMT/CCCD',
            onClicked: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => QRPhotoPage(),
            )),
          ),
          const SizedBox(height: 32),
          ButtonWidget(
            text: 'Setting',
            onClicked: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SettingPage(),
            )),
          ),
          const SizedBox(height: 32),
          Text("Tác giả: Nguyễn Trọng Đoán. ĐT: 0913387028\nAgribank chi nhánh tỉnh Bắc Giang",style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold
          ),
              textAlign: TextAlign.center
          )
        ],
      ),
    ),
  );
}
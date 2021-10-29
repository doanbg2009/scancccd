import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scancccd/page/qr_scan_setting.dart';
import 'package:scancccd/widget/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = '';
  String ipAddress = '';
  String port = '';

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }
  //Loading thamso on start
  void _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress = (prefs.getString('IpAddress') ?? "192.168.1.13");
      port = (prefs.getString('Port') ?? "8080");
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(MyApp.title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Scan căn cước công dân',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'For Agribank',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
          SizedBox(height: 32),
          ButtonWidget(
            text: 'Bắt đầu QR Scan',
            onClicked: () => scanQRCode(),
          ),
          // ButtonWidget(
          //   text: 'Setting',
          //   onClicked: () => Navigator.of(context).push(MaterialPageRoute(
          //     builder: (BuildContext context) => SettingPage(),
          //   )),
          // ),
          // const SizedBox(height: 32),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Text(
              '$qrCode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          Text("Tác giả: Nguyễn Trọng Đoán. ĐT: 0913387028\nAgribank chi nhánh tỉnh Bắc Giang",
              style: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold
            ),
          textAlign: TextAlign.center
          ),
        ],
      ),
    ),
  );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      setState(()  {
        this.qrCode = qrCode;
      });
      setState(() async {
        //this.qrCode = qrCode;
        //Socket socket = await Socket.connect('192.168.1.13', 8080);
        Socket socket = await Socket.connect(ipAddress, 8080);
        // listen to the received data event stream
        // socket.listen((List<int> event) {
        //   //print(utf8.decode(event));
        // });
        socket.add(utf8.encode('Tel\$'+qrCode+'\$123'));
        // wait 5 seconds
        //await Future.delayed(Duration(seconds: 5));
        socket.close();
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

}
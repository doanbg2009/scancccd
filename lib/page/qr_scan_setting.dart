import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scancccd/page/qr_scan_page.dart';
import 'package:scancccd/widget/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  //String qrCode = 'For Agribank';
  String ipAddress = '';
  String port = '';
  double maxWidth=500;
  double maxHeight=800;
  int imageQuality=100;
  final myIpController = TextEditingController();
  final myPortController = TextEditingController();
  final myMaxWidthController = TextEditingController();
  final myMaxHeightController = TextEditingController();
  final myImageQualityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSetting();
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myIpController.dispose();
    myPortController.dispose();
    myMaxWidthController.dispose();
    myMaxHeightController.dispose();
    myImageQualityController.dispose();
    super.dispose();
  }

  //Loading thamso on start
  void _loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress = (prefs.getString('IpAddress') ?? "192.168.1.13");
      port = (prefs.getString('Port') ?? "8080");
      maxWidth = (prefs.getDouble('MaxWidth') ?? 500);
      maxHeight = (prefs.getDouble('MaxHeight') ?? 800);
      imageQuality = (prefs.getInt('MageQuality') ?? 100);

      myIpController.text=ipAddress;
      myPortController.text=port;
      myMaxWidthController.text=maxWidth.toString();
      myMaxHeightController.text=maxHeight.toString();
      myImageQualityController.text=imageQuality.toString();
    });
  }
  //Save thamso after click
  void _saveSetting(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ipAddress=myIpController.text.trim();
      port=myPortController.text.trim();
      maxWidth= double.parse(myPortController.text) ;
      maxHeight=double.parse(myMaxHeightController.text);
      imageQuality=int.parse(myImageQualityController.text);

      //_counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setString('IpAddress', ipAddress);
      prefs.setString('Port', port);
    });
    Navigator.of(context).pop();
    // final result = await Navigator.push(
    //   context,
    //   // Create the SelectionScreen in the next step.
    //   MaterialPageRoute(builder: (context) => MainPage()),
    // );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(MyApp.title),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: myIpController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  labelText: 'IP Address'
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: myPortController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  labelText: 'Port'
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: myMaxWidthController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  labelText: 'MaxWidth'
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: myMaxHeightController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  labelText: 'MaxHeight'
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: myImageQualityController,
              style: TextStyle(color: Colors.red),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  labelText: 'ImageQuality'
              ),
            ),
            const SizedBox(height: 10),
            FlatButton(
                onPressed: (){
                  _saveSetting(context);
                },
                child: Text('SAVE SETTING',style: const TextStyle(fontSize: 18),),
                height: 50,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                color: Theme.of(context).primaryColor, //Colors.pinkAccent,
                textColor: Colors.white
            ),
          ]
      ),
    )
  );

}
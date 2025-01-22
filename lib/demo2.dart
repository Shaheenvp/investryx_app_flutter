import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class DeviceInfoExample extends StatefulWidget {
  @override
  _DeviceInfoExampleState createState() => _DeviceInfoExampleState();
}

class _DeviceInfoExampleState extends State<DeviceInfoExample> {
  String? _deviceName;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    _getDeviceName();
  }

  Future<void> _getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceName = androidInfo.model; // e.g., "Pixel 6"
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceName = iosInfo.name; // e.g., "iPhone 13"
        });
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        setState(() {
          _deviceName = linuxInfo.prettyName;
        });
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
        setState(() {
          _deviceName = macOsInfo.computerName;
        });
      } else if (Platform.isWindows) {
        WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        setState(() {
          _deviceName = windowsInfo.computerName;
        });
      }
    } catch (e) {
      print('Error getting device name: $e');
      setState(() {
        _deviceName = 'Unknown Device';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Info Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Device Name:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _deviceName ?? 'Loading...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
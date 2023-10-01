import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  String deviceId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getDeviceId();
  }

  Future<void> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceId = androidInfo.androidId;
      });
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceId = iosInfo.identifierForVendor;
      });
    } else if (Theme.of(context).platform == TargetPlatform.windows) {
      // Fügen Sie hier Ihren Code für die Windows-Plattform hinzu
      // Beispielcode (Windows-Plattform-ID wird hier generiert, dies kann je nach Windows-Version unterschiedlich sein)
      setState(() {
        deviceId = 'windows_device_id';
      });
    } else {
      // Plattform nicht erkannt
      setState(() {
        deviceId = 'unknown_device';
      });
    }

    debugPrint('Device ID: $deviceId');
  }

  Future<void> _sendRateRequest() async {
    final url = Uri.parse('"https://data.ingoapp.at/rate');
    final response = await http.post(
      url,
      body: {'deviceId': deviceId},
    );

    if (response.statusCode == 200) {
      // Rateversuch erfolgreich
      print('Rateversuch erfolgreich.');
    } else {
      // Rateversuch fehlgeschlagen
      print('Rateversuch fehlgeschlagen.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      body: Center(
        child: GestureDetector(
          // onTap: () => _sendRateRequest(),
          child: Text('Challenge'),
        ),
      ),
    );
  }
}

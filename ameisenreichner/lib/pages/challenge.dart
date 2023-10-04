import 'package:ameisenreichner/constants/values.dart';
import 'package:ameisenreichner/models/challengeItem.dart';
import 'package:ameisenreichner/models/guess.dart';
import 'package:ameisenreichner/pages/counter.dart';
import 'package:ameisenreichner/widgets/guessPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'dart:html' as html;

import '../widgets/leaderboard.dart';

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  String deviceId = "";
  ChallengeItem? todaysChallenge;
  List<Guess> guesses = [];
  late Future<Widget> finalWidget;

  void loadChallenge() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString("${AppValues.assetString}challenges.json");
    setState(() {
      todaysChallenge = getCurrentChallenge(loadChallengesFromJson(jsonString));
    });
    debugPrint("challenge loaded");
  }

  @override
  void initState() {
    super.initState();
    finalWidget = reactToStatusCode();
    loadChallenge();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getGuidFromLocalStorage();
  }

  // Future<void> _getDeviceId() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Theme.of(context).platform == TargetPlatform.android) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     debugPrint("android serialnumber: ${androidInfo.serialNumber}");
  //     debugPrint("android version: ${androidInfo.version}");
  //     debugPrint("android fingerprint: ${androidInfo.fingerprint}");
  //     debugPrint("android data: ${androidInfo.data}");
  //     debugPrint("android: ${androidInfo}");
  //     setState(() {
  //       deviceId = "android";
  //     });
  //   } else if (Theme.of(context).platform == TargetPlatform.iOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     setState(() {
  //       deviceId = "ios";
  //     });
  //   } else if (Theme.of(context).platform == TargetPlatform.windows) {
  //     setState(() {
  //       deviceId = 'test5'; //'windows_device_id';
  //     });
  //   } else {
  //     // Plattform nicht erkannt
  //     setState(() {
  //       deviceId = 'unknown_device';
  //     });
  //   }

  //   debugPrint('Device ID: $deviceId');
  // }

  void _getGuidFromLocalStorage() {
    final storedGuid = html.window.localStorage['guid'];
    if (storedGuid != null) {
      setState(() {
        deviceId = storedGuid;
      });
    } else {
      // Wenn keine GUID im localStorage gefunden wurde, generiere eine neue
      final newGuid = const Uuid().v4();
      // Speichern Sie die neue GUID im localStorage
      html.window.localStorage['guid'] = newGuid;
      setState(() {
        deviceId = newGuid;
      });
    }

    debugPrint('Device ID: $deviceId');
  }

  Future<int> _checkIfGuessAllowed() async {
    try {
      //await _getDeviceId();
      var response =
          await Dio().get('https://data.ingoapp.at/rate/${deviceId}');
      debugPrint(response.statusCode.toString());
      //${deviceId}');
      return response.statusCode ?? 0;
    } on DioException catch (dioError) {
      debugPrint(dioError.toString());
      if (dioError.response != null) {
        switch (dioError.response!.statusCode) {
          case 500:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Es ist ein Fehler aufgetreten.'),
              ),
            );
          default:
            debugPrint(
                'error: ${dioError.response!.statusCode} - Something went wrong while trying to connect with the server');
            break;
        }
        return dioError.response!.statusCode ?? 0;
      }
    } catch (e) {
      debugPrint('error: Something went wrong : $e');
      return 0;
    }
    return 0;
  }

  Future<Widget> reactToStatusCode() async {
    int code = await _checkIfGuessAllowed();
    if (todaysChallenge == null) {
      return const Center(
        child: Text(
            "Heute leider keine Challenge verfügbar, versuche es morgen wieder!"),
      );
    }
    switch (code) {
      case 204:
        //Darf noch raten
        return GuessPage(
          todaysChallenge: todaysChallenge!,
          isGuessAllowed: true,
          device_id: deviceId,
        );
      case 202:
        //Rangliste berechnen
        var response =
            await Dio().get('https://data.ingoapp.at/rate/${deviceId}');
        for (var guess in response.data['guesses']) {
          guesses.add(Guess(
              device_id: "",
              guess: (calcAnts(todaysChallenge!.weight.toString()) -
                      int.parse(guess.toString()))
                  .abs()));
        }
        guesses.add(Guess(
            device_id: response.data['deviceId'],
            guess: (calcAnts(todaysChallenge!.weight.toString()) -
                    int.parse(response.data['ownguess'].toString()))
                .abs()));
        guesses.sort((a, b) => a.guess.compareTo(b.guess));
        //get index of guess with deviceId
        int place =
            guesses.indexWhere((element) => element.device_id == deviceId);

        guesses.clear();
        return Leaderboard(
          hasGuessed: true,
          place: place,
          todaysChallenge: todaysChallenge!,
          guess: int.parse(response.data['ownguess'].toString()),
        );
      case 403:
        //Heute schon geraten, Herausforderung noch nicht vorbei
        return GuessPage(
          todaysChallenge: todaysChallenge!,
          isGuessAllowed: false,
          device_id: deviceId,
        );
      //Herausforderung vorbei, nicht geraten
      case 401:
        return Leaderboard(
          hasGuessed: false,
          place: 0,
          todaysChallenge: todaysChallenge!,
          guess: 1,
        );
      default:
        debugPrint(
            'error: $code - Something went wrong while trying to connect with the server');
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      body: FutureBuilder<Widget>(
        future: reactToStatusCode(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(child: snapshot.data!);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

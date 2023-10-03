import 'package:ameisenreichner/constants/values.dart';
import 'package:ameisenreichner/models/challengeItem.dart';
import 'package:ameisenreichner/models/guess.dart';
import 'package:ameisenreichner/widgets/guessPage.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';

import '../widgets/leaderboard.dart';

enum Allowance {
  allowed,
  alreadyGuessed,
  challengeOver,
  showLeaderboard,
  error
}

class Challenge extends StatefulWidget {
  const Challenge({super.key});

  @override
  State<Challenge> createState() => _ChallengeState();
}

class _ChallengeState extends State<Challenge> {
  String deviceId = "";
  ChallengeItem? todaysChallenge;
  late Future<int> statusCode;
  List<Guess> guesses = [];
  late Future<Widget> finalWidget;

  void loadChallenge() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString("${AppValues.assetString}challenges.json");
    setState(() {
      todaysChallenge = getCurrentChallenge(loadChallengesFromJson(jsonString));
    });
  }

  @override
  void initState() {
    super.initState();
    //statusCode = _checkIfGuessAllowed();
    finalWidget = reactToStatusCode();
    loadChallenge();
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
      setState(() {
        deviceId = 'test5'; //'windows_device_id';
      });
    } else {
      // Plattform nicht erkannt
      setState(() {
        deviceId = 'unknown_device';
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
        //debugPrint(response.data.toString());
        for (var guess in response.data['guesses']) {
          guesses.add(Guess(
              device_id: "",
              guess: (int.parse(todaysChallenge!.weight.toString()) -
                      int.parse(guess.toString()))
                  .abs()));
        }
        guesses.add(Guess(
            device_id: response.data['deviceId'],
            guess: (int.parse(todaysChallenge!.weight.toString()) -
                    int.parse(response.data['ownguess'].toString()))
                .abs()));
        guesses.sort((a, b) => a.guess.compareTo(b.guess));
        for (var guess in guesses) {
          debugPrint(guess.device_id.toString());
          debugPrint(guess.guess.toString());
        }
        debugPrint("list end");
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




//void addGuessToJson(String filePath, int guess) async {
//   final assetBundle = DefaultAssetBundle.of(context);
//   String data = await DefaultAssetBundle.of(context)
//       .loadString("${AppValues.assetString}dailyguess.json");
//   final jsonResult = jsonDecode(data);

//   Map<String, dynamic> newGuess = {
//     'guess_id': jsonResult['guesses'].length + 1,
//     'device_id': deviceId,
//     'guess': guess,
//   };

//   jsonResult['guesses'].add(newGuess);

//   final updatedJsonContent = json.encode(jsonResult);

//   // Die aktualisierten Daten zurück in die Datei schreiben
//   await assetBundle.load("${AppValues.assetString}dailyguess.json");
//   final updatedJsonFile =
//       await assetBundle.loadString("${AppValues.assetString}dailyguess.json");
//   //await File(filePath).writeAsString(updatedJsonContent);
// }

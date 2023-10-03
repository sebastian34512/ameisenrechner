import 'package:ameisenreichner/constants/colors.dart';
import 'package:ameisenreichner/constants/values.dart';
import 'package:ameisenreichner/models/challengeItem.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GuessPage extends StatefulWidget {
  final ChallengeItem todaysChallenge;
  final bool isGuessAllowed;
  final String device_id;
  const GuessPage(
      {super.key,
      required this.todaysChallenge,
      required this.isGuessAllowed,
      required this.device_id});

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isGuessAllowed = true;

  Future<void> _sendRateRequest(int guess) async {
    // if (device_id == "windows_device_id") {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       behavior: SnackBarBehavior.floating,
    //       content: Text('Bitte verwenden Sie die App auf einem mobilen Gerät.'),
    //     ),
    //   );
    //   return;
    // }

    Map<String, dynamic> formData = {
      "deviceId": widget.device_id, //DateTime.now().toString(),
      "guess": guess,
    };
    Dio dio = Dio();

    try {
      var response =
          await dio.post('https://data.ingoapp.at/rate', data: formData);
      setState(() {
        _isGuessAllowed = false;
      });
    } on DioError catch (dioError) {
      setState(() {
        _isGuessAllowed = false;
      });
      debugPrint(dioError.toString());
      if (dioError.response != null) {
        switch (dioError.response!.statusCode) {
          case 403:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Du hast bereits geraten.'),
              ),
            );
            break;
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
      }
    } catch (e) {
      debugPrint('error: Something went wrong : $e');
    }
  }

  @override
  void initState() {
    _isGuessAllowed = widget.isGuessAllowed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown.shade50,
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(
                child: Text(
                  'Tägliche Herausforderung',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'Wie viele Ameisen braucht es für',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Image.asset(
              "${AppValues.assetString}collection_images/${widget.todaysChallenge.image}",
              fit: BoxFit.cover,
            ),
            !_isGuessAllowed
                ? const Text("Du hast bereits geraten.")
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, bottom: 25),
                        child: TextFormField(
                          controller: _controller,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Gewicht in Kilogramm',
                            labelStyle: TextStyle(
                              color: AppColor.appBrown,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.appBrown, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColor.appBrown, width: 2.0),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.appBrown,
                          ),
                          onPressed: () {
                            _sendRateRequest(_controller.text.isNotEmpty
                                ? int.parse(_controller.text)
                                : 0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Rate!",
                              style: TextStyle(
                                  fontSize: 20, color: AppColor.appLightBrown),
                            ),
                          ))
                    ],
                  )
          ],
        ));
  }
}

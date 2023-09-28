import 'package:ameisenreichner/constants/colors.dart';
import 'package:flutter/material.dart';

int calcAnts(String number) {
  double ants = double.tryParse(number) ?? -1;
  if (ants == -1) {
    return 0;
  }
  return (1 / 0.0006 * ants).floor();
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateText);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateText);
    _controller.dispose();
    super.dispose();
  }

  void _updateText() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appLightBrown,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Wie viele Ameisen braucht es für",
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Gewicht in Kilogramm',
                  labelStyle: TextStyle(
                    color: AppColor.appBrown,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.appBrown, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.appBrown, width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height:
                    20), // Fügt einen Abstand zwischen dem Input Field und dem Text-Widget hinzu
            _controller.text.isNotEmpty
                ? Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${calcAnts(_controller.text)}',
                          style: const TextStyle(fontSize: 100),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      //image
                      Image.asset(
                        'assets/ant.png',
                        width: 200,
                        height: 200,
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

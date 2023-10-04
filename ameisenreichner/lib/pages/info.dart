import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Text(
                "Über die Appidee",
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 35,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Die App mag nicht besonders nützlich sein, aber sie entstand aus einer lustigen Idee, die mir und meinen Freunden im Urlaub kam. Wir standen nehmen unseremen Auto am Strand und beobachteten eine Ameisenstraße, die an uns vorbei lief. Anscheinend war uns so langweilig, dass wir begannen, darüber zu spekulieren, wie viele Ameisen wohl notwendig wären, um das gesamte Auto wegzutragen. Jahre später entschied ich mich, diese lustige Idee in eine App umzusetzen. Ich hoffe, du findest sie genauso unterhaltsam wie wir damals!',
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

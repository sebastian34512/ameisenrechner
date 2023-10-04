import 'package:ameisenreichner/constants/values.dart';
import 'package:ameisenreichner/models/challengeItem.dart';
import 'package:ameisenreichner/pages/challenge.dart';
import 'package:ameisenreichner/pages/counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Leaderboard extends StatelessWidget {
  final bool hasGuessed;
  final int place;
  final ChallengeItem todaysChallenge;
  final int guess;
  const Leaderboard(
      {super.key,
      required this.hasGuessed,
      required this.place,
      required this.todaysChallenge,
      required this.guess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      body: hasGuessed
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Du hast die heutige Herausforderung bereits gelöst!",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(
                      "Du bist auf Platz $place!",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Die Lösung war ${calcAnts(todaysChallenge.weight.toString())} Ameisen. Dein Tipp war $guess Ameisen.",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    "${AppValues.assetString}collection_images/${todaysChallenge.image}",
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                "Du hast die heutige Herausforderung verpasst, schau morgen wieder vorbei!",
                style: GoogleFonts.inter(
                  textStyle: TextStyle(fontSize: 20),
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}

// Mason Mathias

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  bool wonOrLost = false;
  bool won = false;
  bool lost = false;
  String? winLossText;
  Timer? winTimer;
  Timer? hungerTimer;
  final TextEditingController _controller = TextEditingController();
  String? petName;
  int happinessLevel = 50;
  int hungerLevel = 50;
  double energyLevel = 0.5;
  Color squareColor = Colors.yellow;
  String petMood = "neutral";

  void _startWinTimer() {
    winTimer = Timer.periodic(Duration(seconds: 180), (timer) {
      _win();
    });
  }

  void _checkWinLoss() {
    if ((hungerLevel >= 100) & (happinessLevel <= 10)) {
      _loss();
    } else if ((winTimer == null) & (happinessLevel >= 80)) {
      _startWinTimer();
    } else if ((winTimer != null) & (happinessLevel < 80)) {
      winTimer = null;
    }
  }

  void _win() {
    if (wonOrLost != true) {
      won = true;
      wonOrLost = true;
      winLossText = 'You Win';
    }
  }

  void _loss() {
    if (wonOrLost != true) {
      lost = true;
      wonOrLost = true;
      winLossText = 'Game Over';
    }
  }

  void _startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      _updateHunger();
    });
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
    });
  }

  void _updateMood() {
    setState(() {
      _updateColor();
      if (happinessLevel < 30) {
        petMood = "unhappy";
        _updateEnergy();
      } else if (happinessLevel < 70) {
        petMood = "neutral";
      } else {
        petMood = "happy";
        _updateEnergy();
      }
    });
  }

  void _updateColor() {
    setState(() {
      if (happinessLevel < 30) {
        squareColor = Colors.red;
      } else if (happinessLevel < 70) {
        squareColor = Colors.yellow;
      } else {
        squareColor = Colors.green;
      }
    });
  }

  void _updateHappiness() {
    setState(() {
      if (hungerLevel < 30) {
        happinessLevel -= 20;
      } else {
        happinessLevel += 10;
      }
      _updateMood();
      _checkWinLoss();
    });
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
      _updateMood();
      _checkWinLoss();
    });
  }

  void _updateEnergy() {
    setState(() {
      if (petMood == "happy") {
        energyLevel += 0.05;
      } else if (petMood == "unhappy") {
        energyLevel -= 0.15;
      }

      if (energyLevel > 1) {
        energyLevel = 1;
      } else if (energyLevel < 0) {
        energyLevel = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            wonOrLost
            ?
            Text(
              '$winLossText',
              style: TextStyle(fontSize: 40.0),
            )
            :
            SizedBox(height: 40.0),
            SizedBox(height: 16.0),
            Text(
              'Mood: $petMood',
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pet.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                petName == null
                ? 
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Pet Name',
                    ),
                    onSubmitted: (value) {
                      _startHungerTimer();
                      if (value.trim().isNotEmpty) {
                        setState(() {
                          petName = value.trim();
                        });
                      }
                    },
                  ),
                )
                : 
                Text(
                  'Name: $petName',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 16.0),
                Container(
                  width: 16,
                  height: 16,
                  color: squareColor,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Energy:',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 10.0),
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2), // outline thickness
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: energyLevel,
                      color: Colors.lightGreen,
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}

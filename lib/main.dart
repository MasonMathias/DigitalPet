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
  Timer? winTimer;
  Timer? hungerTimer;
  final TextEditingController _controller = TextEditingController();
  String? petName;
  int happinessLevel = 50;
  int hungerLevel = 50;
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
    } else if ((winTimer != null) & (happinessLevel >= 80)) {
      _startWinTimer();
    } else if ((winTimer != null) & (happinessLevel < 80)) {
      winTimer = null;
    }
  }

  void _win() {
    //win
  }

  void _loss() {
    //loss
  }

  void _startHungerTimer() {
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
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
      } else if (happinessLevel < 70) {
        petMood = "neutral";
      } else {
        petMood = "happy";
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
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
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

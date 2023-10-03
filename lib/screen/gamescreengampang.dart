// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';

class GameScreenGampang extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  GameScreenGampang({required this.player1Name, required this.player2Name});

  @override
  _GameScreenGampangState createState() => _GameScreenGampangState();
}

class _GameScreenGampangState extends State<GameScreenGampang> {
  List<bool> boxes = List.filled(9, false);
  int sequenceLength = 5;
  int currentStep = 0;
  bool isAnimating = false;
  bool canInteract = false;

  void startSequenceAnimation() {
    isAnimating = true;
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (currentStep < sequenceLength) {
        int boxIndex = _generateRandomButton();
        setState(() {
          boxes[boxIndex] = true;
        });
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            boxes[boxIndex] = false;
            currentStep++;
          });
        });
      } else {
        timer.cancel();
        currentStep = 0;
        isAnimating = false;
        canInteract = true;
      }
    });
  }

  int _generateRandomButton() {
    return DateTime.now().microsecondsSinceEpoch % 9;
  }

  void handleBoxTap(int index) {
    if (isAnimating || !canInteract) return;

    if (index == _generateRandomButton()) {
      setState(() {
        currentStep++;
        if (currentStep == sequenceLength) {
          isAnimating = true;
          canInteract = false;
          String winnerName =
              currentStep % 2 == 1 ? widget.player1Name : widget.player2Name;

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Ronde Pertama Selesai'),
                content: Text('Pemenang Ronde Pertama: $winnerName'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Lanjut Ronde 2'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        currentStep = 0;
                      });
                      startSequenceAnimation(); // Mulai ronde kedua
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Urutan Salah'),
            content: Text('Anda memilih urutan yang salah'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  canInteract = false;
                  setState(() {
                    currentStep = 0;
                  });
                  startSequenceAnimation();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GAME SCREEN')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sekarang Giliran ${widget.player1Name}',
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep = 0;
                });
                startSequenceAnimation();
              },
              child: Text('Mulai Ronde Pertama'),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    handleBoxTap(index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    color: boxes[index] ? Colors.green : Colors.grey,
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
            Text('Ronde 1'),
            Text('Tingkat Kesulitan: Gampang'),
          ],
        ),
      ),
    );
  }
}

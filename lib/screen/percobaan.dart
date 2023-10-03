// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

bool isAnimating = false;
bool canInteract = false;
int showingSequence = -1;
List<int> currentSequence = [];

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

  

  void startSequence() {
    isAnimating = true;
    
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (currentStep < currentSequence.length) {
        int boxIndex = currentSequence[currentStep];
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

  void startSequenceAnimation() async {
    currentSequence.clear();

    Random random = Random();
    for (int i = 0; i < sequenceLength; i++) {
      int boxIndex = random.nextInt(9);
      currentSequence.add(boxIndex);
    }

    setState(() {
      showingSequence = 0; // Mengubah menjadi 0 untuk menunjukkan bahwa urutan pertama sedang ditampilkan
    });

    for (int i = 0; i < currentSequence.length; i++) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        showingSequence = i + 1; // Menetapkan urutan yang sedang ditampilkan
      });
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        showingSequence = -1; // Mengakhiri penampilan urutan
      });
    }

    startSequence();
  }


  void handleBoxTap(int index) {
    if (isAnimating || (showingSequence != -1 && !canInteract)) return;

    if (showingSequence != -1) {
      if (index == currentSequence[showingSequence]) {
        if (showingSequence == currentSequence.length - 1) {
          setState(() {
            showingSequence = -1; // Hentikan penampilan urutan
            isAnimating = true; // Mulai interaksi
            canInteract = true; // Pengguna dapat memilih kotak
          });

          // Tambahkan poin ke pemain yang sedang giliran
          if (currentStep % 2 == 0) {
            // Pemain 1
            // Tambahkan poin ke pemain 1
            // Ganti ke pemain 2 (jika diperlukan)
          } else {
            // Pemain 2
            // Tambahkan poin ke pemain 2
            // Ganti ke pemain 1 (jika diperlukan)
          }
        } else {
          setState(() {
            showingSequence++;
          });
        }
      } else {
        // Kotak yang dipilih salah saat urutan ditampilkan
        // Tampilkan pesan kesalahan atau lakukan tindakan yang sesuai
      }
      return;
    }

    if (canInteract) {
      // Pemain dapat memilih kotak
      if (index == currentSequence[currentStep]) {
        // Kotak yang dipilih benar
        setState(() {
          currentStep++;
          if (currentStep == currentSequence.length) {
            // Ronda pertama selesai
            isAnimating = true; // Hentikan interaksi

            if (currentStep % 2 == 0) {
              // Kondisi saat ronde pertama selesai seimbang
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Ronde Pertama Selesai'),
                    content: Text('Ronde Pertama Berakhir Seimbang'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Lanjut Ronde 2'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          startSequenceAnimation(); // Mulai ronde kedua
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              // Kondisi saat ronde pertama selesai dan ada pemenang
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
                          startSequenceAnimation(); // Mulai ronde kedua
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        });
      } else {
        // Kotak yang dipilih salah
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
                    canInteract = !canInteract;
                    startSequenceAnimation();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Tunggu lampu hijau atau lakukan tindakan yang sesuai
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
              onPressed: startSequenceAnimation,
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
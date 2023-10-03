// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, unused_local_variable, sort_child_properties_last, non_constant_identifier_names, unused_field, avoid_print

import 'package:flutter/material.dart';
import 'GameScreenGampang.dart';

class SetUp extends StatefulWidget {
  @override
  _SetUp createState() => _SetUp();
}

class _SetUp extends State<SetUp> {
  TextEditingController _player1Controller = TextEditingController();
  TextEditingController _player2Controller = TextEditingController();
  TextEditingController _roundController = TextEditingController();

  String _setup_category = "Gampang";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SetUp Permainan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _player1Controller,
              decoration: InputDecoration(
                labelText: 'Nama Pemain #1',
              ),
            ),
            TextField(
              controller: _player2Controller,
              decoration: InputDecoration(
                labelText: 'Nama Pemain #2',
              ),
            ),
            TextField(
              controller: _roundController,
              decoration: InputDecoration(
                labelText: 'Jumlah Ronde',
              ),
            ),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Tingkat Kesulitan',
                border: InputBorder.none,
              ),
              child: DropdownButton(
                isExpanded: true,
                value: _setup_category,
                items: const [
                  DropdownMenuItem(
                    child: Text("Gampang"),
                    value: "Gampang",
                  ),
                  DropdownMenuItem(
                    child: Text("Sedang"),
                    value: "Sedang",
                  ),
                  DropdownMenuItem(
                    child: Text("Susah"),
                    value: "Susah",
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    _setup_category = v.toString();
                  });
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String player1Name = _player1Controller.text;
                String player2Name = _player2Controller.text;
                int roundCount = int.tryParse(_roundController.text) ?? 0;
                if (_setup_category == "Gampang") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Informasi Permainan'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Nama Pemain 1: $player1Name'),
                            Text('Nama Pemain 2: $player2Name'),
                            Text('Jumlah Ronde: $roundCount'),
                            Text('Tingkat Kesulitan: $_setup_category'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameScreenGampang(
                                    player1Name: player1Name,
                                    player2Name: player2Name,
                                  ),
                                ),
                              );
                            },
                            child: Text('Lets GO'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Balik ke Set UP'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Mulai'),
            ),
          ],
        ),
      ),
    );
  }
}

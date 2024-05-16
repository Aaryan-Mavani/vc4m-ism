import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AudioProcessingScreen extends StatefulWidget {
  @override
  _AudioProcessingScreenState createState() => _AudioProcessingScreenState();
}

class _AudioProcessingScreenState extends State<AudioProcessingScreen> {
  String _serverResponse = '';

  Future<void> _processAudio() async {
    String url = "http://10.1.23.188:5000/process_audio";
    String audioFilePath = "assets/ism.mp3";

    // Read the audio file as binary data
    File audioFile = File(audioFilePath);
    List<int> audioBytes = await audioFile.readAsBytes();

    // Send a POST request with the audio file
    try {
      final response = await http.post(
        Uri.parse(url),
        body: audioBytes,
      );

      if (response.statusCode == 200) {
        setState(() {
          _serverResponse = jsonDecode(response.body)['answer'];
        });
      } else {
        setState(() {
          _serverResponse = 'Failed to process audio';
        });
      }
    } catch (e) {
      setState(() {
        _serverResponse = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Processing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _processAudio,
              child: Text('Process Audio'),
            ),
            SizedBox(height: 20),
            Text(_serverResponse),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AudioProcessingScreen(),
  ));
}

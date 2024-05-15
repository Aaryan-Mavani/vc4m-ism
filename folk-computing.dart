import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AudioPlayer audioPlayer;
  String selectedLang = 'hi_IN';
  bool isRecording = false;
  late String audioPath;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  Future<void> startRecording() async {
    setState(() {
      isRecording = true;
    });
    String path = 'your_audio_path_here'; // Set the path to save the audio
    await audioPlayer.startRecorder(toFile: path, codec: Codec.aacMP4);
    setState(() {
      audioPath = path;
    });
  }

  Future<void> stopRecording() async {
    await audioPlayer.stopRecorder();
    setState(() {
      isRecording = false;
    });
    sendAudio();
  }

  Future<void> sendAudio() async {
    if (audioPath.isNotEmpty) {
      final audioFile = File(audioPath);
      final url = Uri.parse('http://10.1.23.188:5000');
      final request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile(
          'audio', audioFile.readAsBytes().asStream(), audioFile.lengthSync(),
          filename: audioFile.path.split('/').last));
      final response = await http.Client().send(request);
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        final transcribedText = decodedResponse['text'];
        // Do something with the transcribed text, e.g., update UI
        print('Transcribed Text: $transcribedText');
      } else {
        print('Failed to send audio');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isRecording
                ? ElevatedButton(
                    onPressed: stopRecording,
                    child: Text('Stop Recording'),
                  )
                : ElevatedButton(
                    onPressed: startRecording,
                    child: Text('Start Recording'),
                  ),
          ],
        ),
      ),
    );
  }
}

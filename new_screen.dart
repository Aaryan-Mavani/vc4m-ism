import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var text = "123";

  Future<String> convertSpeechToText(String filePath) async {
    // Replace this with your locally hosted whisper model API endpoint
    var url = Uri.parse("http://10.1.23.188:5000/process_audio");
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    var newresponse = await http.Response.fromStream(response);
    final responseData = json.decode(newresponse.body);

    return responseData['text'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatGPT Flutter"),
      ),
      body: content(),
    );
  }

  Widget content() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  // Call locally hosted whisper model API
                  convertSpeechToText(result.files.single.path!).then((value) {
                    setState(() {
                      text = value;
                    });
                  });
                }
              },
              child: const Text(" Pick File "),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Speech to Text : $text",
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}

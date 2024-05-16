// import 'dart:convert';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// // import 'package:learning/constant.dart';
// import 'package:http/http.dart' as http;
//
// void main() => runApp(const MaterialApp(
//   home: MyApp(),
// ));
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   var text = "123";
//
//   // Future<String> convertSpeechToText(String filePath) async {
//   //   const apiKey = "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";
//   //   var url = Uri.https("api.openai.com", "v1/audio/transcriptions");
//   //   var request = http.MultipartRequest('POST', url);
//   //   request.headers.addAll(({"Authorization": "Bearer $apiKey"}));
//   //   request.fields["model"] = 'whisper-1';
//   //   request.fields["language"] = "en";
//   //   request.files.add(await http.MultipartFile.fromPath('file', filePath));
//   //   var response = await request.send();
//   //   var newresponse = await http.Response.fromStream(response);
//   //   final responseData = json.decode(newresponse.body);
//   //
//   //   return responseData['text'];
//   // }
//   //"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"
//   Future<String> convertSpeechToText(String filePath) async {
//     try {
//       const apiKey = "sk-proj-bXZJISX4OO5sDb3Vh6vAT3BlbkFJO2rQrEcLhZA4IwDpJUJw";
//       var url = Uri.https("api.openai.com", "v1/audio/transcriptions");
//       var request = http.MultipartRequest('POST', url);
//       request.headers.addAll({"Authorization": "Bearer $apiKey"});
//       request.fields["model"] = 'whisper-1';
//       request.fields["language"] = "hi";
//       request.files.add(await http.MultipartFile.fromPath('file', filePath));
//       var response = await request.send();
//       var newresponse = await http.Response.fromStream(response);
//
//       // Check if response status code is OK
//       if (newresponse.statusCode == 200) {
//         final responseData = json.decode(newresponse.body);
//
//         // Check if 'text' field exists in responseData
//         if (responseData.containsKey('text')) {
//           return responseData['text'] as String;
//         } else {
//           throw Exception("Text field not found in response data");
//         }
//       } else {
//         throw Exception("Failed to transcribe audio. Status code: ${newresponse.statusCode}");
//       }
//     } catch (e) {
//       // Catch and handle any exceptions that occur during the process
//       print("Error converting speech to text: $e");
//       // Return a default value or rethrow the exception depending on your use case
//       rethrow; // Rethrow the caught exception to propagate it further
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("ChatGPT Flutter"),
//       ),
//       body: content(),
//     );
//   }
//
//   Widget content() {
//     return SizedBox(
//       width: double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   FilePickerResult? result = await FilePicker.platform.pickFiles();
//                   if (result != null) {
//                     //call openai's transcription api
//                     convertSpeechToText(result.files.single.path!).then((value) {
//                       setState(() {
//                         text = value;
//                       });
//                     });
//                   }
//                 },
//                 child: const Text(" Pick File "),
//               )),
//           const SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Speech to Text : $text",
//             style: const TextStyle(fontSize: 20),
//           )
//         ],
//       ),
//     );
//   }
// }


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
    try {
      const apiKey = "sk-proj-bXZJISX4OO5sDb3Vh6vAT3BlbkFJO2rQrEcLhZA4IwDpJUJw";
      var url = Uri.https("api.openai.com", "v1/audio/transcriptions");
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({"Authorization": "Bearer $apiKey"});
      request.fields["model"] = 'whisper-1';
      request.fields["language"] = "en";
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      var response = await request.send();
      var newresponse = await http.Response.fromStream(response);

      // Check if response status code is OK
      if (newresponse.statusCode == 200) {
        final responseData = json.decode(newresponse.body);

        // Check if 'text' field exists in responseData
        if (responseData.containsKey('text')) {
          return responseData['text'] as String;
        } else {
          throw Exception("Text field not found in response data");
        }
      } else {
        throw Exception("Failed to transcribe audio. Status code: ${newresponse.statusCode}");
      }
    } catch (e) {
      // Catch and handle any exceptions that occur during the process
      print("Error converting speech to text: $e");
      // Return a default value or rethrow the exception depending on your use case
      rethrow; // Rethrow the caught exception to propagate it further
    }
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
                    //call openai's transcription api
                    convertSpeechToText(result.files.single.path!).then((value) {
                      setState(() {
                        text = value;
                      });
                    });
                  }
                },
                child: const Text(" Pick File "),
              )),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Speech to Text : $text",
            style: const TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

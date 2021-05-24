import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_demo/custom_audio_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Audio Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var filePath = '';
  void onAddAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['.mp3'],
    );
    if (result != null) {
      // Uncomment below and you get a PlayerException.
      // await Future.delayed(const Duration(seconds: 60));
      setState(() {
        filePath = result.paths.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Just Audio Demo'),
      ),
      body: Column(
        children: [
          Center(
            child: OutlinedButton(
              onPressed: onAddAudio,
              child: Text('Add mp3 file'),
            ),
          ),
          filePath.isNotEmpty
              ? CustomAudioPlayer(
                  audioPath: filePath,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

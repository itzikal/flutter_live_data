import 'package:flutter/material.dart';
import 'package:flutter_live_data/live_data.dart';
import 'package:flutter_live_data/live_data_token.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LiveData<String> liveData = LiveData<String>(initValue: "first value");
  LiveDataToken? token;
  String textToUpdate = "";
  @override
  void initState() {
    super.initState();
    textToUpdate = liveData.value ?? "";
    token = liveData.register((event) {
      setState(() {
        //calling set state to update the text
        textToUpdate = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    token?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
        title: const Text('Live data example app'),
    ),
    body: Column(children: [
      TextButton(onPressed: ()=> liveData.add("new value"), child: Text("update live data with new value")),
      Text("Text: $textToUpdate"),
    ])));
  }
}

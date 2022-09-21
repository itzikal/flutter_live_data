import 'package:flutter/material.dart';
import 'package:stream_live_data/live_data.dart';
import 'package:stream_live_data/live_data_builder.dart';
import 'package:stream_live_data/live_data_token.dart';

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
  final LiveData<String> filter = LiveData<String>();
  final LiveData<List<String>> list = LiveData<List<String>>(initValue: ["a", "b", "c"]);

  late final LiveData<List<String>?> filteredList =
      LiveData.transform<String?, List<String>?, List<String>?>(filter, list,
          (a, b) {
    if (a?.isEmpty ?? true) return b;
    textToUpdate = "List filtered";
    return b?.where((element) => element == a).toList();
  }, onError: (e) {
    setState(() {
      textToUpdate = e.toString();
    });
  });

  LiveDataToken? token;
  LiveDataToken? filterToken;
  String textToUpdate = "";
  @override
  void initState() {
    super.initState();
    textToUpdate = liveData.value ?? "";
    token = liveData.register((event) {
      setState(() {
        //calling set state to update the text
        textToUpdate = event?? "";
      });
    });
    filterToken = filteredList.register((event) {
      setState(() {

      });
    });

  }

  @override
  void dispose() {
    super.dispose();
    token?.cancel();
    filterToken?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
        title: const Text('Live data example app'),
    ),
    body: Column(children: [
      TextField(onChanged: (value){filter.add(value);}),
      Text(filteredList.value?.toString()?? ""),
      TextButton(onPressed: ()=> liveData.add("new value"), child: const Text("update live data with new value")),
      TextButton(onPressed: ()=> filter.dispose(), child: const Text("kill filter live data")),
      TextButton(onPressed: ()=> filter.addError("Some Error happend"), child: const Text("add error")),
      Text("Text: $textToUpdate"),
      LiveDataBuilder(
          liveData: liveData,
          builder: (context, snapshot) {
            return Text("builder: ${snapshot.data}");
      })
    ])));
  }
}

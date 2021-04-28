import 'package:flutter/material.dart';
import 'package:synoget/views/download_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syno Get',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DownloadListView(),
    );
  }
}

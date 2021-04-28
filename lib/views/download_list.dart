import 'package:flutter/material.dart';

class DownloadListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloads'),
      ),
      body: Center(
        child: Container(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.purple,
                  width: 1.0,
                )),
                child: Text('List Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

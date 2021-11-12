import 'dart:io';

import 'package:flutter/material.dart';
import 'package:synology_get/api/syno.dart';

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
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
              DownloadElement(),
            ],
          ),
        ),
      ),
    );
  }
}

class DownloadElement extends StatelessWidget {
  var getInfo;
  var syno;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Container(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'File name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Downloading...'),
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Downloaded: 0/1.2GB'),
                Text('Uploaded: 0/1.2GB'),
                Text('Time Remaining: 15 min'),
              ],
            ),
            Row(
              children: [
                TextButton.icon(
                    onPressed: () => {},
                    icon: Icon(Icons.info),
                    label: Text('Get info')),
                Text(getInfo.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synology_get/api/syno.dart';

class LoginView extends StatelessWidget {
  final TextEditingController qcInput = TextEditingController();

  Future<void> authorize(BuildContext context) async {
    if ('' == qcInput.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No QuickConnect provided!')));
      return;
    }

    // Syno syno = Syno();
    Map<String, dynamic> info = await (Syno()).getServerInfo(qcInput.text);

    // Original test ---
    String base = (info['service']!['relay_dn'] ?? '') +
        ':' +
        info['service']!['relay_port']!.toString();
    print(base);
    var url = Uri.https(base, '');
    // ---

    int counter = 15;
    bool ping = false;

    while (!ping && counter > 0) {
      ping = await (Syno()).pingPong(url);
      counter--;
      sleep(Duration(seconds: 2));
    }

    if (ping) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('PingPong Success')));
      print('PingPong Success');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('PingPong Fail')));
      print('PingPong Fail');
    }

    Map<String, dynamic> apiInfo = await (Syno()).getApiInfo(url);

    Uri downloadStationInfo =
        Uri.https(base, apiInfo['data']['SYNO.DownloadStation.Info']['path'], {
      'api': 'SYNO.DownloadStation.Info',
      'version':
          apiInfo['data']['SYNO.DownloadStation.Info']['maxVersion'].toString(),
      'method': 'getinfo',
    });
    try {
      var response = await (SynoDownload()).getInfo(downloadStationInfo);
      print('Download Station Info');
    } on SocketException catch (e) {
      print('Socket Exception on: ' + downloadStationInfo.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabeledMemoryTextField(
                Text(
                  'QuickConnect ID:',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                qcInput,
                name: 'qID'),
            Text(
              'Username:',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16.0), child: TextField()),
            Text(
              'Password:',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  obscureText: true,
                )),
            HttpsSession(
              httpsState: true,
            ),
            Expanded(child: Container()),
            ElevatedButton.icon(
                onPressed: () async => await authorize(context),
                icon: Icon(Icons.login),
                label: Padding(
                    padding: EdgeInsets.all(16.0), child: Text('Login')))
          ],
        ),
      ),
    );
  }
}

class HttpsSession extends StatefulWidget {
  final bool httpsState;
  const HttpsSession({Key? key, this.httpsState = false}) : super(key: key);

  @override
  State<HttpsSession> createState() => HttpsSessionState();
}

class HttpsSessionState extends State<HttpsSession> {
  bool httpState = false;
  @override
  void initState() {
    httpState = widget.httpsState;
    super.initState();
  }

  void toggleCheckbox(bool? checked) {
    if (null == checked) {
      return;
    }

    setState(() {
      httpState = !httpState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
                value: httpState,
                onChanged: (checked) => toggleCheckbox(checked)),
            Text(
              'HTTPS Session',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}

class LabeledMemoryTextField extends StatefulWidget {
  final String name;
  final Widget label;
  final String defaultValue;
  final TextEditingController input;

  const LabeledMemoryTextField(this.label, this.input,
      {Key? key, this.name = '', this.defaultValue = ''})
      : super(key: key);

  @override
  State<LabeledMemoryTextField> createState() => LabeledMemoryTextFieldState();
}

class LabeledMemoryTextFieldState extends State<LabeledMemoryTextField> {
  String? defaultValue;

  Future<void> getDefaultValue(String field) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    defaultValue = prefs.getString(field);

    if (defaultValue != null) {
      setState(() {
        this.widget.input.text = defaultValue ?? '';
      });
    }
  }

  @override
  void initState() {
    this.widget.input.text = this.widget.defaultValue;
    defaultValue = this.widget.defaultValue;

    if (defaultValue == '') {
      getDefaultValue(this.widget.name);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        this.widget.label,
        Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: TextField(
            controller: this.widget.input,
          ),
        )
      ],
    );
  }
}

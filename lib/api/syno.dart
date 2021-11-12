import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;

class Syno {
  /*
   * Get information about quick connect
   * Status: works
   */
  Future<Map<String, dynamic>> getServerInfo(String quickConnectID) async {
    var url = Uri.https('global.quickconnect.to', 'Serv.php');

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: convert.jsonEncode(<String, dynamic>{
          'version': 1,
          'command': 'get_server_info',
          'serverID': quickConnectID,
          'id': 'dsm_https'
        }));
    if (response.statusCode == 200) {
      print('Syno - response got');
      print(response.body);
      return convert.jsonDecode(response.body) as Map<String, dynamic>;
    }

    print('Syno - response failed');
    print(response.body);
    return Map<String, dynamic>();
  }

  // TODO: method to ping
  Future<bool> pingPong(Uri url) async {
    url = url.replace(
        path: 'webman/pingpong.cgi', queryParameters: {'quickconnect': 'true'});
    print(url.toString());

    var response;

    try {
      response = await http.get(url);
    } on HttpException catch (e) {
      print('Http Exception: ' + e.message);
      return false;
    } on SocketException catch (e) {
      print('Socket Exception: ' + e.message);
      return false;
    }

    if (response == null) {
      return false;
    }

    if (response.statusCode == 200) {
      print('PingPong True');
      print(response.body);
      return true;
    }

    print('PingPong False');
    print(response.body);
    return false;
  }

  Future<Map<String, dynamic>> getApiInfo(Uri url) async {
    url = url.replace(path: '/webapi/query.cgi');

    try {
      var response = await http.post(url, body: {
        'api': 'SYNO.API.Info',
        'method': 'query',
        'version': '1',
        'query': 'all'
      });

      if (response.statusCode == 200) {
        print(response.body);
        return convert.jsonDecode(response.body) as Map<String, dynamic>;
      }
    } on SocketException catch (e) {
      print('Socket Exception for: ' + url.toString());
    }

    return Map<String, dynamic>();
  }
}

class SynoDownload {
  var version;
  var versionString;
  var isManager;

  /*
   * Status: not working
   * Note: Need authorization before calling this method
   */
  Future<Map> getInfo(Uri url) async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response Body');
      print(response.body);
      var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return json;
    }

    print('Status: ');
    print(response.statusCode);

    return Map<String, dynamic>();
  }
}

import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:filesize/filesize.dart';

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Informe um email válido';
  else
    return null;
}

String toBrazilianDate(dynamic toConvert) {
  if (toConvert is String) {
    toConvert = DateTime.parse(toConvert);
  }

  return toConvert != null
      ? new DateFormat("dd/MM/yyyy").format(toConvert)
      : "";
}

String dateToString(dynamic toConvert) {
  if (toConvert is String) {
    toConvert = DateTime.parse(toConvert);
  }
  return new DateFormat("yyyy-MM-dd").format(toConvert);
}

DateTime stringToDate(dynamic toConvert) {
  if (toConvert is DateTime) {
    return toConvert;
  }

  if (toConvert == null) {
    return DateTime.now();
  }
  return DateTime.parse(toConvert);
}

int toInt(dynamic toConvert) {
  if (toConvert is int) {
    return toConvert;
  }

  if (toConvert == null) {
    return 0;
  }
  return int.parse(toConvert);
}

void showToast(BuildContext context, String msg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      action:
          SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

showAlertDialog(BuildContext context, String title, String message) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context, rootNavigator: false).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialogWithRoute(
    BuildContext context, String title, String message, String route) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pushReplacementNamed(route);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<http.Response> fetchData(String url) {
  return http.get(Uri.parse(url));
}

Future<http.Response> postData(
    String url, Map<String, String> headers, Object body) async {
  return http.post(Uri.parse(url),
      headers: headers, body: body, encoding: Encoding.getByName("latin1"));
}

SharedPreferencesHelper prefs;

class SharedPreferencesHelper {
  SharedPreferences localPrefs;

  SharedPreferencesHelper(SharedPreferences preferences) {
    this.localPrefs = preferences;
  }

  String getString(String key) {
    return localPrefs.getString(key) ?? '';
  }

  void setString(String key, String value) {
    localPrefs.setString(key, value);
  }

  bool getBoolean(String key) {
    return localPrefs.getBool(key) ?? false;
  }

  void setBool(String key, bool value) {
    localPrefs.setBool(key, value);
  }
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

String formatAsCurrency(dynamic value) {
  var f = new NumberFormat("#,##0.00", "pt_BR");
  return f.format(double.parse(value.toString()));
}

double toDouble(dynamic value) {
  var result = value is String ? double.parse(value) : value;
  return result;
}

bool isReleaseMode() {
  return kReleaseMode;
}

Future<bool> hasConnection() async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result == true) {
    return result;
  } else {
    print('Sem internet. Motivo:');
    print(DataConnectionChecker().lastTryResults);
  }
  return false;
}

String serverHost() {
  return serverURI() + "AppVisitasEndpoint.rule?sys=AGD";
}

String serverURI() {
  //return "http://192.168.254.73:2020/webrunstudio/";
  return "https://agendevisita.com/visitas/";
}

List<int> searchDropDownByValue(String keyword, items) {
  List<int> ret = [];
  if (keyword != null && items != null && keyword.isNotEmpty) {
    keyword.split(" ").forEach((k) {
      int i = 0;
      items.forEach((item) {
        if (k.isNotEmpty &&
            (item.child.data
                .toString()
                .toLowerCase()
                .contains(k.toLowerCase()))) {
          ret.add(i);
        }
        i++;
      });
    });
  }
  if (keyword.isEmpty) {
    ret = Iterable<int>.generate(items.length).toList();
  }
  return (ret);
}

int getTimeInMs() {
  return DateTime.now().millisecondsSinceEpoch;
}

Future<File> compressFile(File file) async {
  final Directory path = await getApplicationSupportDirectory();
  final String targetFile = path.path + "/" + getTimeInMs().toString() + ".jpg";
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetFile,
    quality: 50,
  );
  return result;
}

String friendlyFileSize(int size) {
  return filesize(size);
}

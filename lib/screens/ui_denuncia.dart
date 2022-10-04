import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';

class DenunciaPage extends StatefulWidget {
  DenunciaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DenunciaPage createState() => new _DenunciaPage();
}

class _DenunciaPage extends State<DenunciaPage> {
  TextEditingController denunciaTxtController = TextEditingController();
  bool _onRequest = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Denúncia"),
      ),
      body: ListView(
        children: [
          new Container(
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            color: mainColor,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: denunciaTxtController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  maxLines: 16,
                  decoration: InputDecoration.collapsed(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(0.5),
                      ),
                      hintText:
                          """Descreva aqui informações como local e data relacionados a denúncia anônima que deseja fazer. 
Não guardamos nenhuma informação relacionada ao envio ou a quem está enviando.""",
                      hintStyle:
                          TextStyle(fontSize: 14, color: Colors.blueGrey)),
                  style: TextStyle(fontSize: 16),
                ),
                separadorH20,
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: secondColor,
                    borderRadius: defaultBorderAll,
                  ),
                  child: SizedBox.expand(
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (_onRequest)
                            CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          else
                            Text(
                              "Enviar denúncia",
                              style: TextStyle(
                                color: secondFontColor,
                              ),
                            ),
                        ],
                      ),
                      onPressed: _doDenuncia,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _doDenuncia() {
    if (denunciaTxtController.text.isEmpty) {
      showAlertDialog(context, '', 'Preencha a denúncia para continuar!');
      return;
    }

    setState(() {
      _onRequest = true;
    });

    hasConnection().then((value) {
      if (value == true) {
        String url = serverHost();

        Object dadosPost = jsonEncode(
          <String, Object>{
            "sys": sysCode,
            "action": "denuncia",
            "arguments": {
              "denuncia": denunciaTxtController.text,
            },
          },
        );

        postData(url, headerPadrao, dadosPost).then((response) {
          Map<String, dynamic> json = jsonDecode(response.body);
          if (json['status'] == true) {
            showAlertDialogWithRoute(context, '', json['message'], "/home");
          } else {
            showAlertDialog(
              context,
              '',
              json['message'],
            );
            return;
          }
        }).catchError(
          (error) {
            showAlertDialog(context, "Atenção!", error.toString());
          },
        );
      } else {
        showAlertDialog(context, '', 'Sem conexão com a internet!');
      }
    });
  }
}

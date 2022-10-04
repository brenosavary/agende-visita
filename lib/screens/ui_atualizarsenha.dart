import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';

class AtualizarSenhaPage extends StatefulWidget {
  AtualizarSenhaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AtualizarSenhaPage createState() => new _AtualizarSenhaPage();
}

class _AtualizarSenhaPage extends State<AtualizarSenhaPage> {
  TextEditingController _senhaAtual = TextEditingController();
  TextEditingController _senhaNova = TextEditingController();
  TextEditingController _senhaNovaConfirm = TextEditingController();
  bool _onRequest = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Atualizar a senha"),
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
                  controller: _senhaAtual,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha atual...',
                    labelStyle: TextStyle(
                      color: mainFontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                TextFormField(
                  controller: _senhaNova,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '...nova senha...',
                    labelStyle: TextStyle(
                      color: mainFontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                TextFormField(
                  controller: _senhaNovaConfirm,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '...confirmação da nova senha.',
                    labelStyle: TextStyle(
                      color: mainFontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),

                  ),
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
                          _onRequest
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  "Atualizar",
                                  style: TextStyle(
                                    color: secondFontColor,
                                  ),
                                ),
                        ],
                      ),
                      onPressed: _doEsqueciSenha,
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

  void _doEsqueciSenha() {
    if (_senhaAtual.text.isEmpty) {
      showAlertDialog(context, '', 'Preencha a senha atual para continuar!');
      return;
    }

    if (_senhaNova.text.isEmpty) {
      showAlertDialog(context, '', 'Preencha a nova para continuar!');
      return;
    }

    if (_senhaNovaConfirm.text.isEmpty) {
      showAlertDialog(context, '', 'Preencha a confirmação de senha para continuar!');
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
            "action": "atualizarSenha",
            "arguments": {
              "login": dadosUsuario['USR_LOGIN'],
              "senhaAtual": _senhaAtual.text,
              "novaSenha": _senhaNova.text,
              "novaSenhaConfirmacao": _senhaNovaConfirm.text,
            },
          },
        );

        postData(url, headerPadrao, dadosPost).then((response) {
          setState(() {
            _onRequest = false;
          });
          Map<String, dynamic> json = jsonDecode(response.body);
          if (json['status'] == true) {
            showAlertDialogWithRoute(
              context,
              '',
              json['message'],
              '/home'
            );

          } else {
            showAlertDialog(
              context,
              '',
              json['message']
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

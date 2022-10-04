import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class EsqueciSenhaPage extends StatefulWidget {
  EsqueciSenhaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EsqueciSenhaPage createState() => new _EsqueciSenhaPage();
}

class _EsqueciSenhaPage extends State<EsqueciSenhaPage> {
  TextEditingController esqueciSenhaTxtController = TextEditingController();
  TextEditingController esqueciSenhaCPFController = TextEditingController();

  bool _onRequest = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Esqueci a senha"),
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
                  controller: esqueciSenhaTxtController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Informe o email para recuperação!',
                    labelStyle: TextStyle(
                      color: mainFontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
                separadorH20,
                TextFormField(
                  controller: esqueciSenhaCPFController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Informe o CPF!',
                    labelStyle: TextStyle(
                      color: mainFontColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                  inputFormatters: [maskCpf],
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
                                  "Recuperar a senha",
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
    if (esqueciSenhaTxtController.text.isEmpty) {
      showAlertDialog(context, '', 'Preencha o e-mail para continuar!');
      return;
    }

    if (!CPFValidator.isValid(esqueciSenhaCPFController.text)) {
      showAlertDialog(context, "Atenção", "O CPF é inválido!");
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
            "action": "esquecisenha",
            "arguments": {
              "email": esqueciSenhaTxtController.text,
              "CPF": esqueciSenhaCPFController.text,
            },
          },
        );

        postData(url, headerPadrao, dadosPost).then((response) {
          setState(() {
            _onRequest = false;
          });
          Map<String, dynamic> json = jsonDecode(response.body);
          if (json['status'] == true) {
            showAlertDialogWithRoute(context, '', json['message'], '/login');
          } else {
            showAlertDialog(context, '', json['message']);
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

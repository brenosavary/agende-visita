import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/widgets/w_avisos.dart';
import 'package:rbdevvisitasapp/widgets/w_vagas.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  TextEditingController userLogin = TextEditingController();
  TextEditingController userPwd = TextEditingController();
  bool _requestingLogin = false;

  @override
  void initState() {
    super.initState();

    getAvisos().then(
      (listaAvisos) {
        if (listaAvisos.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) => Avisos(listaAvisos),
          ).whenComplete(
            () {
              getVagas().then(
                (listaVagas) {
                  if (listaVagas.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => Vagas(listaVagas),
                    );
                  }
                },
              );
            },
          );
        } else {
          getVagas().then(
            (listaVagas) {
              if (listaVagas.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => Vagas(listaVagas),
                );
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(""),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: GestureDetector(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 100.0,
                              height: 100.0,
                              child: Column(
                                children: [
                                  Image.asset('assets/logo.png'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: null,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.vpn_key),
                    title: Text('Login'),
                    onTap: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book_outlined),
                    title: Text('Cadastre-se'),
                    onTap: () {
                      Navigator.of(context).pushNamed("/cadastrese");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.local_police_rounded),
                    title: Text('Denúncia'),
                    onTap: () {
                      Navigator.of(context).pushNamed("/denuncia");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Sair'),
                    onTap: () {
                      signOut(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Align(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      Text("Agenda Visitante"),
                      Center(
                        child: Text("Versão: " +
                            packageInfo.version +
                            "/" +
                            packageInfo.buildNumber),
                      ),
                      separadorH10
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          new Container(
            height: MediaQuery.of(context).size.height - 60,
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            color: mainColor,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 128,
                  child: Image.asset("assets/logo.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: userLogin,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                      labelText: 'Usuário',
                      labelStyle: TextStyle(
                        color: mainFontColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      )),
                  style: TextStyle(fontSize: 20),
                  inputFormatters: [maskCpf],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: userPwd,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(
                        color: mainFontColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      )),
                  style: TextStyle(fontSize: 20),
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
                          _requestingLogin
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  "ENTRAR",
                                  style: TextStyle(
                                    color: secondFontColor,
                                  ),
                                ),
                        ],
                      ),
                      onPressed: _doLogin,
                    ),
                  ),
                ),
                separadorH10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/cadastrese");
                      },
                      child: const Text('Cadastre-se'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/esquecisenha");
                      },
                      child: const Text('Esqueceu a senha'),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _doLogin() {
    if (userLogin.text.isEmpty || userPwd.text.isEmpty) {
      showAlertDialog(
          context, '', 'Preencha o Usuário e Senha para continuar!');
      return;
    }

    setState(() {
      _requestingLogin = true;
    });

    hasConnection().then(
      (value) {
        if (value == true) {
          String url = serverHost();

          Object dadosPost = jsonEncode(
            <String, Object>{
              "sys": sysCode,
              "action": "auth",
              "arguments": {
                "user": userLogin.text,
                "password": userPwd.text,
              },
            },
          );

          headerPadrao.putIfAbsent(
              "Authorization", () => "Basic " + prefs.getString("rest_key"));

          postData(url, headerPadrao, dadosPost).then((response) {
            Map<String, dynamic> json = jsonDecode(response.body);
            if (json['status'] == true) {
              dadosUsuario = json['data'];
              if (dadosUsuario == null) {
                showAlertDialog(context, "",
                    "Perfil não associado as configurações do Agende Visita. Tente novamente!");
                setState(
                  () {
                    _requestingLogin = false;
                  },
                );
                return;
              }
              Navigator.of(context).pushReplacementNamed("/home");
            } else {
              showAlertDialog(
                context,
                "",
                json['message'],
              );
              setState(
                () {
                  _requestingLogin = false;
                },
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
      },
    );
  }
}

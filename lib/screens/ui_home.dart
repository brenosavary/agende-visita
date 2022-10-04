import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/widgets/w_avisos.dart';
import 'package:rbdevvisitasapp/widgets/w_vagas.dart';

class HomeViewPage extends StatefulWidget {
  HomeViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeViewPage createState() => new _HomeViewPage();
}

class _HomeViewPage extends State<HomeViewPage> {
  var _onRequest = false;

  Center makeCard(IconData icon, MaterialColor iconColor, dynamic dados) {
    return Center(
      child: GestureDetector(
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 60,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  icon,
                  color: iconColor,
                  size: 35,
                ),
                Text(
                  dados['nome'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          switch (dados['id']) {
            case AcessoRapido.vagas:
              setState(() {
                _onRequest = true;
              });
              getVagas().then(
                (listaVagas) {
                  setState(() {
                    _onRequest = false;
                  });
                  if (listaVagas.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => Vagas(listaVagas),
                    );
                  }
                },
              );
              return null;
            case AcessoRapido.avisos:
              setState(() {
                _onRequest = true;
              });
              getAvisos().then(
                (listaAvisos) {
                  setState(() {
                    _onRequest = false;
                  });
                  if (listaAvisos.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => Avisos(listaAvisos),
                    );
                  }
                },
              );
              return null;
            case AcessoRapido.meusDados:
              Navigator.of(context).pushNamed("/meusdados");
              return null;
            case AcessoRapido.denuncia:
              Navigator.of(context).pushNamed("/denuncia");
              return null;
            case AcessoRapido.agendamentos:
              Navigator.of(context).pushNamed("/agendamentos");
              return null;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), getVinculados);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Início"),
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
                            Text(dadosUsuario['PES_NOME']),
                          ],
                        ),
                      ),
                      onTap: null,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today_rounded),
                    title: Text('Agendamentos'),
                    onTap: () {
                      Navigator.of(context).pushNamed("/agendamentos");
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.my_library_books,
                    ),
                    title: Text('Meus dados'),
                    onTap: () {
                      Navigator.of(context).pushNamed("/meusdados");
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
                    leading: Icon(Icons.password),
                    title: Text('Trocar minha senha'),
                    onTap: () {
                      Navigator.of(context).pushNamed("/atualizarsenha");
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
                        child: Text("Versão: " + packageInfo.version + "/" + packageInfo.buildNumber),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _onRequest
                ? LinearProgressIndicator(
                    color: Colors.green,
                  )
                : Container(),
            separadorH10,
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Acesso rápido",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            separadorH20,
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  makeCard(
                    Icons.calendar_today_outlined,
                    Colors.green,
                    {"id": AcessoRapido.agendamentos, "nome": "AGENDAMENTOS"},
                  ),
                  makeCard(
                    Icons.menu_book_outlined,
                    Colors.blueGrey,
                    {"id": AcessoRapido.vagas, "nome": "VAGAS"},
                  ),
                  makeCard(
                    Icons.warning_amber_outlined,
                    Colors.orange,
                    {"id": AcessoRapido.avisos, "nome": "AVISOS"},
                  ),
                  makeCard(
                    Icons.my_library_books,
                    Colors.green,
                    {"id": AcessoRapido.meusDados, "nome": "MEUS DADOS"},
                  ),
                  makeCard(
                    Icons.local_police,
                    Colors.red,
                    {"id": AcessoRapido.denuncia, "nome": "DENÚNCIA"},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

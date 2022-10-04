import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/controllers/agendamento.controller.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/model/agendamento.model.dart';
import 'package:rbdevvisitasapp/model/agendamentoview.model.dart';

class MeusAgendamentosView extends StatefulWidget {
  @override
  _MeusAgendamentosViewState createState() => _MeusAgendamentosViewState();
}

class _MeusAgendamentosViewState extends State<MeusAgendamentosView> {
  AgendamentoController _controller;

  var _listaAgendamentos = <AgendamentoModel>[];
  var _onRequest = false;

  @override
  void initState() {
    _controller = new AgendamentoController(context);
    setState(() {
      _onRequest = true;
      _getAgendamentos();
    });

    super.initState();
  }

  Center makeCard(
      IconData icon, MaterialColor iconColor, AgendamentoViewModel dados) {
    return Center(
      child: GestureDetector(
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.all(10.0),
            child: ExpandablePanel(
                collapsed: null,
                header: Text(dados.getHorarioAmigavel()),
                expanded: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Unidade: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: dados.getNomeUnidade()),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Tipo: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: dados.getTipoVisitaNome()),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Visitar: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: dados.getNomeInterno()),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Turno: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: getNomeTurno(dados.aGENDAHORARIOTURNO)),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Cela: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: dados.cela),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: "Ala: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: dados.ala),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text("Meus agendamentos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (podeAgendar()) {
            Navigator.of(context).pushNamed("/novoagendamento").then(
              (result) {
                if (result == true) {
                  showAlertDialog(
                      context, "Sucesso!", "Agendamento realizado!");
                }
                _getAgendamentos();
              },
            );
          } else {
            showAlertDialog(
              context,
              "Atenção!",
              (dadosUsuario['INFORMACAO'] != null
                      ? 'Seu cadastro está com pendências.'
                      : 'Seu cadastro está em análise') +
                  "\n\n*******\n" +
                  (dadosUsuario['INFORMACAO'] != null
                      ? dadosUsuario['INFORMACAO']
                      : ''),
            );
          }
        },
        child: Icon(Icons.add),
      ),
      body: _onRequest
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _listaAgendamentos.length,
              itemBuilder: (context, idx) {
                var agendamento = _listaAgendamentos[idx];
                return makeCard(
                    Icons.group_work_sharp, Colors.red, agendamento);
              },
            ),
    );
  }

  void _confirmarRemover(AgendamentoModel model) {
    showDialog(
      context: navigatorKey.currentContext,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Agenda'),
            content: Text(
                'Confirma remove o agendamento? O processo é irreversível!'),
            actions: [
              FlatButton(
                child: Text("SIM"),
                onPressed: () {
                  // setState()
                  _controller.delete(model);
                  setState(Null Function() param0) {
                    _onRequest = false;
                  }
                },
              ),
              FlatButton(
                child: Text("NÃO"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _getAgendamentos() {
    setState(() {
      _onRequest = true;
    });
    _controller.get(dadosUsuario['USR_LOGIN']).then(
      (list) {
        _listaAgendamentos = list;
        setState(() {
          _onRequest = false;
        });
      },
    );
  }
}

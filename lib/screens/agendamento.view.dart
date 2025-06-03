import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rbdevvisitasapp/controllers/agendamento.controller.dart';
import 'package:rbdevvisitasapp/controllers/documento.controller.dart';
import 'package:rbdevvisitasapp/model/agendamento.model.dart';
import 'package:rbdevvisitasapp/model/documento.model.dart';
import 'package:rbdevvisitasapp/model/horario.model.dart';
import 'package:rbdevvisitasapp/model/internovinculado.model.dart';
import 'package:rbdevvisitasapp/model/tipovisita.model.dart';
import 'package:rbdevvisitasapp/model/unidade.model.dart';
import 'package:rbdevvisitasapp/model/visitante.model.dart';
import 'package:rbdevvisitasapp/screens/documento.view.dart';
import 'package:rbdevvisitasapp/widgets/grupo.widget.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart';

import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:search_choices/search_choices.dart';

class AgendamentoView extends StatefulWidget {
  @override
  _AgendamentoViewState createState() => _AgendamentoViewState();
}

class _AgendamentoViewState extends State<AgendamentoView> {
  AgendamentoController _controller;
  var _agenda = AgendamentoModel();
  var _horario = HorarioModel();
  var _onRequest = false;
  var _ala = "";
  var _cela = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = new AgendamentoController(this.context);
    initAgenda();
    super.initState();
  }

  void initAgenda() {
    _agenda = AgendamentoModel();
    _agenda.pESSOAID = dadosUsuario['PESSOA_ID'];
    _agenda.uSRLOGIN = dadosUsuario['USR_LOGIN'];
    _agenda.aGENDAMENTOSDATA = DateTime.now();
    _agenda.eXTRA = 'N';
    _agenda.uNICODIGOVISITANTE = dadosUsuario['UNI_CODIGO'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text("AGENDAR"),
      ),
      body: Container(
        margin: defaultMarginAll,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GrupoWidget(
                icon: Icons.business,
                title: "Unidade e Agenda",
              ),
              SearchChoices.single(
                closeButton: 'Fechar',
                items: getUnidades().map((item) {
                  return DropdownMenuItem(
                    value: item.idUnidade,
                    child: Text(
                      item.nomeUnidade,
                      style: TextStyle(
                        fontSize: 14,
                        color: item.nomeUnidade.indexOf('Vagas dispon') <= 0
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  );
                }).toList(),
                value: _agenda.uNICODIGO,
                hint: "Selecionar...",
                searchHint: "Selecione a unidade e agenda",
                onChanged: (item) {
                  setState(
                    () {
                      initAgenda();
                      if (item != null) {
                        _agenda.uNICODIGO = item;
                        // _agenda.aGENDAID = item;
                      }
                    },
                  );
                },
                isExpanded: true,
                isCaseSensitiveSearch: false,
                validator: (value) {
                  // if (value == null) {
                  //   return "Informe a unidade e agenda!";
                  // }
                  return null;
                },
              ),
              GrupoWidget(
                icon: Icons.access_time_outlined,
                title: "Dia e Horário",
              ),
              getHorarios(_agenda.uNICODIGO).isEmpty
                  ? SearchChoices.single(
                      closeButton: 'Fechar',
                      items: [],
                      hint: "INDISPONÍVEL...",
                      searchHint: "Selecione o horário",
                      isExpanded: true,
                      isCaseSensitiveSearch: false,
                      onChanged: null,
                    )
                  : SearchChoices.single(
                      closeButton: 'Fechar',
                      items: getHorarios(_agenda.uNICODIGO).map((item) {
                        return DropdownMenuItem(
                          value: item.aGENDAHORARIOID,
                          child: Text(item.getHorarioAmigavel()),
                        );
                      }).toList(),
                      value: _horario.aGENDAHORARIOID,
                      hint: "Selecionar...",
                      searchHint: "Selecione o horário",
                      onChanged: (horarioCodigo) {
                        setState(
                          () {
                            _getDocumentoModel(horarioCodigo);
                            if (horarioCodigo != null) {
                              _agenda.aGENDAHORARIOID = _horario.aGENDAHORARIOID;
                              _agenda.aGENDAID = _horario.aGENDAID;
                              _cela = _horario.cela != null ? _horario.cela : "";
                              _ala = _horario.ala != null ? _horario.ala : "";
                              ;
                            } else {
                              _agenda.aGENDAID = null;
                              _agenda.aGENDAHORARIOID = null;
                              _cela = "";
                              _ala = "";
                            }
                          },
                        );
                      },
                      isExpanded: true,
                      isCaseSensitiveSearch: false,
                      validator: (value) {
                        if (value == null) {
                          return "Informe o horário!";
                        }
                        return null;
                      },
                    ),
              _ala.isNotEmpty
                  ? Column(
                      children: [
                        GrupoWidget(
                          icon: Icons.group_work_sharp,
                          title: "Ala e Cela",
                        ),
                        Text(_ala + " e " + _cela),
                      ],
                    )
                  : Container(),
              GrupoWidget(
                icon: Icons.menu_book_outlined,
                title: "Tipo de Visita",
              ),
              SearchChoices.single(
                closeButton: 'Fechar',
                items: getTipoVisita(_agenda.uNICODIGO, _agenda.aGENDAID).map((item) {
                  return DropdownMenuItem(
                    value: item.tipo,
                    child: Text(item.nome),
                  );
                }).toList(),
                value: _agenda.tIPODEVISITA,
                hint: "Selecionar...",
                searchHint: "Selecione o tipo de visita",
                onChanged: (item) {
                  setState(
                    () {
                      if (item != null) {
                        _agenda.tIPODEVISITA = item;
                      } else {
                        _agenda.tIPODEVISITA = null;
                      }
                    },
                  );
                },
                isExpanded: true,
                isCaseSensitiveSearch: false,
              ),
              _mostrarComponentes()
                  ? GrupoWidget(
                      icon: Icons.emoji_people_sharp,
                      title: "Visitar...",
                    )
                  : Container(),
              _mostrarComponentes()
                  ? _mostrarInterno()
                      ? SearchChoices.single(
                          closeButton: 'Fechar',
                          items: getInternos(_agenda.uNICODIGO).map((item) {
                            return DropdownMenuItem(
                                value: item.ID, child: Text(item.PES_NOME));
                          }).toList(),
                          value: _agenda.iNTERNOVISITANTEID,
                          hint: "Selecionar...",
                          searchHint: "Selecione o interno",
                          onChanged: (idInterno) {
                            setState(
                              () {
                                _agenda.iNTERNOVISITANTEID = idInterno;
                              },
                            );
                          },
                          isExpanded: true,
                          isCaseSensitiveSearch: false,
                        )
                      : Column(
                          children: [
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Nome do Interno"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Informe este campo!";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _agenda.iNTERNONOMELIVRE = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: "Número de Telefone - Whatsapp"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Informe este campo!";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                _agenda.tELEFONEVISITANTE = value;
                              },
                              inputFormatters: [maskTelefone],
                            )
                          ],
                        )
                  : Container(),
              separadorH10,
              Container(
                height: 40,
                width: 60,
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
                                "AGENDAR",
                                style: TextStyle(
                                  color: secondFontColor,
                                ),
                              ),
                      ],
                    ),
                    onPressed: _doRegistrar,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _doRegistrar() async {
    if (_agenda.uNICODIGO == null ||
        _agenda.aGENDAID == null ||
        _agenda.tIPODEVISITA == null) {
      showAlertDialog(context, "Atenção!", "Existem campos não preenchidos!");
      return;
    }

    if (_mostrarComponentes()) {
      if (_mostrarInterno() && _agenda.iNTERNOVISITANTEID == null) {
        showAlertDialog(context, "Atenção!", "Informe o interno para visita!");
        return;
      }
    }

    if (this._formKey.currentState.validate()) {
      _controller.create(_agenda).then((value) {
        if (value) Navigator.pop(context, true);
      });
    } else {
      showAlertDialog(context, "Atenção", "Verifique os campos pendentes!");
    }
  }

  bool _mostrarComponentes() {
    return _agenda.tIPODEVISITA != "CR";
  }

  bool _mostrarInterno() {
    return _agenda.tIPODEVISITA == "OS" ||
        _agenda.tIPODEVISITA == "AD" ||
        _agenda.tIPODEVISITA == "VR";
  }

  // ignore: missing_return
  HorarioModel _getDocumentoModel(int id) {
    getHorarios(_agenda.uNICODIGO).forEach((element) {
      if (element.aGENDAHORARIOID == id) {
        _horario = element;
      }
    });
  }
}

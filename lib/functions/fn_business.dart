import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rbdevvisitasapp/model/horario.model.dart';
import 'package:rbdevvisitasapp/model/internovinculado.model.dart';
import 'package:rbdevvisitasapp/model/municipio.model.dart';
import 'package:rbdevvisitasapp/model/tipodocumento.model.dart';
import 'package:rbdevvisitasapp/model/tipovisita.model.dart';
import 'package:rbdevvisitasapp/model/unidade.model.dart';

final listaMunicipios = <MunicipioModel>[];
final listaTipoDocumentos = <TipoDocumentoModel>[];

void signOut(context) {
  Navigator.of(context).pushReplacementNamed("/login");
}

void obterImagemCameraOuGaleria(context, Function callback) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return SafeArea(
        child: Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Fotos'),
                  onTap: () {
                    _imgFromGallery(callback);
                    Navigator.of(context).pop();
                  }),
              new ListTile(
                leading: new Icon(Icons.photo_camera),
                title: new Text('Câmera'),
                onTap: () {
                  _imgFromCamera(callback);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

_imgFromCamera(Function callback) async {
  ImagePicker()
      .getImage(source: ImageSource.camera, imageQuality: 50)
      .then((image) {
    callback(File(image.path));
  }).catchError((error) {
    var msg = error.message.toLowerCase().contains("no camera")
        ? "Câmera inacessível ou inexistente"
        : error.message;
    showAlertDialog(navigatorKey.currentContext, "Erro", msg);
  });
}

_imgFromGallery(Function callback) async {
  ImagePicker()
      .getImage(source: ImageSource.gallery, imageQuality: 50)
      .then((image) {
    callback(File(image.path));
  }).catchError((error) {
    var msg = error.message.toLowerCase().contains("did not allow")
        ? "Acesso à galeria não permitido"
        : error.message;
    showAlertDialog(navigatorKey.currentContext, "Erro", msg);
  });
}

Future<List<dynamic>> getAvisos() async {
  Object dadosPost = jsonEncode(
    <String, Object>{
      "sys": sysCode,
      "action": "avisos",
      "arguments": {},
    },
  );

  final res = await postData(serverHost(), headerPadrao, dadosPost);

  if (res.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(res.body);
    List data = json['data'];
    return data;
  } else {
    return [];
  }
}

Future<List<dynamic>> getVagas() async {
  Object dadosPost = jsonEncode(
    <String, Object>{
      "sys": sysCode,
      "action": "vagas",
      "arguments": {
        "PESSOA_ID": dadosUsuario['PESSOA_ID'] ?? 0,
        "USR_LOGIN": dadosUsuario['USR_LOGIN'] ?? '',
        "UNI_CODIGO": dadosUsuario['UNI_CODIGO'] ?? 0
      }
    },
  );

  final res = await postData(serverHost(), headerPadrao, dadosPost);

  if (res.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(res.body);
    List data = json['data'];
    listaVagas = data;
    return data;
  } else {
    return [];
  }
}

void agendar(BuildContext context) {
  if (dadosUsuario.isEmpty) {
    showAlertDialog(
        context, "!!! Atenção !!!", "Acesse o aplicativo para agendar!");
    return;
  } else {
    Navigator.of(context).pushNamed("/agendamentos");
  }
}

Future<void> getConfig() async {
  Object dadosPost = jsonEncode(
    <String, Object>{
      "sys": sysCode,
      "action": "config",
      "arguments": {},
    },
  );

  final res = await fetchData(
      serverHost() + "&filtro=" + base64.encode(utf8.encode(dadosPost)));

  if (res.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(res.body);
    var data = json['data'];

    var _listDocs = data['tipoDocumento'];
    var _listCidades = data['municipio'];

    listaTipoDocumentos.clear();
    for (int i = 0; i < _listDocs.length; i++) {
      listaTipoDocumentos.add(TipoDocumentoModel.fromJson(_listDocs[i]));
    }

    listaMunicipios.clear();
    for (int i = 0; i < _listCidades.length; i++) {
      listaMunicipios.add(MunicipioModel.fromJson(_listCidades[i]));
    }
  }
}

Future<dynamic> getEnderecoViaCep(String cep) async {
  final res = await fetchData("https://viacep.com.br/ws/" +
      cep.replaceAll(RegExp(r'\d+'), "") +
      "/json/");
  return jsonDecode(res.body);
}

List<HorarioModel> getHorarios(int idUnidade) {
  var _listaHorarios = <HorarioModel>[];
  listaVagas.forEach(
    (el) {
      var deco = jsonDecode((el));
      if (deco['idUnidade'] == idUnidade) {
        var vagas = deco['vagasDetalhe'];
        vagas.forEach(
          (vaga) {
            _listaHorarios.add(HorarioModel.fromJson(vaga));
          },
        );
      }
    },
  );
  return _listaHorarios;
}

List<UnidadeModel> getUnidades() {
  var _listaUnidades = <UnidadeModel>[];
  listaVagas.forEach(
    (el) {
      _listaUnidades.add(UnidadeModel.fromJson(jsonDecode(el)));
    },
  );
  return _listaUnidades;
}

bool podeAgendar() {
  return dadosUsuario['PES_CADASTRO_VALIDO'] == "S";
}

List<TipoVisitaModel> getTipoVisita(int idUnidade, int agendaID) {
  var _lista = <TipoVisitaModel>[];

  listaVagas.forEach(
    (el) {
      var deco = jsonDecode((el));
      if (deco['idUnidade'] == idUnidade) {
        List<dynamic> vagas = deco['vagasDetalhe'];
        vagas.forEach(
          (vaga) {
            //var decoVaga = jsonDecode((vaga));
            if (vaga['AGENDA_ID'] == agendaID && _lista.length == 0) {
              //Pode mudar para AGENDAMENTO_ID caso precise no futuro
              switch (vaga['TIPO_DE_VISITA']) {
                case "CR":
                  _lista
                      .add(TipoVisitaModel(tipo: "CR", nome: "Credenciamento"));
                  break;
                case "VS":
                  _lista
                      .add(TipoVisitaModel(tipo: "VS", nome: "Visita Social"));
                  break;
                case "VR":
                  _lista
                      .add(TipoVisitaModel(tipo: "VR", nome: "Visita Regular"));
                  break;
                case "AD":
                  _lista.add(TipoVisitaModel(tipo: "AD", nome: "Advogado"));
                  break;
                case "VV":
                  _lista
                      .add(TipoVisitaModel(tipo: "VV", nome: "Visita Virtual"));
                  break;
                case "OS":
                  _lista.add(
                      TipoVisitaModel(tipo: "OS", nome: "Outros Serviços"));
                  break;
              }
            }
          },
        );
      }
    },
  );

  return _lista;
}

List<TipoVisitaModel> getAllTipoVisita() {
  var _lista = <TipoVisitaModel>[];
  _lista.add(TipoVisitaModel(tipo: "CR", nome: "Credenciamento"));
  _lista.add(TipoVisitaModel(tipo: "VS", nome: "Visita Social"));
  _lista.add(TipoVisitaModel(tipo: "VR", nome: "Visita Regular"));
  _lista.add(TipoVisitaModel(tipo: "AD", nome: "Advogado"));
  _lista.add(TipoVisitaModel(tipo: "VV", nome: "Visita Virtual"));
  _lista.add(TipoVisitaModel(tipo: "OS", nome: "Outros Serviços"));
  return _lista;
}

Future<void> getVinculados() async {
  Object dadosPost = jsonEncode(
    <String, Object>{
      "sys": sysCode,
      "action": "internos",
      "arguments": {
        "PESSOA_ID": dadosUsuario['PESSOA_ID'],
        "UNI_CODIGO": dadosUsuario['UNI_CODIGO']
      },
    },
  );

  final res = await postData(serverHost(), headerPadrao, dadosPost);

  if (res.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(res.body);
    List data = json['data'];
    listaVinculados = data;
    return data;
  } else {
    listaVinculados = [];
  }
}

List<InternoVinculadoModel> getInternos(int unidade) {
  var _listaRetorno = <InternoVinculadoModel>[];
  listaVinculados.forEach(
    (el) {
      if (el['UNI_CODIGO'] == unidade) {
        _listaRetorno.add(InternoVinculadoModel.fromJson(el));
      }
    },
  );
  return _listaRetorno;
}

int getUnidadeByAgenda(int agendaID) {
  var _result;
  listaVagas.forEach(
    (el) {
      var deco = jsonDecode((el));
      if (deco['idAgenda'] == agendaID) {
        _result = deco['idUnidade'];
      }
    },
  );
  return _result;
}

String getNomeTurno(String shortCase) {
  var _nome = "";

  switch (shortCase) {
    case "M":
      _nome = "Manhã";
      break;
    case "V":
      _nome = "Tarde";
      break;
    case "N":
      _nome = "Noite";
      break;
  }

  return _nome;
}

String getTipoDocumento(int id) {
  var _result = "";
  for (int i = 0; i < listaTipoDocumentos.length; i++) {
    if (listaTipoDocumentos[i].iDTPDOCUMENTO == id) {
      _result = listaTipoDocumentos[i].nOMEDOCUMENTO;
      break;
    }
  }
  return _result;
}

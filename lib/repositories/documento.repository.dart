import 'dart:convert';

import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/model/documento.model.dart';
import 'package:rbdevvisitasapp/model/visitante.model.dart';
import 'package:rbdevvisitasapp/services/app.services.dart';

class DocumentoRepository {
  final _services = new AppServices();

  Future<bool> createDocumento(DocumentoModel model) async {
    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": "documentos",
        "arguments": model,
      },
    );

    final res = await _services.post(headerPadrao, dadosPost);
    return res == null;
  }

  Future<bool> updateDocumento(DocumentoModel model) async {
    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": "documentos",
        "arguments": model,
      },
    );

    final res = await _services.put(headerPadrao, dadosPost);
    return res == null;
  }

  Future<List<DocumentoModel>> getDocumentos(String visitante) async {
    Object filter = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": "documentos",
        "arguments": {"VISITANTE_GUID": visitante},
      },
    );

    final res = await _services.get(headerPadrao, filter: filter);
    var _listToParse = jsonDecode(res);
    var _listDocs = <DocumentoModel>[];

    for (int i = 0; i < _listToParse.length; i++) {
      _listDocs.add(DocumentoModel.fromJson(_listToParse[i]));
    }

    return _listDocs;
  }

  Future<bool> deleteDocumento(DocumentoModel model) async {
    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": "documentos",
        "arguments": model,
      },
    );

    final res = await _services.delete(headerPadrao, dadosPost);
    return res == null;
  }
}

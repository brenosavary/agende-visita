
import 'dart:convert';

import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/model/visitante.model.dart';
import 'package:rbdevvisitasapp/services/app.services.dart';

class VisitanteRepository{

  final _services = new AppServices();

  Future<bool> createVisitante(VisitanteModel model) async{

    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": "visitantes",
        "arguments": model.toJson(),
      },
    );

    final res = await _services.post(headerPadrao, dadosPost);
    return res == null;
  }

  Future<bool> updateVisitante(VisitanteModel model) async{

    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": "visitantes",
        "arguments": model.toJson(),
      },
    );

    final res = await _services.put(headerPadrao, dadosPost);
    return res == null;
  }

  Future<VisitanteModel> getVisitante(String id) async{
    Object filter = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": "visitantes",
        "arguments": {"guid" : id},
      },
    );

    final res = await _services.get(headerPadrao, filter: filter);
    return VisitanteModel.fromJson(jsonDecode(res));
  }
}
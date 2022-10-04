import 'dart:convert';

import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/model/agendamento.model.dart';
import 'package:rbdevvisitasapp/model/agendamentoview.model.dart';
import 'package:rbdevvisitasapp/services/app.services.dart';

class AgendamentoRepository {
  static const _action = "agenda";
  final _services = new AppServices();

  Future<bool> createAgendamento(AgendamentoModel model) async {
    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": _action,
        "arguments": model,
      },
    );

    final res = await _services.post(headerPadrao, dadosPost);
    return res == null;
  }

  Future<bool> updateAgendamento(AgendamentoModel model) async {
    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": _action,
        "arguments": model,
      },
    );

    final res = await _services.put(headerPadrao, dadosPost);
    return res == null;
  }

  Future<List<AgendamentoViewModel>> getAgendamentos(String login) async {
    Object filter = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": _action,
        "arguments": {"login": login},
      },
    );

    final res = await _services.get(headerPadrao, filter: filter);
    var _listToParse = jsonDecode(res);
    var _listAgendamentos = <AgendamentoViewModel>[];

    for (int i = 0; i < _listToParse.length; i++) {
      _listAgendamentos.add(AgendamentoViewModel.fromJson(_listToParse[i]));
    }

    return _listAgendamentos;
  }

  Future<bool> deleteAgendamento(AgendamentoModel model) async {
    Object dadosPost = jsonEncode(
      <String, Object>{
        "sys": sysCode,
        "action": _action,
        "arguments": model,
      },
    );

    final res = await _services.delete(headerPadrao, dadosPost);
    return res == null;
  }
}

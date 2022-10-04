import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/model/agendamento.model.dart';
import 'package:rbdevvisitasapp/model/agendamentoview.model.dart';
import 'package:rbdevvisitasapp/repositories/agendamento.repository.dart';

class AgendamentoController{
  final context;
  final AgendamentoRepository _repository = new AgendamentoRepository();

  AgendamentoController(this.context);

  Future<bool> create(AgendamentoModel model) async{

    try{
      return await _repository.createAgendamento(model);
    }catch(e){
      showAlertDialog(context, "Atenção!", e.toString());
    }
    return false;
  }

  Future<void> update(AgendamentoModel model) async{

    try{
      await _repository.updateAgendamento(model);
    }catch(e){
      showAlertDialog(context, "Documentos", e.toString());
    }
  }

  Future<List<AgendamentoViewModel>> get(String id) async{

    try{
      return await _repository.getAgendamentos(id);
    }catch(e){
      showAlertDialog(context, "Atenção!", e.toString());
    }

    return [];
  }

  Future<void> delete(AgendamentoModel model) async{

    try{
      await _repository.deleteAgendamento(model);
    }catch(e){
      showAlertDialog(context, "Agenda", e.toString());
    }
  }

}
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/model/visitante.model.dart';
import 'package:rbdevvisitasapp/repositories/visitante.repository.dart';

class VisitanteController{
  final context;
  final VisitanteRepository _repository = new VisitanteRepository();

  VisitanteController(this.context);

  Future<void> create(VisitanteModel model) async{

    try{
      await _repository.createVisitante(model);
    }catch(e){
      throw e;
    }
  }

  Future<void> update(VisitanteModel model) async{

    try{
      await _repository.updateVisitante(model);
    }catch(e){
      showAlertDialog(context, "Atenção!", e.toString());
    }
  }

  Future<VisitanteModel> get(String id) async{

    try{
      return await _repository.getVisitante(id);
    }catch(e){
      showAlertDialogWithRoute(context, "Atenção!", e.toString(), "/home");
    }

    return null;
  }

}
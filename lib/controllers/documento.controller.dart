import 'package:flutter/cupertino.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/model/documento.model.dart';
import 'package:rbdevvisitasapp/repositories/documento.repository.dart';

class DocumentoController{
  final context;
  final DocumentoRepository _repository = new DocumentoRepository();

  DocumentoController(this.context);

  Future<void> create(List<DocumentoModel> model) async{

    try{
      for(int i = 0; i < model.length; i++){
        await _repository.createDocumento(model[i]);
      }
    }catch(e){
      showAlertDialog(context, "Atenção!", e.toString());
    }
  }

  Future<void> update(List<DocumentoModel> model) async{

    try{
      for(int i = 0; i < model.length; i++){
        //Documentos existentes não são atualizáveis (ou remove ou insere um novo)
        if (model[i].iDDOCUMENTO > 0)
          continue;

        await _repository.updateDocumento(model[i]);
      }
    }catch(e){
      showAlertDialog(context, "Documentos", e.toString());
    }
  }

  Future<List<DocumentoModel>> get(String id) async{

    try{
      return await _repository.getDocumentos(id);
    }catch(e){
      showAlertDialog(context, "Atenção!", e.toString());
    }

    return [];
  }

  Future<void> delete(List<DocumentoModel> model) async{

    try{
      for(int i = 0; i < model.length; i++){
        await _repository.deleteDocumento(model[i]);
      }
    }catch(e){
      showAlertDialog(context, "Documentos", e.toString());
    }
  }

}
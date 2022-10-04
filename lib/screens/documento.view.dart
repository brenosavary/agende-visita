import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rbdevvisitasapp/controllers/documento.controller.dart';
import 'package:rbdevvisitasapp/model/documento.model.dart';
import 'package:rbdevvisitasapp/model/municipio.model.dart';
import 'package:rbdevvisitasapp/model/tipodocumento.model.dart';
import 'package:rbdevvisitasapp/model/visitante.model.dart';
import 'package:rbdevvisitasapp/widgets/grupo.widget.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart';

import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/controllers/visitante.controller.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:search_choices/search_choices.dart';

class DocumentoView extends StatefulWidget {
  final DocumentoModel documento;

  DocumentoView({Key key, this.documento}) : super(key: key);

  @override
  _DocumentoViewState createState() => _DocumentoViewState();
}

class _DocumentoViewState extends State<DocumentoView> {
  Uint8List _imageFrente;
  Uint8List _imageVerso;
  var _tipoDocumento = TipoDocumentoModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text("Documento"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop(this.widget.documento);
          },
        ),
      ),
      body: Container(
        margin: defaultMarginAll,
        child: ListView(
          children: [
            SearchChoices.single(
              closeButton: 'Fechar',
              items: listaTipoDocumentos.map((item) {
                return DropdownMenuItem(
                  value: item.iDTPDOCUMENTO,
                  child: Text(item.nOMEDOCUMENTO),
                );
              }).toList(),
              value: this.widget.documento.tIPODOCUMENTO,
              hint: "Selecionar...",
              searchHint: "Selecione o tipo de documento",
              onChanged: (codigoTipo) {
                setState(
                  () {
                    this.widget.documento.tIPODOCUMENTO = codigoTipo;
                    getDocumentoModel(codigoTipo);
                  },
                );
              },
              isExpanded: true,
              isCaseSensitiveSearch: false,
            ),
            GrupoWidget(
              icon: Icons.article_outlined,
              title: "Documento - Frente",
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  obterImagemCameraOuGaleria(context, _setImageFrente);
                },
                child: Container(
                  child: _imageFrente != null && _imageFrente.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.memory(
                            _imageFrente,
                            width: 150,
                            height: 180,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: 150,
                          height: 180,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
            ),
            _tipoDocumento.vERSO == "S"
                ? Column(
                    children: [
                      GrupoWidget(
                        icon: Icons.menu_book_outlined,
                        title: "Documento - Verso",
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            obterImagemCameraOuGaleria(context, _setImageVerso);
                          },
                          child: Container(
                            child: _imageVerso != null && _imageVerso.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.memory(
                                      _imageVerso,
                                      width: 150,
                                      height: 180,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width: 150,
                                    height: 180,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            separadorH10,
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: secondColor,
                borderRadius: defaultBorderAll,
              ),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "SALVAR",
                      style: TextStyle(
                        color: secondFontColor,
                      ),
                    ),
                  ],
                ),
                onPressed: _validateAndSave,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _setImageFrente(File image) async {
    image = await compressFile(image);
    setState(
      () {
        _imageFrente = image.readAsBytesSync();
      },
    );
  }

  _setImageVerso(File image) async {
    image = await compressFile(image);
    setState(
      () {
        _imageVerso = image.readAsBytesSync();
      },
    );
  }

  void _validateAndSave() {


    if(_tipoDocumento.iDTPDOCUMENTO == null){
      showAlertDialog(context, "", "Selecione o tipo de documento!");
      return;
    }

    if(_imageFrente == null || (_imageFrente != null && _imageFrente.isEmpty)){
      showAlertDialog(context, "", "Selecione o documento frete");
      return;
    }

    if(_tipoDocumento.vERSO == "S" && (_imageVerso == null || (_imageVerso != null && _imageVerso.isEmpty))){
      showAlertDialog(context, "", "Selecione o documento verso");
      return;
    }

    this.widget.documento.iDDOCUMENTO = 0;
    this.widget.documento.dOCFRENTE = base64.encode(_imageFrente);
    this.widget.documento.dOCFUNDO = _imageVerso != null ? base64.encode(_imageVerso) : null;
    this.widget.documento.tIPODOCUMENTO = _tipoDocumento.iDTPDOCUMENTO;
    Navigator.of(context).pop(this.widget.documento);
  }

  TipoDocumentoModel getDocumentoModel(int id){
    listaTipoDocumentos.forEach((element) {
      if(element.iDTPDOCUMENTO == id){
        _tipoDocumento = element;
      }
    });
  }
}

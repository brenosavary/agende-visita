import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/controllers/documento.controller.dart';
import 'package:rbdevvisitasapp/model/documento.model.dart';
import 'package:rbdevvisitasapp/model/visitante.model.dart';
import 'package:rbdevvisitasapp/screens/documento.view.dart';
import 'package:rbdevvisitasapp/widgets/grupo.widget.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart';

import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/controllers/visitante.controller.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:search_choices/search_choices.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class VisitanteView extends StatefulWidget {
  final Operacao operacao;

  VisitanteView({Key key, this.operacao}) : super(key: key);

  @override
  _VisitanteViewState createState() => _VisitanteViewState();
}

class _VisitanteViewState extends State<VisitanteView> {
  VisitanteController _controller;
  DocumentoController _documentoController;

  final _dataNascimento = new TextEditingController();
  var _visitanteModel = VisitanteModel();
  var _listaDocumentos = <DocumentoModel>[];
  var _listaDocumentosDelete = <DocumentoModel>[];
  var _onRequest = false;
  Uint8List _image;

  final formVisitantes = FormGroup(
    {
      'VISITANTE_FOTO': FormControl<String>(),
      'PES_NOME': FormControl<String>(
        validators: [Validators.required],
      ),
      'PES_CPF': FormControl<String>(
        validators: [Validators.required],
      ),
      'PES_RG': FormControl<int>(
        validators: [Validators.required],
      ),
      'PES_ORGAO_EMISSOR_DO_RG': FormControl<String>(
        validators: [Validators.required],
      ),
      'PES_DATA_DE_NASCIMENTO': FormControl<String>(
        validators: [Validators.required],
      ),
      'PES_CELULAR': FormControl<String>(
        validators: [Validators.required],
      ),
      'PES_EMAIL': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'PES_CEP': FormControl<String>(
        validators: [Validators.required],
      ),
      'MUNICIPIO_ID': FormControl<int>(
        validators: [Validators.required],
      ),
      'PES_BAIRRO': FormControl<String>(
        validators: [Validators.required],
      ),
      'PES_LOGRADOURO': FormControl<String>(
        validators: [Validators.required],
      ),
      'PES_COMPLEMENTO_DO_ENDERECO': FormControl<String>(
        validators: [Validators.required],
      ),
    },
  );

  @override
  void initState() {
    _controller = new VisitanteController(this.context);
    _documentoController = new DocumentoController(this.context);

    if (this.widget.operacao == Operacao.editar) {
      setState(() {
        _onRequest = true;
        _controller.get(dadosUsuario['VISITANTE_GUID']).then((visitante) {
          if (visitante != null) {
            _visitanteModel = visitante;
            this.formVisitantes.value = visitante.toJson();
            _dataNascimento.text =
                toBrazilianDate(visitante.PESDATADENASCIMENTO);
          }

          _documentoController.get(visitante.VISITANTEGUID).then((list) {
            _listaDocumentos = list;
            setState(() {
              _onRequest = false;
            });
          }).whenComplete(() {
            setState(() {
              _onRequest = false;
            });
          }).whenComplete(() {
            setState(() {
              _onRequest = false;
            });
          });
        });
      });
    } else {
      _visitanteModel.VISITANTEGUID = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: Text(this.widget.operacao == Operacao.incluir
            ? "Cadastre-se"
            : "Meus dados"),
      ),
      body: _onRequest
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Text(
                  this.widget.operacao == Operacao.incluir
                      ? "Aguarde... enviando dados!"
                      : "Aguarde... processando dados!",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ],
            )
          : Container(
              margin: defaultMarginAll,
              child: ReactiveFormBuilder(
                form: () => this.formVisitantes,
                builder: (context, form, child) {
                  return ListView(
                    children: [
                      GrupoWidget(
                        icon: Icons.group_rounded,
                        title: "Dados Pessoais",
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            obterImagemCameraOuGaleria(context, _setImage);
                          },
                          child: Container(
                            width: 150,
                            height: 180,
                            child: _image != null && _image.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.memory(_image),
                                  )
                                : _visitanteModel.VISITANTEFOTO != null &&
                                        _visitanteModel.VISITANTEFOTO.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          serverURI() +
                                              '/cache/' +
                                              _visitanteModel.VISITANTEFOTO,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        //   width: 150,
                                        //   height: 180,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_NOME',
                        validationMessages: (control) => {
                          ValidationMessage.required: 'O nome é obrigatório...',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Nome completo',
                        ),
                      ),
                      ReactiveTextField<String>(
                          formControlName: 'PES_CPF',
                          validationMessages: (control) => {
                                ValidationMessage.required:
                                    'O CPF é obrigatório...',
                              },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'CPF',
                          ),
                          inputFormatters: [maskCpf]),
                      ReactiveTextField<int>(
                        formControlName: 'PES_RG',
                        validationMessages: (control) => {
                          ValidationMessage.required: 'O RG é obrigatório...',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'RG',
                        ),
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_ORGAO_EMISSOR_DO_RG',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'O orgão emissor deve ser preenchido...',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Orgão Emissor',
                        ),
                      ),
                      DateTimeField(
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (_dataNascimento.value.text == null) {
                            return "A data de nascimento deve ser preenchida...";
                          }
                          if (value != null &&
                              !value.compareTo(DateTime.now()).isNegative) {
                            return "A data de nascimento não é válida";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.always,
                        format: DateFormat("dd/MM/yyyy"),
                        controller: _dataNascimento,
                        onShowPicker: (contet, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100),
                            locale: Locale('pt', 'BR'),
                          );
                        },
                        onChanged: (value) {
                          this
                              .formVisitantes
                              .control('PES_DATA_DE_NASCIMENTO')
                              .value = dateToString(value);
                        },
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_CELULAR',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'O celular deve ser preenchido...',
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Nº Celular',
                        ),
                        inputFormatters: [maskTelefone],
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_EMAIL',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'O e-mail deve ser preenchido...',
                          ValidationMessage.email: 'Informe um e-mail válido...'
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GrupoWidget(
                            icon: Icons.menu_book_outlined,
                            title: "Documento",
                          ),
                          TextButton.icon(
                            onPressed: () {
                              addDocuments(new DocumentoModel(), -1);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Anexar"),
                          ),
                        ],
                      ),
                      Container(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _listaDocumentos.length,
                          itemBuilder: (context, idx) {
                            var documento = _listaDocumentos[idx];

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTipoDocumento(
                                        documento.tIPODOCUMENTO)),
                                    IconButton(
                                      onPressed: () {
                                        _removeFromList(idx);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                                documento.iDDOCUMENTO == 0
                                    ? Image.memory(
                                        base64Decode(documento.dOCFRENTE),
                                        width: 250,
                                        height: 90,
                                      )
                                    : Image.network(
                                        serverURI() +
                                            '/cache/' +
                                            documento.dOCFRENTE,
                                        width: 250,
                                        height: 90,
                                      ),
                                separadorH10,
                                documento.iDDOCUMENTO == 0 &&
                                        documento.dOCFUNDO != null
                                    ? Image.memory(
                                        base64Decode(documento.dOCFUNDO),
                                        width: 250,
                                        height: 90,
                                      )
                                    : documento.dOCFUNDO != null &&
                                            documento.dOCFUNDO.isNotEmpty
                                        ? Image.network(
                                            serverURI() +
                                                '/cache/' +
                                                documento.dOCFUNDO,
                                            width: 250,
                                            height: 90,
                                          )
                                        : Container(),
                              ],
                            );
                          },
                        ),
                      ),
                      GrupoWidget(
                        icon: Icons.location_pin,
                        title: "Endereço",
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_CEP',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'O CEP deve ser preenchido...',
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "CEP",
                        ),
                        inputFormatters: [maskCEP],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SearchChoices.single(
                        closeButton: 'Fechar',
                        items: listaMunicipios.map((item) {
                          return DropdownMenuItem(
                            value: item.cIDCODIGO,
                            child: Text(
                                item.cIDADECIDNOME + ' - ' + item.cIDADEUF),
                          );
                        }).toList(),
                        value: _visitanteModel.MUNICIPIOID,
                        searchFn: searchDropDownByValue,
                        label: "Município",
                        hint: "Selecionar...",
                        searchHint: "Selecione o município",
                        onChanged: (cidCodigo) {
                          setState(
                            () {
                              _visitanteModel.MUNICIPIOID = cidCodigo;
                              this
                                  .formVisitantes
                                  .controls['MUNICIPIO_ID']
                                  .value = cidCodigo;
                            },
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'O município deve ser preenchido...';
                          }
                        },
                        isExpanded: true,
                        isCaseSensitiveSearch: false,
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_BAIRRO',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'O bairro deve ser preenchido...',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Bairro',
                        ),
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_LOGRADOURO',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'O logradouro deve ser preenchido...',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Logradouro',
                        ),
                      ),
                      ReactiveTextField<String>(
                        formControlName: 'PES_COMPLEMENTO_DO_ENDERECO',
                        validationMessages: (control) => {
                          ValidationMessage.required:
                              'O complemento deve ser preenchido...',
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Complemento',
                        ),
                      ),
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
                            child: Text(
                              this.widget.operacao == Operacao.incluir
                                  ? "CADASTRE-SE"
                                  : "ATUALIZAR",
                              style: TextStyle(
                                color: secondFontColor,
                              ),
                            ),
                            onPressed: _doCadastrar,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  _setImage(File image) async {
    image = await compressFile(image);
    setState(
      () {
        _image = image.readAsBytesSync();
      },
    );
  }

  void _doCadastrar() async {
    if (this.widget.operacao == Operacao.incluir &&
        (_image == null || (_image != null && _image.isEmpty))) {
      showAlertDialog(context, "Atenção", "A foto é obrigatória!");
      return;
    }

    if (_dataNascimento.text.isEmpty) {
      showAlertDialog(
          context, "Atenção", "A data de nascimento é obrigatória!");
      return;
    }

    if (!CPFValidator.isValid(this.formVisitantes.control('PES_CPF').value)) {
      this.formVisitantes.control('PES_CPF').setErrors({'CPF inválido': ''});
      showAlertDialog(context, "Atenção", "O CPF é inválido!");
      return;
    }

    this.formVisitantes.markAllAsTouched();
    if (this.formVisitantes.valid) {
      var _dadosParsed = {};
      _dadosParsed = _visitanteModel.toJson();

      this.formVisitantes.controls.forEach(
        (key, control) {
          _dadosParsed[key] = control.value;
        },
      );
      _visitanteModel = VisitanteModel.fromJson(_dadosParsed);

      if (_image != null && _image.isNotEmpty) {
        _visitanteModel.VISITANTEFOTO = base64.encode(_image);
        _visitanteModel.VIEW_HASFOTOCHANGED = true;
      } else {
        _visitanteModel.VIEW_HASFOTOCHANGED = false;
      }
      setState(
        () {
          _onRequest = true;
        },
      );
      if (this.widget.operacao == Operacao.incluir) {
        try {
          await _controller.create(_visitanteModel);
          await _documentoController.update(_listaDocumentos);
          showAlertDialogWithRoute(
              context,
              "Sucesso!",
              "Seu cadastro foi criado. Verifique seu e-mail para obter os dados de acesso",
              "/login");
        } catch (e) {
          showAlertDialog(context, "Atenção!", e.toString());
        }
      } else {
        await _controller.update(_visitanteModel);
        await _documentoController.update(_listaDocumentos);
        await _documentoController.delete(_listaDocumentosDelete);
        showAlertDialogWithRoute(
            context, "Sucesso!", "Seu dados foram atualizados!", "/home");
      }
      setState(() {
        _onRequest = false;
      });
    } else {
      showAlertDialog(
          context,
          "Atenção",
          "Campos obrigatórios não preenchidos.\n" +
              "Verifique os destaques em vermelho!");
    }
  }

  void addDocuments(DocumentoModel documento, int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentoView(
          documento: documento,
        ),
      ),
    ).then((result) {
      if (idx == -1 && result.iDDOCUMENTO != null) {
        result.vISITANTEGUID = _visitanteModel.VISITANTEGUID;
        _listaDocumentos.add(result);
      }
      setState(() {});
    });
  }

  void _removeFromList(int idx) {
    if (_listaDocumentos[idx].iDDOCUMENTO > 0) {
      _listaDocumentosDelete.add(_listaDocumentos[idx]);
    }
    _listaDocumentos.removeAt(idx);
    setState(() {});
  }
}

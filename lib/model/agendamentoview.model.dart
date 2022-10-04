import 'package:rbdevvisitasapp/functions/fn_business.dart';
import 'package:rbdevvisitasapp/functions/fn_utils.dart';
import 'package:rbdevvisitasapp/model/agendamento.model.dart';
import 'package:intl/intl.dart';

class AgendamentoViewModel extends AgendamentoModel {
  String aGENDAHORARIOTURNO;
  String data;
  String aGENDADATA;
  String horarioInicio;
  String horarioTermino;
  String ala;
  String cela;
  String internoNome;
  String unidadeNome;

  String getHorarioInicioForm() {
    var _inicio = DateTime.parse(this.horarioInicio);
    return DateFormat.Hm().format(_inicio);
  }

  String getHorarioTerminoForm() {
    var _termino = DateTime.parse(this.horarioTermino);
    return DateFormat.Hm().format(_termino);
  }

  String getHorarioAmigavel() {
    var _horario = "";
    _horario += toBrazilianDate(this.aGENDADATA);
    _horario += " - " + getNomeTurno(this.aGENDAHORARIOTURNO);
    _horario += " (" + this.getHorarioInicioForm();
    _horario += " às " + this.getHorarioTerminoForm() + ")";
    return _horario;
  }

  String getNomeInterno() {
    if (this.internoNome != null && this.internoNome.isNotEmpty) {
      return this.internoNome;
    } else if (this.iNTERNONOMELIVRE != null &&
        this.iNTERNONOMELIVRE.isNotEmpty) {
      return this.iNTERNONOMELIVRE;
    }
    return "N/A";
  }

  String getTipoVisitaNome() {
    var _tipoNome = "";
    getAllTipoVisita().forEach((el) {
      if (el.tipo == this.tIPODEVISITA) {
        _tipoNome = el.nome;
      }
    });
    return _tipoNome;
  }

  String getNomeUnidade() {
    var _nomeUnidade = "";
    if (this.unidadeNome != null && this.unidadeNome.isNotEmpty) {
      _nomeUnidade = this.unidadeNome;
    } else {
      _nomeUnidade = "N/A";
    }
    return _nomeUnidade;
  }

  AgendamentoViewModel.fromJson(Map<String, dynamic> json) {
    aGENDAMENTOSID = json['AGENDAMENTOS_ID'];
    pESSOAID = json['PESSOA_ID'];
    tIPODEVISITA = json['TIPO_DE_VISITA'];
    uNICODIGO = json['UNI_CODIGO'];
    aGENDAID = json['AGENDA_ID'];
    aGENDAMENTOSDATA = stringToDate(json['AGENDAMENTOS_DATA']);
    uSRLOGIN = json['USR_LOGIN'];
    aGENDAHORARIOID = json['AGENDA_HORARIO_ID'];
    iNTERNOVISITANTEID = json['INTERNO_VISITANTE_ID'];
    iNTERNONOMELIVRE = json['INTERNO_NOME_LIVRE'];
    tELEFONEVISITANTE = json['TELEFONE_VISITANTE'];
    eXTRA = json['EXTRA'];

    aGENDAHORARIOTURNO = json['AGENDA_HORARIO_TURNO'];
    data = json['Data'];
    aGENDADATA = json['AGENDA_DATA'];
    horarioInicio = json['AGENDA_HORARIO_INICIO'];
    horarioTermino = json['AGENDA_HORARIO_TERMINO'];
    ala = json['ALA_DESCRICAO'];
    cela = json['CELA_DESCRICAO'];
    internoNome = json['INTERNO_NOME'];
    unidadeNome = json['UNI_NOME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AGENDAMENTOS_ID'] = this.aGENDAMENTOSID;
    data['PESSOA_ID'] = this.pESSOAID;
    data['TIPO_DE_VISITA'] = this.tIPODEVISITA;
    data['UNI_CODIGO'] = this.uNICODIGO;
    data['AGENDA_ID'] = this.aGENDAID;
    data['AGENDAMENTOS_DATA'] = this.aGENDAMENTOSDATA != null
        ? this.aGENDAMENTOSDATA.toIso8601String()
        : null;
    data['USR_LOGIN'] = this.uSRLOGIN;
    data['AGENDA_HORARIO_ID'] = this.aGENDAHORARIOID;
    data['INTERNO_VISITANTE_ID'] = this.iNTERNOVISITANTEID;
    data['INTERNO_NOME_LIVRE'] = this.iNTERNONOMELIVRE;
    data['TELEFONE_VISITANTE'] = this.tELEFONEVISITANTE;
    data['EXTRA'] = this.eXTRA;

    data['AGENDA_HORARIO_TURNO'] = this.aGENDAHORARIOTURNO;
    data['Data'] = this.data;
    data['AGENDA_DATA'] = this.aGENDADATA;
    data['AGENDA_HORARIO_INICIO'] = this.horarioInicio;
    data['AGENDA_HORARIO_TERMINO'] = this.horarioTermino;
    data['ALA_DESCRICAO'] = this.ala;
    data['CELA_DESCRICAO'] = this.cela;
    data['INTERNO_NOME'] = this.internoNome;
    data['UNI_NOME'] = this.unidadeNome;

    return data;
  }
}

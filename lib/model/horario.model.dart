import 'package:intl/intl.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';

class HorarioModel {
  int aGENDAID;
  String tIPODEVISITA;
  String aGENDAHORARIOTURNO;
  String data;
  int aGENDADOS;
  int vAGAS;
  int sALDO;
  String aGENDADATA;
  String aGENDADATALIMITE;
  int aGENDAHORARIOID;
  String horarioInicio;
  String horarioTermino;
  String ala;
  String cela;

  String getHorarioInicioForm(){
    var _inicio = DateTime.parse(this.horarioInicio);
    return DateFormat.Hm().format(_inicio);
  }

  String getHorarioTerminoForm(){
    var _termino = DateTime.parse(this.horarioTermino);
    return DateFormat.Hm().format(_termino);
  }

  String getHorarioAmigavel(){
    var _horario = "";
    if (this.aGENDAID == null || this.aGENDAID <= 0) {
      return _horario;
    }else{
      _horario += this.aGENDADATA;
      _horario += " - " + getNomeTurno(this.aGENDAHORARIOTURNO);
      _horario += " (" + this.getHorarioInicioForm();
      _horario += " às " + this.getHorarioTerminoForm() + ")";
    }
    return _horario;
  }

  HorarioModel(
      {this.aGENDAID,
      this.tIPODEVISITA,
      this.aGENDAHORARIOTURNO,
      this.data,
      this.aGENDADOS,
      this.vAGAS,
      this.sALDO,
      this.aGENDADATA,
      this.aGENDADATALIMITE,
      this.aGENDAHORARIOID,
      this.horarioInicio,
      this.horarioTermino,
      this.ala,
      this.cela});

  HorarioModel.fromJson(Map<String, dynamic> json) {
    aGENDAID = json['AGENDA_ID'];
    tIPODEVISITA = json['TIPO_DE_VISITA'];
    aGENDAHORARIOTURNO = json['AGENDA_HORARIO_TURNO'];
    data = json['Data'];
    aGENDADOS = json['AGENDADOS'];
    vAGAS = json['VAGAS'];
    sALDO = json['SALDO'];
    aGENDADATA = json['AGENDA_DATA'];
    aGENDADATALIMITE = json['AGENDA_DATA_LIMITE'];
    aGENDAHORARIOID = json['AGENDA_HORARIO_ID'];
    horarioInicio = json['AGENDA_HORARIO_INICIO'];
    horarioTermino = json['AGENDA_HORARIO_TERMINO'];
    ala = json['ALA_DESCRICAO'];
    cela = json['CELA_DESCRICAO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AGENDA_ID'] = this.aGENDAID;
    data['TIPO_DE_VISITA'] = this.tIPODEVISITA;
    data['AGENDA_HORARIO_TURNO'] = this.aGENDAHORARIOTURNO;
    data['Data'] = this.data;
    data['AGENDADOS'] = this.aGENDADOS;
    data['VAGAS'] = this.vAGAS;
    data['SALDO'] = this.sALDO;
    data['AGENDA_DATA'] = this.aGENDADATA;
    data['AGENDA_DATA_LIMITE'] = this.aGENDADATALIMITE;
    data['AGENDA_HORARIO_ID'] = this.aGENDAHORARIOID;
    data['AGENDA_HORARIO_INICIO'] = this.horarioInicio;
    data['AGENDA_HORARIO_TERMINO'] = this.horarioTermino;
    data['ALA_DESCRICAO'] = this.ala;
    data['CELA_DESCRICAO'] = this.cela;
    return data;
  }
}

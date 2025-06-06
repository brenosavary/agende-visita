import 'package:rbdevvisitasapp/functions/fn_utils.dart';

class AgendamentoModel {
  int _aGENDAMENTOSID;
  int _pESSOAID;
  String _tIPODEVISITA;
  int _uNICODIGO;
  int _aGENDAID;
  DateTime _aGENDAMENTOSDATA;
  String _uSRLOGIN;
  int _aGENDAHORARIOID;
  int _iNTERNOVISITANTEID;
  String _iNTERNONOMELIVRE;
  String _tELEFONEVISITANTE;
  String _eXTRA;
  int _uNICODIGOVISITANTE;

  AgendamentoModel(
      {int aGENDAMENTOSID,
      int pESSOAID,
      String tIPODEVISITA,
      int uNICODIGO,
      int aGENDAID,
      DateTime aGENDAMENTOSDATA,
      String uSRLOGIN,
      int aGENDAHORARIOID,
      int iNTERNOVISITANTEID,
      String iNTERNONOMELIVRE,
      String tELEFONEVISITANTE,
      String eXTRA,
      int uNICODIGOVISITANTE}) {
    this._aGENDAMENTOSID = aGENDAMENTOSID;
    this._pESSOAID = pESSOAID;
    this._tIPODEVISITA = tIPODEVISITA;
    this._uNICODIGO = uNICODIGO;
    this._aGENDAID = aGENDAID;
    this._aGENDAMENTOSDATA = aGENDAMENTOSDATA;
    this._uSRLOGIN = uSRLOGIN;
    this._aGENDAHORARIOID = aGENDAHORARIOID;
    this._iNTERNOVISITANTEID = iNTERNOVISITANTEID;
    this._iNTERNONOMELIVRE = iNTERNONOMELIVRE;
    this._tELEFONEVISITANTE = tELEFONEVISITANTE;
    this._eXTRA = eXTRA;
    this._uNICODIGOVISITANTE = uNICODIGOVISITANTE;
  }

  int get aGENDAMENTOSID => _aGENDAMENTOSID;
  set aGENDAMENTOSID(int aGENDAMENTOSID) => _aGENDAMENTOSID = aGENDAMENTOSID;

  int get pESSOAID => _pESSOAID;
  set pESSOAID(int pESSOAID) => _pESSOAID = pESSOAID;

  String get tIPODEVISITA => _tIPODEVISITA;
  set tIPODEVISITA(String tIPODEVISITA) => _tIPODEVISITA = tIPODEVISITA;

  int get uNICODIGO => _uNICODIGO;
  set uNICODIGO(int uNICODIGO) => _uNICODIGO = uNICODIGO;

  int get aGENDAID => _aGENDAID;
  set aGENDAID(int aGENDAID) => _aGENDAID = aGENDAID;

  DateTime get aGENDAMENTOSDATA => _aGENDAMENTOSDATA;
  set aGENDAMENTOSDATA(DateTime aGENDAMENTOSDATA) =>
      _aGENDAMENTOSDATA = aGENDAMENTOSDATA;

  String get uSRLOGIN => _uSRLOGIN;
  set uSRLOGIN(String uSRLOGIN) => _uSRLOGIN = uSRLOGIN;

  int get aGENDAHORARIOID => _aGENDAHORARIOID;
  set aGENDAHORARIOID(int aGENDAHORARIOID) =>
      _aGENDAHORARIOID = aGENDAHORARIOID;

  int get iNTERNOVISITANTEID => _iNTERNOVISITANTEID;
  set iNTERNOVISITANTEID(int iNTERNOVISITANTEID) =>
      _iNTERNOVISITANTEID = iNTERNOVISITANTEID;

  String get iNTERNONOMELIVRE => _iNTERNONOMELIVRE;
  set iNTERNONOMELIVRE(String iNTERNONOMELIVRE) =>
      _iNTERNONOMELIVRE = iNTERNONOMELIVRE;

  String get tELEFONEVISITANTE => _tELEFONEVISITANTE;
  set tELEFONEVISITANTE(String tELEFONEVISITANTE) =>
      _tELEFONEVISITANTE = tELEFONEVISITANTE;

  String get eXTRA => _eXTRA;
  set eXTRA(String eXTRA) => _eXTRA = eXTRA;

  int get uNICODIGOVISITANTE => _uNICODIGOVISITANTE;
  set uNICODIGOVISITANTE(int uNICODIGOVISITANTE) =>
      _uNICODIGOVISITANTE = uNICODIGOVISITANTE;

  AgendamentoModel.fromJson(Map<String, dynamic> json) {
    _aGENDAMENTOSID = json['AGENDAMENTOS_ID'];
    _pESSOAID = json['PESSOA_ID'];
    _tIPODEVISITA = json['TIPO_DE_VISITA'];
    _uNICODIGO = json['UNI_CODIGO'];
    _aGENDAID = json['AGENDA_ID'];
    _aGENDAMENTOSDATA = stringToDate(json['AGENDAMENTOS_DATA']);
    _uSRLOGIN = json['USR_LOGIN'];
    _aGENDAHORARIOID = json['AGENDA_HORARIO_ID'];
    _iNTERNOVISITANTEID = json['INTERNO_VISITANTE_ID'];
    _iNTERNONOMELIVRE = json['INTERNO_NOME_LIVRE'];
    _tELEFONEVISITANTE = json['TELEFONE_VISITANTE'];
    _eXTRA = json['EXTRA'];
    _uNICODIGOVISITANTE = json['UNI_CODIGO_VISITANTE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AGENDAMENTOS_ID'] = this._aGENDAMENTOSID;
    data['PESSOA_ID'] = this._pESSOAID;
    data['TIPO_DE_VISITA'] = this._tIPODEVISITA;
    data['UNI_CODIGO'] = this._uNICODIGO;
    data['AGENDA_ID'] = this._aGENDAID;
    data['AGENDAMENTOS_DATA'] = this._aGENDAMENTOSDATA != null
        ? this._aGENDAMENTOSDATA.toIso8601String()
        : null;
    data['USR_LOGIN'] = this._uSRLOGIN;
    data['AGENDA_HORARIO_ID'] = this._aGENDAHORARIOID;
    data['INTERNO_VISITANTE_ID'] = this._iNTERNOVISITANTEID;
    data['INTERNO_NOME_LIVRE'] = this._iNTERNONOMELIVRE;
    data['TELEFONE_VISITANTE'] = this._tELEFONEVISITANTE;
    data['EXTRA'] = this._eXTRA;
    data['UNI_CODIGO_VISITANTE'] = this._uNICODIGOVISITANTE;
    return data;
  }
}

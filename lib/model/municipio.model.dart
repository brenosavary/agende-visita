class MunicipioModel {
  int _cIDCODIGO;
  String _cIDADECIDNOME;
  String _cIDADEUF;

  MunicipioModel({int cIDCODIGO, String cIDADECIDNOME, String cIDADEUF}) {
    this._cIDCODIGO = cIDCODIGO;
    this._cIDADECIDNOME = cIDADECIDNOME;
    this._cIDADEUF = cIDADEUF;
  }

  int get cIDCODIGO => _cIDCODIGO;
  set cIDCODIGO(int cIDCODIGO) => _cIDCODIGO = cIDCODIGO;
  String get cIDADECIDNOME => _cIDADECIDNOME;
  set cIDADECIDNOME(String cIDADECIDNOME) => _cIDADECIDNOME = cIDADECIDNOME;
  String get cIDADEUF => _cIDADEUF;
  set cIDADEUF(String cIDADEUF) => _cIDADEUF = cIDADEUF;

  MunicipioModel.fromJson(Map<String, dynamic> json) {
    _cIDCODIGO = json['CID_CODIGO'];
    _cIDADECIDNOME = json['CID_NOME'];
    _cIDADEUF = json['UF'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CID_CODIGO'] = this._cIDCODIGO;
    data['CID_NOME'] = this._cIDADECIDNOME;
    data['UF'] = this._cIDADEUF;
    return data;
  }
}

class TipoDocumentoModel {
  int _iDTPDOCUMENTO;
  String _nOMEDOCUMENTO;
  String _oBRIGATORIO;
  String _vERSO;

  TipoDocumentoModel(
      {int iDTPDOCUMENTO,
        String nOMEDOCUMENTO,
        String oBRIGATORIO,
        String vERSO}) {
    this._iDTPDOCUMENTO = iDTPDOCUMENTO;
    this._nOMEDOCUMENTO = nOMEDOCUMENTO;
    this._oBRIGATORIO = oBRIGATORIO;
    this._vERSO = vERSO;
  }

  int get iDTPDOCUMENTO => _iDTPDOCUMENTO;
  set iDTPDOCUMENTO(int iDTPDOCUMENTO) => _iDTPDOCUMENTO = iDTPDOCUMENTO;
  String get nOMEDOCUMENTO => _nOMEDOCUMENTO;
  set nOMEDOCUMENTO(String nOMEDOCUMENTO) => _nOMEDOCUMENTO = nOMEDOCUMENTO;
  String get oBRIGATORIO => _oBRIGATORIO;
  set oBRIGATORIO(String oBRIGATORIO) => _oBRIGATORIO = oBRIGATORIO;
  String get vERSO => _vERSO;
  set vERSO(String vERSO) => _vERSO = vERSO;

  TipoDocumentoModel.fromJson(Map<String, dynamic> json) {
    _iDTPDOCUMENTO = json['ID_TP_DOCUMENTO'];
    _nOMEDOCUMENTO = json['NOME_DOCUMENTO'];
    _oBRIGATORIO = json['OBRIGATORIO'];
    _vERSO = json['VERSO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_TP_DOCUMENTO'] = this._iDTPDOCUMENTO;
    data['NOME_DOCUMENTO'] = this._nOMEDOCUMENTO;
    data['OBRIGATORIO'] = this._oBRIGATORIO;
    data['VERSO'] = this._vERSO;
    return data;
  }
}
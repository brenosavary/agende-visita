class DocumentoModel {
  int _iDDOCUMENTO;
  String _dOCFRENTE;
  String _dOCFUNDO;
  int _tIPODOCUMENTO;
  String _vISITANTEGUID;

  DocumentoModel(
      {int iDDOCUMENTO,
        String dOCFRENTE,
        String dOCFUNDO,
        int tIPODOCUMENTO,
        String vISITANTEGUID}) {
    this._iDDOCUMENTO = iDDOCUMENTO;
    this._dOCFRENTE = dOCFRENTE;
    this._dOCFUNDO = dOCFUNDO;
    this._tIPODOCUMENTO = tIPODOCUMENTO;
    this._vISITANTEGUID = vISITANTEGUID;
  }

  int get iDDOCUMENTO => _iDDOCUMENTO;
  set iDDOCUMENTO(int iDDOCUMENTO) => _iDDOCUMENTO = iDDOCUMENTO != null ? iDDOCUMENTO : 0;
  String get dOCFRENTE => _dOCFRENTE;
  set dOCFRENTE(String dOCFRENTE) => _dOCFRENTE = dOCFRENTE;
  String get dOCFUNDO => _dOCFUNDO;
  set dOCFUNDO(String dOCFUNDO) => _dOCFUNDO = dOCFUNDO;
  int get tIPODOCUMENTO => _tIPODOCUMENTO;
  set tIPODOCUMENTO(int tIPODOCUMENTO) => _tIPODOCUMENTO = tIPODOCUMENTO;
  String get vISITANTEGUID => _vISITANTEGUID;
  set vISITANTEGUID(String vISITANTEGUID) => _vISITANTEGUID = vISITANTEGUID;

  DocumentoModel.fromJson(Map<String, dynamic> json) {
    _iDDOCUMENTO = json['ID_DOCUMENTO'];
    _dOCFRENTE = json['DOC_FRENTE'];
    _dOCFUNDO = json['DOC_FUNDO'];
    _tIPODOCUMENTO = json['TIPO_DOCUMENTO'];
    _vISITANTEGUID = json['VISITANTE_GUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_DOCUMENTOS'] = this._iDDOCUMENTO;
    data['DOC_FRENTE'] = this._dOCFRENTE;
    data['DOC_FUNDO'] = this._dOCFUNDO;
    data['TIPO_DOCUMENTO'] = this._tIPODOCUMENTO;
    data['VISITANTE_GUID'] = this._vISITANTEGUID;
    return data;
  }
}

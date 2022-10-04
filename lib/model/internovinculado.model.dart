class InternoVinculadoModel{
  String PES_NOME;
  int ID;
  int UNI_CODIGO;

  InternoVinculadoModel.fromJson(Map<String, dynamic> json) {
    PES_NOME = json['PES_NOME'];
    ID = json['ID'];
    UNI_CODIGO = json['UNI_CODIGO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PES_NOME'] = this.PES_NOME;
    data['ID'] = this.ID;
    data['UNI_CODIGO'] = this.UNI_CODIGO;
    return data;
  }

}


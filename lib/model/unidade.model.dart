class UnidadeModel {
  int idUnidade;
  String nomeUnidade;
  int idAgenda;

  UnidadeModel(this.idUnidade, this.nomeUnidade, this.idAgenda);

  UnidadeModel.fromJson(Map<String, dynamic> json) {
    idUnidade = json['idUnidade'];
    nomeUnidade = json['nomeUnidade'];
    idAgenda = json['idAgenda'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UNI_CODIGO'] = this.idUnidade;
    data['UNI_NOME'] = this.nomeUnidade;
    data['AGENDA_ID'] = this.idAgenda;
    return data;
  }
}

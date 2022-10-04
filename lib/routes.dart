import 'package:flutter/widgets.dart';
import 'package:rbdevvisitasapp/screens/agendamento.view.dart';
import 'package:rbdevvisitasapp/screens/meusagendamentos.view.dart';
import 'package:rbdevvisitasapp/screens/documento.view.dart';
import 'package:rbdevvisitasapp/screens/ui_atualizarsenha.dart';
import 'package:rbdevvisitasapp/screens/ui_denuncia.dart';
import 'package:rbdevvisitasapp/screens/ui_esquecisenha.dart';
import 'package:rbdevvisitasapp/screens/ui_home.dart';
import 'package:rbdevvisitasapp/screens/ui_login.dart';
import 'package:rbdevvisitasapp/screens/visitante.view.dart';

import 'consts/consts.dart';

final appRoutes = <String, WidgetBuilder>{
  '/login': (BuildContext context) => new LoginPage(),
  '/home': (BuildContext context) => new HomeViewPage(),
  '/denuncia': (BuildContext context) => new DenunciaPage(),
  '/esquecisenha': (BuildContext context) => new EsqueciSenhaPage(),
  '/atualizarsenha': (BuildContext context) => new AtualizarSenhaPage(),
  '/cadastrese': (BuildContext context) => new VisitanteView(operacao: Operacao.incluir),
  '/meusdados': (BuildContext context) => new VisitanteView(operacao: Operacao.editar),
  '/documentos': (BuildContext context) => new DocumentoView(documento: null),
  '/agendamentos': (BuildContext context) => new MeusAgendamentosView(),
  '/novoagendamento': (BuildContext context) => new AgendamentoView(),
};

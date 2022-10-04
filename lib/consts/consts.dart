import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:package_info/package_info.dart';
import 'package:uuid/uuid.dart';

//Cores primárias
final mainColor = Colors.white;
final mainFontColor = Colors.black;

//Cores secundárias
final secondColor = Colors.green;
final secondFontColor = Colors.white;

final markedColor = Colors.lightBlueAccent;
final unMarkedColor = Colors.white;
final iconColor = Colors.white;

final defaultFontFamily = "Rock Salt";
final defaultMargin = const EdgeInsets.only(left: 30, right: 30);
final defaultMargin10 = const EdgeInsets.only(left: 10, right: 10);
final defaultMargin20 = const EdgeInsets.only(left: 20, right: 20);
final defaultMarginAll = const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30);
final defaultMarginAll5 = const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5);
final defaultBorderAll = const BorderRadius.all(Radius.circular(5));
final separadorH5 = const SizedBox(height: 5);
final separadorH8 = const SizedBox(height: 8);
final separadorH10 = const SizedBox(height: 10);
final separadorH20 = const SizedBox(height: 20);
final bordaDireita = const Border(
  left: BorderSide.none,
  right: BorderSide(color: Colors.grey, width: 1.0),
);

final bordaBase = const Border(
  bottom: BorderSide(color: Colors.red, width: 1.0),
  left: BorderSide.none,
);

final defaultLoading = SpinKitDualRing(
  color: secondColor,
  size: 50.0,
);

final navigatorKey = GlobalKey<NavigatorState>();
final Map<String, String> deviceData = Map();
final uuid = Uuid();

final maskCpf = MaskTextInputFormatter(
    mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});

final maskTelefone = MaskTextInputFormatter(
    mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});

final maskCEP = MaskTextInputFormatter(
    mask: "##.###-###", filter: {"#": RegExp(r'[0-9]')});

//Acesso rápido
enum AcessoRapido {
  vagas,
  avisos,
  meusDados,
  denuncia,
  agendamentos
}

enum Operacao{
  incluir,
  editar
}

//ENUMS
final sysCode = "AGD";

//Non-final consts
Map<String, String> headerPadrao = {"Content-Type": "application/json"};
dynamic dadosUsuario = {};
List<dynamic> listaVagas = [];
List<dynamic> listaVinculados = [];
PackageInfo packageInfo;

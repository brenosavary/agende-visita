import 'dart:convert';
import 'dart:ui';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';
import 'package:rbdevvisitasapp/functions/fn_business.dart';

class Vagas extends StatelessWidget {
  final List<dynamic> listaAvisos;

  Vagas(this.listaAvisos);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          separadorH10,
          Text(
            'Vagas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          separadorH10,
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 215,
                  margin: defaultMarginAll5,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: listaAvisos.length,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic ds = jsonDecode(listaAvisos[index]);
                      List<dynamic> vagas = ds['vagas'];
                      return ExpandablePanel(
                        collapsed: null,
                        header: ClipRRect(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(30.0)),
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(6.5),
                            margin: const EdgeInsets.all(1.5),
                            alignment: Alignment.center,
                            child: Text(
                              ds['nomeUnidade'],
                              style: TextStyle(
                                fontSize: 14,
                                color: vagas.isEmpty
                                    ? Colors.black38
                                    : Colors.green,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[50],
                              border: Border(
                                left:
                                    BorderSide(width: 9.0, color: Colors.green),
                              ),
                            ),
                          ),
                        ),
                        expanded: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            horizontalMargin: 12,
                            showBottomBorder: true,
                            dividerThickness: 2.5,
                            //minWidth: 600,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Turno',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Dia',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Agendados',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text(
                                  'Vagas Totais',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text(
                                  'Vagas Restantes',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text(
                                  'Data',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Data/Hora limite',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Agendar',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(vagas.length, (index) {
                              dynamic vaga = vagas[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      getNomeTurno(
                                          vaga['AGENDA_HORARIO_TURNO']),
                                    ),
                                  ),
                                  DataCell(Text(vaga['Data'])),
                                  DataCell(Text(vaga['AGENDADOS'].toString())),
                                  DataCell(Text(vaga['VAGAS'].toString())),
                                  DataCell(Text(vaga['SALDO'].toString())),
                                  DataCell(Text(vaga['AGENDA_DATA'])),
                                  DataCell(Text(vaga['AGENDA_DATA_LIMITE'])),
                                  DataCell(
                                    TextButton(
                                      child: Icon(
                                        Icons.access_time_outlined,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        agendar(context);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('SAIR'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

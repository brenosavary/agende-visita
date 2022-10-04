import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rbdevvisitasapp/consts/consts.dart';

class Avisos extends StatelessWidget {
  final List<dynamic> listaAvisos;

  Avisos(this.listaAvisos);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          separadorH10,
          Text(
            'Avisos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 215,
                  margin: defaultMarginAll,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listaAvisos.length,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic ds = listaAvisos[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.black12 : Colors.white,
                          borderRadius: defaultBorderAll,
                        ),
                        child: Text(
                          ds['AVISO_DESCRICAO'],
                          softWrap: true,
                          maxLines: 15,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.justify,
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

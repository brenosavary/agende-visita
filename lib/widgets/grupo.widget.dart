import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GrupoWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  GrupoWidget({
    this.icon,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(this.icon),
          ),
          Text(
            this.title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

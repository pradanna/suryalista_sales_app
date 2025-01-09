import 'package:flutter/material.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';

class Genospadding extends StatelessWidget {
  final Widget child;

  const Genospadding({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:  marginHorizontal),
      child: child,
    );
  }
}

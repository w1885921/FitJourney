import 'package:flutter/material.dart';


class BuildCircularProgressIndicator extends StatelessWidget {
  final double? value;
  final Color color;
  const BuildCircularProgressIndicator({
    Key? key,
    this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        value: value,
      ),
    );
  }
}

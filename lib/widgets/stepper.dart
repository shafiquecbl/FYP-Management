import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';

class Steps extends StatelessWidget {
  Steps(
      {@required this.step,
      @required this.iconColor,
      @required this.text,
      @required this.textColor});
  final int step;
  final String text;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      // direction: Axis.horizontal,
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
          child: Center(
              child: Text(
            '$step',
            style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.bold, color: kWhiteColor),
          )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
        Container(
          color: greyColor,
          height: 1,
          width: 60,
        ),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }
}

class LastStep extends StatelessWidget {
  LastStep(
      {@required this.step,
      @required this.iconColor,
      @required this.text,
      @required this.textColor});
  final int step;
  final String text;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      // direction: Axis.horizontal,
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
          child: Center(
              child: Text(
            '$step',
            style: TextStyle(
                fontSize: 8, fontWeight: FontWeight.bold, color: kWhiteColor),
          )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      ],
    );
  }
}

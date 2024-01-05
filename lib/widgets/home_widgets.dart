import 'package:flutter/material.dart';

import 'hspace.dart';


class CustomProgressBar extends StatelessWidget {
  final List<double> values;
  final List<Color> colors;

  CustomProgressBar({required this.values, required this.colors});

  @override
  Widget build(BuildContext context) {
    final totalSum = values.reduce((a, b) => a + b);

    return Row(
      children: values.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;
        final ratio = value / totalSum;

        return Flexible(
          flex: (ratio * 100).round(),
          child: Container(
            color: colors[index % colors.length],
          ),
        );
      }).toList(),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CommonContributionRow extends StatelessWidget {
  const CommonContributionRow({
    super.key,
    required this.leftText,
    required this.rightText,
    required this.color,
  });

  final String leftText;
  final String rightText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          maxRadius: 5,
        ),
        HSpace(10),
        Expanded(
          child: Text(
            leftText,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 18, color: Color(0xff2d2c79)),
          ),
        ),
        Text(
          rightText,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontSize: 18, color: Color(0xff2d2c79)),
        ),
      ],
    );
  }
}

class CommonMoneyRow extends StatelessWidget {
  const CommonMoneyRow({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  final String leftText;
  final String rightText;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            leftText,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white, fontSize: 16),
          ),
        ),
        Text(
          rightText,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double completedPercentage;

  ProgressBarPainter({required this.completedPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..strokeWidth = 10.0
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2),
      2.2, // start angle
      5.0, // sweep angle
      false,
      backgroundPaint,
    );

    Paint foregroundPaint = Paint()
      ..strokeWidth = 10.0
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2),
      2.2, // start angle
      5.0 * (completedPercentage / 100), // sweep angle
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

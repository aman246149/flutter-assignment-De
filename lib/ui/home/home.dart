import 'package:flutter/material.dart';
import 'package:ispy/widgets/hspace.dart';
import 'package:ispy/widgets/vspace.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 80).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff2d2c79),
        body: SingleChildScrollView(
          child: Column(
            children: [
              VSpace(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Buy a dream house",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 35, color: Colors.white),
                ),
              ),
              VSpace(80),
              AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget? child) {
                  return Container(
                    height: 200,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: CustomPaint(
                      painter: ProgressBarPainter(
                          completedPercentage: _animation.value),
                      child: Column(
                        children: [
                          Icon(
                            Icons.home,
                            size: 100,
                            color: Colors.white,
                          ),
                          Text(
                            "\$25,000",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 40, color: Colors.white),
                          ),
                          Text(
                            "You Saved",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              VSpace(80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Goal",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 30, color: Colors.white),
                          ),
                          Text(
                            "by Jan 2030",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "\$50,0000",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ),
              ),
              VSpace(20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xff256cea),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    CommonMoneyRow(
                      leftText: "Need more savings",
                      rightText: "\$25,000",
                    ),
                    VSpace(10),
                    CommonMoneyRow(
                      leftText: "Monthly Saving Projection",
                      rightText: "\$250",
                    ),
                  ],
                ),
              ),
              VSpace(30),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Contributions",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Shown History",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontSize: 18, color: Color(0xff2d2c79)),
                        ),
                      ],
                    ),
                    VSpace(20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 10,
                        width: double.infinity,
                        child: CustomProgressBar(
                          values: [200, 300, 200],
                          colors: [Colors.red, Colors.green, Colors.blue],
                        ),
                      ),
                    ),
                    VSpace(20),
                    CommonContributionRow(
                      leftText: "Monthly Saving",
                      rightText: "\$200",
                      color: Colors.red,
                    ),
                    VSpace(10),
                    CommonContributionRow(
                      leftText: "One Time Saving",
                      rightText: "\$300",
                      color: Colors.green,
                    ),
                    VSpace(10),
                    CommonContributionRow(
                      leftText: "Weekly Saving",
                      rightText: "\$300",
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final List<num> values;
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

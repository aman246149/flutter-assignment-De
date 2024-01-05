import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ispy/data/data.dart';
import 'package:ispy/repository/home_repository.dart';
import 'package:ispy/utils/util.dart';
import 'package:ispy/widgets/hspace.dart';
import 'package:ispy/widgets/vspace.dart';

import '../../widgets/home_widgets.dart';

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
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // _animation = Tween<double>(begin: 0, end: 80).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    // _controller.forward();
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     insertDataToFirebase();
        //   },
        // ),
        backgroundColor: Color(0xff2d2c79),
        body: StreamBuilder(
            stream: HomeRepository().getGoals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                return PageView.builder(
                    itemCount: snapshot.data!.docs.length,
                    onPageChanged: (index) {
                      _controller.reset();

                      _controller.forward();
                    },
                    itemBuilder: (context, index) {
                      Goal goal =
                          Goal.fromJson(snapshot.data!.docs[index].data());

                      _animation = Tween<double>(
                              begin: 0,
                              end: goal.totalSaved / goal.targetAmount * 100)
                          .animate(_controller)
                        ..addListener(() {});

                      _controller.forward();

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            VSpace(30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                goal.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 35, color: Colors.white),
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
                                          formattedCurrency(goal.totalSaved),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 40,
                                                  color: Colors.white),
                                        ),
                                        Text(
                                          "You Saved",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 20,
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            VSpace(80),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Goal",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 30,
                                                  color: Colors.white),
                                        ),
                                        Text(
                                          "by ${DateFormat('MMM yyyy').format(goal.expectedDate)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 20,
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formattedCurrency(goal.targetAmount),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize: 30, color: Colors.white),
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
                                    rightText:
                                        "\$${(goal.targetAmount - goal.totalSaved).toStringAsFixed(2)}",
                                  ),
                                  VSpace(10),
                                  CommonMoneyRow(
                                    leftText: "Monthly Saving Projection",
                                    rightText: goal.totalSaved >=
                                            goal.targetAmount
                                        ? "Goal reached"
                                        : monthsLeft(goal.expectedDate) <= 0
                                            ? "Expected date passed"
                                            : "\$${((goal.targetAmount - goal.totalSaved) / monthsLeft(goal.expectedDate)).toStringAsFixed(2)}",
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
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
                                        "Shown History",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontSize: 18,
                                                color: Color(0xff2d2c79)),
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
                                        values: goal.contributionHistory
                                            .map((e) => e.amount.toDouble())
                                            .toList(),
                                        colors: goal.contributionHistory
                                            .map((e) => HexColor(e.colorCode))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  VSpace(20),
                                  ...List.generate(
                                    goal.contributionHistory.length,
                                    (index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: CommonContributionRow(
                                        leftText: goal
                                            .contributionHistory[index].title,
                                        rightText: formattedCurrency(goal
                                            .contributionHistory[index].amount),
                                        color: HexColor(goal
                                            .contributionHistory[index]
                                            .colorCode),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }

              return Center(
                child: Text("No data found"),
              );
            }),
      ),
    );
  }

  int monthsLeft(DateTime expectedDate) {
    final currentDate = DateTime.now();
    return ((expectedDate.year - currentDate.year) * 12) +
        expectedDate.month -
        currentDate.month;
  }
}

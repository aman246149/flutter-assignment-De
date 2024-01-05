import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String name;
  final double targetAmount;
  final double totalSaved;
  final DateTime expectedDate;
  final List<Contribution> contributionHistory;

  Goal({
    required this.name,
    required this.targetAmount,
    required this.totalSaved,
    required this.expectedDate,
    required this.contributionHistory,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'totalSaved': totalSaved,
      'expectedDate': Timestamp.fromDate(expectedDate),
      'contributionHistory': contributionHistory
          .map((contribution) => contribution.toJson())
          .toList(),
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      name: json['name'],
      targetAmount: json['targetAmount'],
      totalSaved: json['totalSaved'],
      expectedDate: (json['expectedDate'] as Timestamp).toDate(),
      contributionHistory: (json['contributionHistory'] as List)
          .map((i) => Contribution.fromJson(i))
          .toList(),
    );
  }
}

class Contribution {
  final double amount;
  final DateTime date;
  final String title;
  final String colorCode;

  Contribution({
    required this.amount,
    required this.date,
    required this.title,
    required this.colorCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'title': title,
      'colorCode': colorCode,
    };
  }

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      amount: json['amount'],
      date: (json['date'] as Timestamp).toDate(),
      title: json['title'],
      colorCode: json['colorCode'],
    );
  }
}

List<Goal> dummyGoals = [
  Goal(
    name: 'Buy a dream house',
    targetAmount: 300000,
    totalSaved: 50000,
    expectedDate: DateTime(2025, 12, 31),
    contributionHistory: [
      Contribution(
          amount: 10000,
          date: DateTime(2022, 1, 1),
          title: "Initial Saving",
          colorCode: "#FFC107"),
      Contribution(
          amount: 15000,
          date: DateTime(2022, 2, 1),
          title: "Monthly Saving",
          colorCode: "#E91E63"),
      Contribution(
          amount: 25000,
          date: DateTime(2022, 3, 1),
          title: "Tax Return Saving",
          colorCode: "#FF5722"),
    ],
  ),
  Goal(
    name: 'Vacation',
    targetAmount: 5000,
    totalSaved: 2500,
    expectedDate: DateTime(2026, 12, 31),
    contributionHistory: [
      Contribution(
          amount: 500,
          date: DateTime(2022, 1, 1),
          title: "New Year Saving",
          colorCode: "#FFC107"),
      Contribution(
          amount: 1000,
          date: DateTime(2022, 2, 1),
          title: "Monthly Saving",
          colorCode: "#E91E63"),
      Contribution(
          amount: 1000,
          date: DateTime(2022, 3, 1),
          title: "Weekly Saving",
          colorCode: "#FF5722"),
    ],
  ),
  Goal(
    name: 'New Car',
    targetAmount: 30000,
    totalSaved: 15000,
    expectedDate: DateTime(2024, 6, 30),
    contributionHistory: [
      Contribution(
          amount: 2000,
          date: DateTime(2022, 1, 15),
          title: "Monthly Saving",
          colorCode: "#E91E63"),
      Contribution(
          amount: 3000,
          date: DateTime(2022, 2, 15),
          title: "One Time Saving",
          colorCode: "#FFC107"),
      Contribution(
          amount: 5000,
          date: DateTime(2022, 3, 15),
          title: "Weekly Saving",
          colorCode: "#FF5722"),
    ],
  ),
];

void insertDataToFirebase() async {
  CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');

  for (Goal goal in dummyGoals) {
    await goalsCollection.add(goal.toJson());
  }
}

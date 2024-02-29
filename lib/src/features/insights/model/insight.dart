import 'package:cloud_firestore/cloud_firestore.dart';

class Insight {
  final String pdf;
  final DateTime date;
  final String back;
  final String front;

  Insight({
    required this.pdf,
    required this.date,
    required this.back,
    required this.front,
  });

  factory Insight.fromJson(Map<String, dynamic> json) => Insight(
        pdf: json['pdf'] as String,
        date: (json['date'] as Timestamp).toDate(),
        back: json['back'] as String,
        front: json['front'] as String,
      );

  static Map<String, dynamic> toJson(Insight insight) => <String, dynamic>{
        'pdf': insight.pdf,
        'date': insight.date,
        'back': insight.back,
        'front': insight.front,
      };
}

import 'package:bambi_insights_calendar/src/features/insights/model/insight.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsightsRepository {
  static Stream<List<Insight>> getInsights() => FirebaseFirestore.instance
      .collection('insights')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Insight.fromJson(doc.data())).toList());

  static createNewInsight() {
    FirebaseFirestore.instance.collection('insights').add(Insight.toJson(Insight(
          pdf:
              'https://firebasestorage.googleapis.com/v0/b/bambi-insights-calendar.appspot.com/o/Pink%20and%20Beige%20Feminine%20Minimalist%20Business%20Coach%20Email%20Newsletter.pdf?alt=media&token=cfdec87c-f6c1-435d-a638-7bdba20754b8',
          date: DateTime(2024, 2, 29),
          back: 'ovo ce ici pozadi',
          front:
              'https://firebasestorage.googleapis.com/v0/b/bambi-insights-calendar.appspot.com/o/bambi-logo-old-min.png?alt=media&token=fac49d8c-38a1-408a-9086-92a8d605f0f1',
        )));
  }
}

import 'package:bambi_insights_calendar/src/config/colors.dart';
import 'package:bambi_insights_calendar/src/features/insights/data/insights_repo.dart';
import 'package:bambi_insights_calendar/src/widgets/flip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int workdaysCount = 0;

  @override
  void initState() {
    super.initState();
    getWorkdaysInCurrentMonth();
  }

  void getWorkdaysInCurrentMonth() {
    DateTime now = DateTime.now();
    int daysInCurrentMonth = 0;

    daysInCurrentMonth = DateTime(now.year, now.month + 1, 0).day;

    for (int day = 1; day <= daysInCurrentMonth; day++) {
      DateTime currentDay = DateTime(now.year, now.month, day);

      if (currentDay.weekday >= 1 && currentDay.weekday <= 5) {
        workdaysCount++;
      }
    }
  }

  int getNthWorkdayOfMonth(int nth) {
    final now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    int workdaysCount = 0;
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(now.year, now.month, day);
      if (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday) {
        workdaysCount++;
        if (workdaysCount == nth) {
          return day;
        }
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset('assets/bambi-logo.png'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: SvgPicture.asset('assets/ipsos.svg'),
                    ),
                  ],
                ),
                const Text(
                  'U&A Newsletter',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 120,
                ),
              ],
            ),
          )),
      body: StreamBuilder(
        stream: InsightsRepository.getInsights(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            final insights = snapshot.data;
            insights?.sort((a, b) => a.date.compareTo(b.date));

            return Padding(
              padding: const EdgeInsets.only(left: 60, right: 60, top: 48),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: workdaysCount,
                    itemBuilder: (context, index) {
                      int dayNumber = getNthWorkdayOfMonth(index + 1);

                      return Flip(
                        pdfUrl: insights?[index].pdf,
                        date: insights?[index].date,
                        firstChild: Container(
                          padding: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppStyle().getActiveColor(date: insights![index].date),
                          ),
                          alignment: Alignment.topRight,
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: insights[index].date.isBefore(DateTime.now())
                                      ? SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Image.network(
                                            insights[index].front,
                                          ))
                                      : const Icon(
                                          Icons.question_mark,
                                          size: 60,
                                          color: Colors.white,
                                        )),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Text(
                                  '$dayNumber',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        secondChild: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppStyle().getActiveColor(date: insights[index].date),
                          ),
                          child: Center(
                            child: Text(
                              insights[index].back,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 60,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: 700,
                  child: const Text.rich(
                    TextSpan(text: 'Drage kolege,', children: [
                      TextSpan(
                          text: '\n\nSvakog radnog dana kliknite za vašu DNEVNU DOZU INSAJTA.',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(
                          text:
                              '\n\nPutem našeg U&A Newsletter-a imate priliku da čitate zanimljive insajte o ponašanju potrošača za tržišta Srbije, Hrvatske, BiH (Republike Srpske i Federacije) čija je osnova Usage&Attitude istraživanje rađeno u septembru 2023. u saradnji sa IPSOS Agencijom.'),
                      TextSpan(
                          text: '\n\nA Category tim je tu da vas podseća da kliknete na vašu DNEVNU DOZU INSAJTA.'),
                      TextSpan(text: '\n\nUživajte  : )'),
                    ]),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ]),
            );
          }
        },
      ),
    );
  }
}

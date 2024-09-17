import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StudentInfoCard extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentInfoCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${student['first_name']} ${student['last_name']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Student Number: ${student['student_number']}'),
            Text('School: ${student['school']}'),
          ],
        ),
      ),
    );
  }
}

class AttendanceChart extends StatelessWidget {
  final List<dynamic> attendanceData;

  const AttendanceChart({super.key, required this.attendanceData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: PieChart(
              PieChartData(
                sections: attendanceData.map((data) => PieChartSectionData(
                  color: _getColorForStatus(data['status']),
                  value: data['value'].toDouble(),
                  title: '${data['status']}\n${data['value']}',
                  radius: 100,
                )).toList(),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Present': return Colors.green;
      case 'Absent': return Colors.red;
      case 'Late': return Colors.orange;
      case 'Excused': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

class PerformanceChart extends StatelessWidget {
  final List<dynamic> performanceData;

  const PerformanceChart({super.key, required this.performanceData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Performance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              performanceData[value.toInt()]['subject'],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: performanceData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value['grade'].toDouble(),
                          color: Colors.blue,
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentAttendanceList extends StatelessWidget {
  final List<dynamic> recentAttendance;

  const RecentAttendanceList({super.key, required this.recentAttendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Attendance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentAttendance.length,
              itemBuilder: (context, index) {
                final attendance = recentAttendance[index];
                return ListTile(
                  title: Text('${attendance['date']} - ${attendance['status']}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RecentPerformanceList extends StatelessWidget {
  final List<dynamic> recentPerformance;

  const RecentPerformanceList({super.key, required this.recentPerformance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Performance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentPerformance.length,
              itemBuilder: (context, index) {
                final performance = recentPerformance[index];
                return ListTile(
                  title: Text('${performance['subject']} - Grade: ${performance['grade']}'),
                  subtitle: Text('Date: ${performance['assessment_date']}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
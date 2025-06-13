import 'package:flutter/material.dart';
import 'report_service.dart';
import 'report.dart';

class AdminReportsScreen extends StatelessWidget {
  final ReportService _reportService = ReportService();

  AdminReportsScreen({Key? key}) : super(key: key);

  void _toggleResolved(BuildContext context, Report report) async {
    await _reportService.updateReportStatus(report.id, !report.resolved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(report.resolved
            ? 'تم وضع البلاغ كغير محلول'
            : 'تم وضع البلاغ كمحلول'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('البلاغات الواردة'),
      ),
      body: StreamBuilder<List<Report>>(
        stream: _reportService.getReportsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد بلاغات'));
          }
          final reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return ListTile(
                title: Text(report.description),
                subtitle: Text('المبلغ: ${report.reporterId}\nالمبلغ عنه: ${report.reportedUserId}'),
                trailing: IconButton(
                  icon: Icon(
                    report.resolved ? Icons.check_circle : Icons.error,
                    color: report.resolved ? Colors.green : Colors.red,
                  ),
                  onPressed: () => _toggleResolved(context, report),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
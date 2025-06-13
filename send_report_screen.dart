import 'package:flutter/material.dart';
import 'report_service.dart';

class SendReportScreen extends StatefulWidget {
  final String reporterId;
  final String reportedUserId;

  const SendReportScreen({
    Key? key,
    required this.reporterId,
    required this.reportedUserId,
  }) : super(key: key);

  @override
  State<SendReportScreen> createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSending = false;
  final ReportService _reportService = ReportService();

  void _sendReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      await _reportService.sendReport(
        reporterId: widget.reporterId,
        reportedUserId: widget.reportedUserId,
        description: _descriptionController.text.trim(),
      );

      setState(() => _isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال البلاغ بنجاح')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إرسال بلاغ')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'وصف المشكلة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'يرجى كتابة وصف البلاغ' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSending ? null : _sendReport,
                child: _isSending
                    ? CircularProgressIndicator()
                    : Text('إرسال البلاغ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
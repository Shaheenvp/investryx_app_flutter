import 'package:flutter/material.dart';


class ReportBottomSheet extends StatefulWidget {
  final Function(String reason, String details) onSubmit;

  const ReportBottomSheet({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String? selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  bool isSubmitting = false;

  final List<Map<String, dynamic>> reportReasons = [
    {
      'title': 'Spam or Misleading',
      'description': 'Repetitive, unwanted, or deceptive content',
      'value': 'spam',
      'icon': Icons.warning_rounded
    },
    {
      'title': 'Fraud or Scam',
      'description': 'Suspicious investment opportunities or financial scams',
      'value': 'fraud',
      'icon': Icons.gpp_bad_rounded
    },
    {
      'title': 'Inappropriate Content',
      'description': 'Content that violates community guidelines',
      'value': 'inappropriate',
      'icon': Icons.block_rounded
    },
    {
      'title': 'Harassment',
      'description': 'Abusive or threatening behavior',
      'value': 'harassment',
      'icon': Icons.person_off_rounded
    },
    {
      'title': 'False Information',
      'description': 'Incorrect or misleading investment details',
      'value': 'false_info',
      'icon': Icons.info_rounded
    }
  ];

  void _handleSubmit() async {
    if (selectedReason == null) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      await widget.onSubmit(
        selectedReason!,
        _detailsController.text,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit report: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.flag_rounded,
                      color: Colors.red.shade700,
                      size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'Report Content',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Why are you reporting this?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...reportReasons.map((reason) => Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedReason == reason['value']
                            ? Colors.yellow.shade600
                            : Colors.grey.shade200,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: selectedReason == reason['value']
                          ? Colors.yellow.shade50
                          : Colors.white,
                    ),
                    child: RadioListTile(
                      title: Row(
                        children: [
                          Icon(
                            reason['icon'] as IconData,
                            color: Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            reason['title'],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          reason['description'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      value: reason['value'],
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value.toString();
                        });
                      },
                      activeColor: Colors.yellow.shade600,
                    ),
                  )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _detailsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Additional Details (Optional)',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        hintText: 'Please provide any additional context...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.yellow.shade600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child:ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: selectedReason == null || isSubmitting
                        ? null
                        : _handleSubmit,
                    child: isSubmitting
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                        : const Text('Submit Report'),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }
}

class ReportButton extends StatelessWidget {
  final Function(String reason, String reasonType, String id) onSubmit;
  final String postId;

  const ReportButton({Key? key, required this.onSubmit, required this.postId})
      : super(key: key);

  void _showReportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => ReportBottomSheet(
          onSubmit: (reason, details) => onSubmit(reason, details, postId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showReportBottomSheet(context),
      icon: Icon(Icons.flag_rounded, color: Colors.red.shade600),
      label: Text(
        'Report',
        style: TextStyle(color: Colors.red.shade600),
      ),
    );
  }
}

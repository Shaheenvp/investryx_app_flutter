import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

class AppColors {
  static const primary = Color(0xFFFFD700);
  static const primaryDark = Color(0xFFFFBA08);
  static const accent = Color(0xFF2D2D2D);
  static const background = Color(0xFFFFFDF7);
  static const textDark = Color(0xFF1A1A1A);
  static const textLight = Color(0xFF757575);
}

class BusinessProposalScreen extends StatefulWidget {
  const BusinessProposalScreen({Key? key}) : super(key: key);

  @override
  _BusinessProposalScreenState createState() => _BusinessProposalScreenState();
}

class _BusinessProposalScreenState extends State<BusinessProposalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  bool _showPreview = false;
  File? _selectedLogo;

  // Controllers
  final _dateController = TextEditingController();
  final _referenceController = TextEditingController();
  final _buyerNameController = TextEditingController();
  final _buyerPhoneController = TextEditingController();
  final _buyerEmailController = TextEditingController();
  final _buyerCompanyController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _employeeCountController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _advanceController = TextEditingController();
  final _installmentController = TextEditingController();
  final _monthsController = TextEditingController();
  final _termsController = TextEditingController();
  final _signatureController = SignatureController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormat.format(DateTime.now());
    _referenceController.text =
        'BP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    _totalAmountController.text = '85';
  }

  @override
  void dispose() {
    [
      _dateController,
      _referenceController,
      _buyerNameController,
      _buyerPhoneController,
      _buyerEmailController,
      _buyerCompanyController,
      _businessNameController,
      _businessAddressController,
      _businessTypeController,
      _ownerNameController,
      _employeeCountController,
      _totalAmountController,
      _advanceController,
      _installmentController,
      _monthsController,
      _termsController,
    ].forEach((controller) => controller.dispose());
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _selectedLogo = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking logo: $e')),
        );
      }
    }
  }


  Future<void> _generateAndSharePDF() async {
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Convert signature to image
      final signatureImage = await _convertSignatureToImage();

      // Convert logo to PDF image if exists
      pw.MemoryImage? logoImage;
      if (_selectedLogo != null) {
        final logoBytes = await _selectedLogo!.readAsBytes();
        logoImage = pw.MemoryImage(logoBytes);
      }

      // Add pages to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header with Logo
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (logoImage != null)
                    pw.Container(
                      width: 80,
                      height: 80,
                      margin: pw.EdgeInsets.only(right: 20),
                      child: pw.Image(logoImage),
                    ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Business Proposal',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Reference: ${_referenceController.text}',
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Date: ${_dateController.text}',
                          style: const pw.TextStyle(
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Content Sections
              _buildPDFSection(
                'Buyer Information',
                [
                  'Name: ${_buyerNameController.text}',
                  'Phone: ${_buyerPhoneController.text}',
                  'Email: ${_buyerEmailController.text}',
                  if (_buyerCompanyController.text.isNotEmpty)
                    'Company: ${_buyerCompanyController.text}',
                ],
              ),

              _buildPDFSection(
                'Business Details',
                [
                  'Business: ${_businessNameController.text}',
                  'Address: ${_businessAddressController.text}',
                  'Type: ${_businessTypeController.text}',
                  'Current Owner: ${_ownerNameController.text}',
                  'Employees: ${_employeeCountController.text}',
                ],
              ),

              _buildPDFSection(
                'Financial Terms',
                [
                  'Total Amount: ₹${_totalAmountController.text} Lakhs',
                  'Advance Payment: ₹${_advanceController.text} Lakhs',
                  'Monthly Installment: ₹${_installmentController.text} Lakhs',
                  'Duration: ${_monthsController.text} Months',
                ],
              ),

              if (_termsController.text.isNotEmpty)
                _buildPDFSection(
                  'Additional Terms & Conditions',
                  [_termsController.text],
                ),

              // Signature
              pw.SizedBox(height: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Digital Signature',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  if (signatureImage != null)
                    pw.Container(
                      height: 100,
                      child: pw.Image(signatureImage),
                    ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Signed by: ${_buyerNameController.text}',
                    style: const pw.TextStyle(
                      color: PdfColors.grey700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Footer
              pw.SizedBox(height: 20),
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Generated on ${DateTime.now().toString().split('.')[0]}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
              ),
            ];
          },
        ),
      );

      // Save PDF to temporary file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/business_proposal_${_referenceController.text}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Share PDF
      final xFile = XFile(file.path);
      await Share.shareXFiles(
        [xFile],
        subject: 'Business Proposal ${_referenceController.text}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

// Helper method to convert signature to PDF image
  Future<pw.MemoryImage?> _convertSignatureToImage() async {
    if (_signatureController.isEmpty) return null;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(400, 100);

    final painter = _SignaturePainter(
      points: _signatureController.points,
      strokeWidth: _signatureController.penStrokeWidth,
      strokeColor: _signatureController.penColor,
      backgroundColor: Colors.white,
    );

    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final imgData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (imgData == null) return null;
    return pw.MemoryImage(imgData.buffer.asUint8List());
  }

// Helper method to build PDF sections
  pw.Widget _buildPDFSection(String title, List<String> items) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        ...items.map((item) => pw.Padding(
          padding: pw.EdgeInsets.only(bottom: 4),
          child: pw.Text(item),
        )).toList(),
        pw.SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        readOnly: readOnly,
        validator: validator ??
            (value) => value?.isEmpty ?? true ? 'This field is required' : null,
      ),
    );
  }

  Future<void> _showSignatureDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => SignatureDialog(
        controller: _signatureController,
        initialName: _buyerNameController.text,
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormSection(
            'Reference Information',
            [
              _buildTextField(
                controller: _dateController,
                label: 'Date',
                readOnly: true,
              ),
              _buildTextField(
                controller: _referenceController,
                label: 'Reference Number',
                readOnly: true,
              ),
            ],
          ),
          _buildFormSection(
            'Buyer Information',
            [
              _buildTextField(
                controller: _buyerNameController,
                label: 'Your Full Name',
              ),
              _buildTextField(
                controller: _buyerPhoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildTextField(
                controller: _buyerEmailController,
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  final emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegExp.hasMatch(value!))
                    return 'Enter a valid email';
                  return null;
                },
              ),
              _buildTextField(
                controller: _buyerCompanyController,
                label: 'Your Company Name (if applicable)',
                validator: null, // Optional field
              ),
            ],
          ),
          _buildFormSection(
            'Target Business Information',
            [
              _buildTextField(
                controller: _businessNameController,
                label: 'Business Name',
              ),
              _buildTextField(
                controller: _businessAddressController,
                label: 'Business Address',
                maxLines: 2,
              ),
              _buildTextField(
                controller: _businessTypeController,
                label: 'Business Type/Industry',
              ),
              _buildTextField(
                controller: _ownerNameController,
                label: 'Current Owner Name',
              ),
              _buildTextField(
                controller: _employeeCountController,
                label: 'Number of Employees',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          _buildFormSection(
            'Payment Details',
            [
              _buildTextField(
                controller: _totalAmountController,
                label: 'Total Amount (Lakhs)',
                prefix: '₹ ',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildTextField(
                controller: _advanceController,
                label: 'Advance Payment (Lakhs)',
                prefix: '₹ ',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value?.isEmpty ?? true)
                    return 'Advance payment is required';
                  final advance = int.tryParse(value!) ?? 0;
                  final total = int.tryParse(_totalAmountController.text) ?? 0;
                  if (advance > total)
                    return 'Advance cannot exceed total amount';
                  return null;
                },
              ),
              _buildTextField(
                controller: _installmentController,
                label: 'Monthly Installment (Lakhs)',
                prefix: '₹ ',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _buildTextField(
                controller: _monthsController,
                label: 'Number of Months',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          _buildFormSection(
            'Terms and Conditions',
            [
              _buildTextField(
                controller: _termsController,
                label: 'Additional Terms & Conditions',
                maxLines: 4,
              ),
            ],
          ),
          _buildFormSection(
            'Digital Signature',
            [
              GestureDetector(
                onTap: _showSignatureDialog,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: _signatureController.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.draw,
                                  size: 40, color: AppColors.textLight),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add signature',
                                style: TextStyle(color: AppColors.textLight),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Signature(
                            controller: _signatureController,
                            backgroundColor: Colors.white,
                          ),
                        ),
                ),
              ),
              if (!_signatureController.isEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _signatureController.clear(),
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Signature'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    !_signatureController.isEmpty) {
                  setState(() => _showPreview = true);
                } else if (_signatureController.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please add your signature')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Review & Submit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and Header Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo Section
                  GestureDetector(
                    onTap: _pickLogo,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _selectedLogo != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedLogo!,
                          fit: BoxFit.contain,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 32,
                            color: AppColors.textLight,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add Logo',
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Header Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Proposal',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Ref: ${_referenceController.text}',
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _dateController.text,
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 48),

              // Improved Preview Sections
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildPreviewInfoTile(
                      'Buyer Information',
                      Icons.person_outline,
                      [
                        _buildInfoRow('Name', _buyerNameController.text),
                        _buildInfoRow('Phone', _buyerPhoneController.text),
                        _buildInfoRow('Email', _buyerEmailController.text),
                        if (_buyerCompanyController.text.isNotEmpty)
                          _buildInfoRow('Company', _buyerCompanyController.text),
                      ],
                    ),
                    _buildPreviewInfoTile(
                      'Business Details',
                      Icons.business_outlined,
                      [
                        _buildInfoRow('Business', _businessNameController.text),
                        _buildInfoRow('Address', _businessAddressController.text),
                        _buildInfoRow('Type', _businessTypeController.text),
                        _buildInfoRow('Current Owner', _ownerNameController.text),
                        _buildInfoRow('Employees', _employeeCountController.text),
                      ],
                    ),
                    _buildPreviewInfoTile(
                      'Financial Terms',
                      Icons.account_balance_outlined,
                      [
                        _buildInfoRow('Total Amount', '₹${_totalAmountController.text} Lakhs'),
                        _buildInfoRow('Advance Payment', '₹${_advanceController.text} Lakhs'),
                        _buildInfoRow('Monthly Installment', '₹${_installmentController.text} Lakhs'),
                        _buildInfoRow('Duration', '${_monthsController.text} Months'),
                      ],
                    ),
                  ],
                ),
              ),

              if (_termsController.text.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _termsController.text,
                        style: const TextStyle(
                          color: AppColors.textLight,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              // Signature Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Digital Signature',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Signature(
                        controller: _signatureController,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Signed by: ${_buyerNameController.text}',
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _showPreview = false),
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _generateAndSharePDF,
                icon: const Icon(Icons.share),
                label: const Text('Share PDF'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _submitProposal,
                icon: const Icon(Icons.check),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

// Helper method for building info rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper method for building preview sections
  Widget _buildPreviewInfoTile(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Future<void> _submitProposal() async {
    try {
      // TODO: Implement your API call here
      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposal submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Optional: Navigate back or to a success screen
        // Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting proposal: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _showPreview ? 'Review Proposal' : 'Business Proposal',
            style: const TextStyle(color: AppColors.textDark),
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: _showPreview
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  onPressed: () => setState(() => _showPreview = false),
                )
              : null,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _showPreview ? _buildPreviewContent() : _buildFormContent(),
          ),
        ),
      ),
    );
  }
}

// Helper Classes

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final formattedValue = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(int.parse(numericOnly));

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final numericOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericOnly.length > 10) {
      return oldValue;
    }

    String formatted = '';
    for (int i = 0; i < numericOnly.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '-';
      }
      formatted += numericOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Signature Controller Class
class SignatureController extends ChangeNotifier {
  final List<List<Offset>> _points = [];
  final double penStrokeWidth;
  final Color penColor;

  SignatureController({
    this.penStrokeWidth = 3.0,
    this.penColor = Colors.black,
  });

  List<List<Offset>> get points => _points;

  void addPoint(Offset point) {
    if (_points.isEmpty || _points.last.isEmpty) {
      _points.add([point]);
    } else {
      _points.last.add(point);
    }
    notifyListeners();
  }

  void endLine() {
    _points.add([]);
    notifyListeners();
  }

  void clear() {
    _points.clear();
    notifyListeners();
  }

  bool get isEmpty =>
      _points.isEmpty || (_points.length == 1 && _points.first.isEmpty);
}

// Signature Widget
class Signature extends StatefulWidget {
  final SignatureController controller;
  final Color backgroundColor;

  const Signature({
    Key? key,
    required this.controller,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  late Offset _localPosition;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.backgroundColor,
        child: GestureDetector(
          onPanStart: (details) {
            final box = context.findRenderObject() as RenderBox;
            _localPosition = box.globalToLocal(details.globalPosition);
            widget.controller.addPoint(_localPosition);
          },
          onPanUpdate: (details) {
            final box = context.findRenderObject() as RenderBox;
            _localPosition = box.globalToLocal(details.globalPosition);
            // Check if the point is within bounds
            if (_localPosition.dx >= 0 &&
                _localPosition.dx <= box.size.width &&
                _localPosition.dy >= 0 &&
                _localPosition.dy <= box.size.height) {
              widget.controller.addPoint(_localPosition);
            }
          },
          onPanEnd: (details) {
            widget.controller.endLine();
          },
          child: CustomPaint(
            painter: _SignaturePainter(
              points: widget.controller.points,
              strokeWidth: widget.controller.penStrokeWidth,
              strokeColor: widget.controller.penColor,
              backgroundColor: widget.backgroundColor,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

// Updated Signature Painter
class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> points;
  final double strokeWidth;
  final Color strokeColor;
  final Color backgroundColor;

  _SignaturePainter({
    required this.points,
    required this.strokeWidth,
    required this.strokeColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final line in points) {
      if (line.length < 2) continue;

      final path = Path();
      path.moveTo(line.first.dx, line.first.dy);

      for (int i = 1; i < line.length; i++) {
        final point = line[i];
        // Ensure points stay within bounds
        if (point.dx >= 0 &&
            point.dx <= size.width &&
            point.dy >= 0 &&
            point.dy <= size.height) {
          path.lineTo(point.dx, point.dy);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}

class SignatureDialog extends StatefulWidget {
  final SignatureController controller;
  final String initialName;

  const SignatureDialog({
    Key? key,
    required this.controller,
    required this.initialName,
  }) : super(key: key);

  @override
  State<SignatureDialog> createState() => _SignatureDialogState();
}

class _SignatureDialogState extends State<SignatureDialog> {
  late TextEditingController _nameController;
  bool _isDrawMode = true;
  final List<String> _fontFamilies = [
    'Dancing Script',
    'Great Vibes',
    'Pacifico',
    'Alex Brush',
    'Satisfy',
  ];
  String _selectedFont = 'Dancing Script';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Your Signature',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Signature Type Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      title: 'Draw',
                      icon: Icons.gesture,
                      isSelected: _isDrawMode,
                      onTap: () => setState(() => _isDrawMode = true),
                    ),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                      title: 'Type',
                      icon: Icons.text_fields,
                      isSelected: !_isDrawMode,
                      onTap: () => setState(() => _isDrawMode = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Signature Area
            Expanded(
              child:
                  _isDrawMode ? _buildDrawSignature() : _buildTypeSignature(),
            ),

            // Action Buttons
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (_isDrawMode) {
                        widget.controller.clear();
                      } else {
                        _nameController.clear();
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textDark,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.textDark : AppColors.textLight,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.textDark : AppColors.textLight,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawSignature() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Signature(
                controller: widget.controller,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Draw your signature above',
            style: TextStyle(color: AppColors.textLight),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSignature() {
    return Column(
      children: [
        // Font Family Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFont,
              isExpanded: true,
              items: _fontFamilies.map((font) {
                return DropdownMenuItem(
                  value: font,
                  child: Text(
                    'Sign with $font',
                    style: TextStyle(fontFamily: font),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedFont = value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Name Input
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Type your name',
            border: OutlineInputBorder(),
          ),
          style: TextStyle(
            fontFamily: _selectedFont,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // Preview
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            _nameController.text,
            style: TextStyle(
              fontFamily: _selectedFont,
              fontSize: 36,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

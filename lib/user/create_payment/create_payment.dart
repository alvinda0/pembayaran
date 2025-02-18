// user/create_payment/create_payment.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _image = File(result.files.single.path!);
        });
      } else {
        _showSnackBar('Tidak ada gambar yang dipilih', Colors.orange);
      }
    } catch (e) {
      print('Error picking image: $e');
      _showSnackBar('Gagal memilih gambar: $e', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _formatCurrency(String value) {
    if (value.isEmpty) return;
    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanValue.isEmpty) return;

    int? amount = int.tryParse(cleanValue);
    if (amount != null) {
      String formatted = currencyFormat.format(amount);
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_image == null) {
      _showSnackBar('Silakan pilih bukti pembayaran', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Generate a unique file name using timestamp and random string
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String uniqueId = timestamp + '_' + DateTime.now().toString();

      // Upload image directly to root of storage with unique filename
      String fileName = 'bukti_pembayaran_$uniqueId.jpg';
      Reference storageRef = _storage.ref().child(fileName);

      // Set content type and metadata
      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploaded_by': _nameController.text,
          'timestamp': timestamp,
        },
      );

      // Upload file with metadata
      await storageRef.putFile(_image!, metadata);

      // Get download URL
      String imageUrl = await storageRef.getDownloadURL();

      // Prepare payment data
      String cleanAmount =
          _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
      int amount = int.parse(cleanAmount);

      // Save to Firestore
      await _firestore.collection('pembayaran').add({
        'nama': _nameController.text,
        'nominal': amount,
        'deskripsi': _descriptionController.text,
        'buktiPembayaran': imageUrl,
        'fileName': fileName, // Store filename reference
        'tanggal': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      _showSnackBar('Pembayaran berhasil dibuat', Colors.green);
      _resetForm();
    } catch (e) {
      print('Error submitting payment: $e');
      _showSnackBar('Terjadi kesalahan: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _amountController.clear();
      _descriptionController.clear();
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Pembayaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Preview
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload Bukti Pembayaran',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),

              // Image Picker Button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pilih Gambar'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Name Input
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan nama',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabled: !_isLoading,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount Input
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Nominal',
                  hintText: 'Masukkan nominal',
                  prefixIcon: const Icon(Icons.payments),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabled: !_isLoading,
                ),
                keyboardType: TextInputType.number,
                onChanged: _formatCurrency,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (cleanValue.isEmpty) {
                    return 'Masukkan nominal yang valid';
                  }
                  int? amount = int.tryParse(cleanValue);
                  if (amount == null || amount <= 0) {
                    return 'Nominal harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Masukkan deskripsi pembayaran',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabled: !_isLoading,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Buat Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

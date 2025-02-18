// user/list_payment/list_payment.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
  }

  // Currency formatter
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Mock payment data - replace with actual data from your database
  final List<Map<String, dynamic>> paymentHistory = [
    {
      'year': 2024,
      'payments': [
        {'date': '2024-01-15', 'amount': 200000},
        {'date': '2024-02-20', 'amount': 150000},
      ],
    },
    {
      'year': 2023,
      'payments': [
        {'date': '2023-03-10', 'amount': 300000},
        {'date': '2023-06-15', 'amount': 200000},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'List Pembayaran',
          style: TextStyle(
            color: Colors.blue.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Tagihan',
                    currencyFormatter.format(500000),
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Sisa Pembayaran',
                    currencyFormatter.format(_calculateRemainingPayment(2024)),
                    Colors.orange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Payment History Section
            Text(
              'Riwayat Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 16),

            // Payment History List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: paymentHistory.length,
              itemBuilder: (context, index) {
                final yearData = paymentHistory[index];
                final int year = yearData['year'];
                final List<dynamic> payments = yearData['payments'];
                final double totalPaid = payments.fold(
                  0.0,
                  (sum, payment) => sum + payment['amount'],
                );
                final double remaining = 500000 - totalPaid;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildYearSection(year, totalPaid, remaining),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: payments.length,
                      itemBuilder: (context, paymentIndex) {
                        final payment = payments[paymentIndex];
                        return _buildPaymentCard(payment);
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, MaterialColor color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.shade400,
            color.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.shade200,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSection(int year, double totalPaid, double remaining) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Periode $year',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Dibayar: ${currencyFormatter.format(totalPaid)}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Sisa: ${currencyFormatter.format(remaining)}',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('dd MMMM yyyy', 'id_ID')
                .format(DateTime.parse(payment['date'])),
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            currencyFormatter.format(payment['amount']),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateRemainingPayment(int year) {
    final yearData = paymentHistory.firstWhere(
      (data) => data['year'] == year,
      orElse: () => {'payments': []},
    );

    final List<dynamic> payments = yearData['payments'] ?? [];
    final double totalPaid = payments.fold(
      0.0,
      (sum, payment) => sum + payment['amount'],
    );

    return 500000 - totalPaid;
  }
}

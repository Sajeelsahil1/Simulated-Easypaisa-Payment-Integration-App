import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyPay Simulator',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const PaymentHome(),
    );
  }
}

class PaymentHome extends StatefulWidget {
  const PaymentHome({super.key});

  @override
  State<PaymentHome> createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _result = "";
  bool _loading = false;

  final String serverUrl = 'https://225f3d9762e7.ngrok-free.app';

  Future<void> _makePayment() async {
    final phone = _phoneController.text.trim();
    final amount = _amountController.text.trim();

    if (phone.isEmpty || amount.isEmpty) {
      setState(() => _result = "Please enter phone and amount.");
      return;
    }

    setState(() {
      _loading = true;
      _result = "";
    });

    try {
      final url = Uri.parse('$serverUrl/create-payment');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'amount': amount}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showSuccessDialog(data['transactionId'], data['message']);
        _phoneController.clear();
        _amountController.clear();
      } else {
        setState(() => _result = "❌ Payment failed (Server error)");
      }
    } catch (e) {
      setState(() => _result = "❌ Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSuccessDialog(String txnId, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ Payment Successful'),
        content: Text('$msg\n\nTransaction ID: $txnId'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openHistoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionHistoryScreen(serverUrl: serverUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyPay Simulator'),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _openHistoryScreen,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Send Payment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(Icons.phone, color: Colors.green),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: "Amount (PKR)",
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    _loading
                        ? const CircularProgressIndicator(color: Colors.green)
                        : ElevatedButton.icon(
                            onPressed: _makePayment,
                            icon: const Icon(Icons.payment),
                            label: const Text("Pay Now"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 30,
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      _result,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ TRANSACTION HISTORY SCREEN -------------------

class TransactionHistoryScreen extends StatefulWidget {
  final String serverUrl;

  const TransactionHistoryScreen({super.key, required this.serverUrl});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<dynamic> _transactions = [];
  List<dynamic> _filtered = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchTransactions() async {
    try {
      final url = Uri.parse('${widget.serverUrl}/transactions');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _transactions = data;
          _filtered = data;
        });
      }
    } catch (e) {
      debugPrint("Error fetching transactions: $e");
    }
  }

  void _filterSearch(String query) {
    final filtered = _transactions.where((t) {
      final phone = t['phone'].toLowerCase();
      final txn = t['transaction_id'].toLowerCase();
      return phone.contains(query.toLowerCase()) ||
          txn.contains(query.toLowerCase());
    }).toList();

    setState(() => _filtered = filtered);
  }

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search by Phone or Transaction ID",
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterSearch,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text("No transactions found"))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final txn = _filtered[index];
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            title: Text(
                              "₨ ${txn['amount']}  —  ${txn['phone']}",
                            ),
                            subtitle: Text(
                              "Txn: ${txn['transaction_id']}\n${txn['timestamp']}",
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

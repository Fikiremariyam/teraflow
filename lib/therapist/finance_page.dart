/*import 'package:flutter/material.dart';
import 'package:teraflow/services/api_service.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final _businessNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  String? selectedBankCode;
  List<Map<String, dynamic>> banks = [];
  bool isLoadingBanks = true;

  @override
  void initState() {
    super.initState();
    fetchBanks();
  }

  Future<void> fetchBanks() async {
    print("Fetching banks...");
    try {
      final bankList = await ApiService.fetchBanks();
      print("API Response: $bankList");

      setState(() {
        banks = List<Map<String, dynamic>>.from(bankList);
        selectedBankCode = banks.isNotEmpty ? banks.first['code']?.toString() : null;
        isLoadingBanks = false;
      });

      if (banks.isEmpty) {
        print("❌ No banks found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No banks found. Try again later.")),
        );
      }
    } catch (e) {
      print("Error fetching banks: $e");
      setState(() {
        isLoadingBanks = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch banks. Please check your internet connection.")),
      );
    }
  }

  Future<void> createSubaccount() async {
    final businessName = _businessNameController.text.trim();
    final accountName = _accountNameController.text.trim();
    final accountNumber = _accountNumberController.text.trim();

    print("Creating subaccount with:");
    print("Business Name: $businessName");
    print("Account Name: $accountName");
    print("Selected Bank Code: $selectedBankCode");
    print("Account Number: $accountNumber");

    if (businessName.isEmpty || accountName.isEmpty || selectedBankCode == null || accountNumber.isEmpty) {
      print("❌ Validation failed: Missing fields.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    try {
      final subaccountId = await ApiService.createSubaccount(
        businessName: businessName,
        accountName: accountName,
        bankCode: int.parse(selectedBankCode!),
        accountNumber: accountNumber,
      );

      if (subaccountId != null) {
        print("✅ Subaccount created successfully. ID: $subaccountId");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Subaccount created successfully! ID: $subaccountId")),
        );
      } else {
        print("❌ Failed to create subaccount.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create subaccount.")),
        );
      }
    } catch (e) {
      print("Error creating subaccount: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Finance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _businessNameController,
              decoration: InputDecoration(labelText: "Business Name"),
            ),
            TextField(
              controller: _accountNameController,
              decoration: InputDecoration(labelText: "Account Name"),
            ),
            isLoadingBanks
                ? CircularProgressIndicator()
                : DropdownButtonFormField<String>(
                    value: selectedBankCode,
                    decoration: InputDecoration(labelText: "Select Bank"),
                    items: banks.isNotEmpty
                        ? banks.map((bank) {
                            final bankCode = bank['code']?.toString();
                            final bankName = bank['name'] ?? "Unknown Bank";
                            print("Adding bank to dropdown: $bankName (Code: $bankCode)");
                            return DropdownMenuItem<String>(
                              value: bankCode,
                              child: Text(bankName),
                            );
                          }).toList()
                        : [],
                    onChanged: (value) {
                      print("Bank selected: $value");
                      setState(() {
                        selectedBankCode = value;
                      });
                    },
                    hint: Text("Choose a bank"),
                    validator: (value) => value == null ? "Please select a bank" : null,
                  ),
            TextField(
              controller: _accountNumberController,
              decoration: InputDecoration(labelText: "Account Number"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createSubaccount,
              child: Text("Create Subaccount"),
            ),
          ],
        ),
      ),
    );
  }
}*/

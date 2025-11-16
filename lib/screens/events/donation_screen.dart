import 'package:flutter/material.dart';

class DonationScreen extends StatefulWidget {
  final Map<String, String> event;

  const DonationScreen({super.key, required this.event});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _utrController =
      TextEditingController(); // ⭐ NEW FIELD

  String donationType = "Normal"; // Normal | VIP | Anonymous

  bool get isAnonymous => donationType == "Anonymous";
  bool get isVIP => donationType == "VIP";

  void _submitDonation() {
    if (_formKey.currentState?.validate() ?? false) {
      final donationData = {
        "type": donationType,
        "amount": _amountController.text.trim(),
        "utr": _utrController.text.trim(),
        "name": isAnonymous ? "Anonymous" : _nameController.text.trim(),
        "comment": isAnonymous ? "" : _commentController.text.trim(),
        "event": widget.event["title"],
      };

      Navigator.pop(context, donationData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Donation Successful ✨"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text("Make a Donation"),
        backgroundColor: const Color(0xFFFFC966),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              Text(
                widget.event["title"]!,
                style: const TextStyle(
                  color: Color(0xFF4A2511),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),

              // Donation Amount
              const Text(
                "Donation Amount",
                style: TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Enter amount (₹)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter amount";
                  }
                  final amount = int.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return "Invalid amount";
                  }
                  if (isVIP && amount < 15000) {
                    return "VIP donation must be at least ₹15,000";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              // Donation Type
              const Text(
                "Donation Type",
                style: TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),

              _buildDonationTypeOption("Normal"),
              _buildDonationTypeOption("VIP"),
              _buildDonationTypeOption("Anonymous"),

              const SizedBox(height: 25),

              // Name + Comment (Not for Anonymous)
              if (!isAnonymous) ...[
                const Text(
                  "Your Name",
                  style: TextStyle(
                    color: Color(0xFF5D4037),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Enter your name"),
                  validator: (value) {
                    if (!isAnonymous && (value == null || value.isEmpty)) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                const Text(
                  "Comment",
                  style: TextStyle(
                    color: Color(0xFF5D4037),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: _inputDecoration("Write your message"),
                ),
                const SizedBox(height: 25),
              ],

              // ⭐ UTR Number (Always Required)
              const Text(
                "Verification",
                style: TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                "UTR / Transaction Number",
                style: TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _utrController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Enter UTR number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "UTR number is required";
                  }
                  if (value.length < 6) {
                    return "Enter a valid UTR (min 6 digits)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8763E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    "Donate Now",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildDonationTypeOption(String type) {
    final selected = donationType == type;

    return GestureDetector(
      onTap: () => setState(() => donationType = type),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFC966) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFE8763E) : const Color(0xFFFFE8CC),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? const Color(0xFFE8763E) : Colors.grey,
            ),
            const SizedBox(width: 14),
            Text(
              type,
              style: TextStyle(
                fontSize: 16,
                color: selected ? const Color(0xFF4A2511) : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFFE8CC), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8763E), width: 2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gitraj/screens/events/donation_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/services/auth_service.dart';
import 'add_edit_event_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, String> event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final bool isAdmin = authService.currentUser?.isAdmin ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8E1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5D4037)),
        title: const Text(
          "Event Details",
          style: TextStyle(
            color: Color(0xFF5D4037),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EVENT TITLE
            Text(
              event["title"]!,
              style: const TextStyle(
                color: Color(0xFF4A2511),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // DATE CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFC966), Color(0xFFFFB347)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB347).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      color: Color(0xFF4A2511),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    event["date"]!,
                    style: const TextStyle(
                      color: Color(0xFF4A2511),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // TOTAL FUNDS BOX
            Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFC966), Color(0xFFFFB347)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C42).withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Color(0xFF4A2511),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Funds",
                        style: TextStyle(
                          color: Color(0xFF4A2511),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "₹${event["funds"]}",
                        style: const TextStyle(
                          color: Color(0xFF4A2511),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // MINIMUM DONATION RULES CARD
            Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C42).withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Donation Rules",
                    style: TextStyle(
                      color: Color(0xFF4A2511),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFE8763E)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Minimum Normal Donation: ₹100",
                          style: TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.workspace_premium, color: Color(0xFFE8763E)),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Minimum VIP Donation: ₹15,000",
                          style: TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            // DONATE BUTTON (Only for non-admin)
            if (!isAdmin)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final donation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DonationScreen(event: event),
                      ),
                    );

                    if (donation != null) {
                      Navigator.pop(context, {"donation": donation});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8763E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    "Donate",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),
            // DESCRIPTION TITLE
            const Text(
              "Description",
              style: TextStyle(
                color: Color(0xFF5D4037),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // DESCRIPTION BOX
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C42).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                event["description"]!,
                style: const TextStyle(
                  color: Color(0xFF6D4C41),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // EDIT BUTTON (Admin only)
            if (isAdmin)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final updatedEvent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditEventScreen(eventData: event),
                      ),
                    );

                    if (updatedEvent != null) {
                      Navigator.pop(
                        context,
                        updatedEvent,
                      ); // Return updated data
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8763E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: const Color(0xFFE8763E).withOpacity(0.4),
                  ),
                  child: const Text(
                    "Edit Event",
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
    );
  }
}

import 'package:flutter/material.dart';
import 'member_profile_screen.dart';
import '../../models/user_model.dart';

class MembersDirectoryScreen extends StatefulWidget {
  const MembersDirectoryScreen({Key? key}) : super(key: key);

  @override
  _MembersDirectoryScreenState createState() => _MembersDirectoryScreenState();
}

class _MembersDirectoryScreenState extends State<MembersDirectoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _listController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _allMembers = [
    {'name': 'Priya Sharma', 'role': 'Community Manager'},
    {'name': 'Rahul Verma', 'role': 'Event Coordinator'},
    {'name': 'Sneha Patel', 'role': 'Volunteer Lead'},
    {'name': 'Arjun Mehta', 'role': 'Technical Support'},
  ];

  List<Map<String, String>> _filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMembers = List.from(_allMembers);

    _searchController.addListener(_filterMembers);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _fadeController.forward();
    _listController.forward();
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers
          .where((member) =>
          (member['name'] ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _listController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Members Directory',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: _filteredMembers.isEmpty
          ? const Center(
        child: Text(
          'No members found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon:
                    const Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search members...',
                    hintStyle:
                    TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredMembers.length,
                itemBuilder: (context, index) {
                  final member = _filteredMembers[index];

                  return AnimatedBuilder(
                    animation: _listController,
                    builder: (context, child) {
                      final animationValue = Curves.easeOut
                          .transform(_listController.value);
                      return Opacity(
                        opacity: animationValue,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - animationValue)),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MemberProfileScreen(
                              user: User(
                                uid: index.toString(),
                                fullName: member['name'] ?? 'Unknown',
                                email: 'example@example.com',
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person, size: 30),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF2D3142),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    member['role'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: Colors.grey),
                          ],
                        ),
                      ),
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

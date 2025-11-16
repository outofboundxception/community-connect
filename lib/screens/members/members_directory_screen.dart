import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'member_profile_screen.dart'; // <-- 1. IMPORT THE NEW SCREEN

class MembersDirectoryScreen extends StatefulWidget {
  const MembersDirectoryScreen({super.key});

  @override
  State<MembersDirectoryScreen> createState() => _MembersDirectoryScreenState();
}

class _MembersDirectoryScreenState extends State<MembersDirectoryScreen> {
  // Mock data - replace with data from your backend
  final List<User> _allMembers = [
    User(uid: "101", fullName: "Ram Kumar", email: "ram@test.com"),
    User(
      uid: "102",
      fullName: "Vijay Singh",
      email: "vijay@test.com",
      interests: ["State Management", "Firebase"],
    ),
    User(
      uid: "103",
      fullName: "Rahul Sighn",
      email: "rahul@test.com",
      interests: ["UI/UX"],
    ),
    User(
      uid: "104",
      fullName: "Shiva",
      email: "shiva@test.com",
      bio: "Passionate Flutter dev.",
    ),
  ];

  List<User> _filteredMembers = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMembers = _allMembers;
    _searchController.addListener(_filterMembers);
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member.fullName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Member Directory")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search members...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMembers.length,
              itemBuilder: (ctx, index) {
                final member = _filteredMembers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(member.fullName),
                    subtitle: Text(
                      member.interests.isNotEmpty
                          ? member.interests.join(', ')
                          : "No interests listed",
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ), // A nice visual cue
                    onTap: () {
                      // <-- 2. UPDATE THE ONTAP HANDLER
                      // This is where the navigation happens.
                      // We create a new page route and pass the selected 'member'
                      // object to the MemberProfileScreen's constructor.
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MemberProfileScreen(user: member),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

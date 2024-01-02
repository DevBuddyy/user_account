import 'package:flutter/material.dart';
import 'package:user_account/auth/auth_service.dart';
import 'package:user_account/auth/database_service.dart';
import 'package:user_account/screens/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late User _currentUser; // To store the current user's data

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    // Retrieve the current user's data
    String userId = await _authService.getCurrentUserId();
    User? user = await _databaseService.getUser(userId);

    if (user != null) {
      setState(() {
        _currentUser = user;
        _firstNameController.text = user.firstName;
        _middleNameController.text = user.middleName;
        _lastNameController.text = user.lastName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              // Implement sign out
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _middleNameController,
              decoration: const InputDecoration(labelText: 'Middle Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                User updatedUser = User(
                  id: _currentUser.id,
                  firstName: _firstNameController.text,
                  middleName: _middleNameController.text,
                  lastName: _lastNameController.text,
                );

                // Save updated user data to Firebase
                await _databaseService.saveUser(updatedUser);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Updated')),
                );
              },
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

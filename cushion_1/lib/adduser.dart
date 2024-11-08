import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/hexcolor.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:cushion_1/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserAddPage extends StatefulWidget {
  const UserAddPage({super.key});

  @override
  UserAddPageState createState() => UserAddPageState();
}

class UserAddPageState extends State<UserAddPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _freqController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final Localstoragefunctions localStorageFunctions = Localstoragefunctions();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Row(
        children: [
          // Left side for the image
          Container(
            width: screenSize.width * 0.5,
            color: AppColors.bgLight,
            child: Image.asset(
              'assets/adduser3.png', // Add your image asset here
              fit: BoxFit.cover,
            ),
          ),

          // Right side for the form
          SingleChildScrollView(
            child: Container(
              width: screenSize.width * 0.5,
              color: AppColors.bgLight,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Add User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _freqController,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: _saveUserToLocalStorage,
                  //   child: const Text('Save User'),
                  // ),
                           Center(
  child: GestureDetector(
    onTap: () {
      _saveUserToLocalStorage(); // Trigger the PDF generation when the button is tapped
    },
    child: Container(
      width: 250,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HexColor('#87d9f7'),
            HexColor('#87d9f7')
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          // Add shadow if needed
        ],
      ),
      child: const Center(
        child: Text(
          'Add User',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ),
  ),
),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveUserToLocalStorage() {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String frequency = _freqController.text.trim();
    String duration = _durationController.text.trim();

    if (username.isNotEmpty && email.isNotEmpty && frequency.isNotEmpty && duration.isNotEmpty) {
      // Save the username and email using Localstoragefunctions
      localStorageFunctions.setUserEmailAndName(email, username);

      // Save the frequency and duration for this user
      localStorageFunctions.saveReminderInterval(int.parse(frequency));
      localStorageFunctions.saveDuration(int.parse(duration));

      // Clear the input fields
      _usernameController.clear();
      _emailController.clear();
      _freqController.clear();
      _durationController.clear();
         final userController = Get.find<UserController>();
      userController.refreshUserList();

      // Refresh the user list
      setState(() {});

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User $username added successfully!')),
      );
      
    } else {
      // Show an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all required fields')),
      );
    }
  }
}

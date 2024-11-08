import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/hexcolor.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:cushion_1/pdfviewer.dart';
import 'package:cushion_1/statslocalstorage.dart';
import 'package:cushion_1/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  UserListPageState createState() => UserListPageState();
}

class UserListPageState extends State<UserListPage> {
  final Localstoragefunctions localStorageFunctions = Localstoragefunctions();
   final UserController userController = Get.find<UserController>();
  final PDFViewerScreenState pdfviewer=PDFViewerScreenState();
  String? _selectedUsername;
  @override
  void initState() {
    super.initState();
    userController.loadUserList();  // Load the initial list of users when the page is opened
  }


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
              'assets/changeuser.png', // Add your image asset here
              fit: BoxFit.cover,
            ),
          ),

          // Right side for the list of users and the 'Change User' button
          Container(
            width: screenSize.width * 0.5,
            color: AppColors.bgLight,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Change User',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/change_user.png', // Add your image asset here
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    SizedBox(width: 80),
                    Text(
                      'USERS',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // List of users with checkboxes
                Expanded(
                  child: FutureBuilder(
                    future: Future.value(localStorageFunctions.getAllUsernames()), // Load usernames
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        List<String> usernames = snapshot.data as List<String>;
                        if (usernames.isEmpty) {
                          return const Center(child: Text('No users found'));
                        }
                        return ListView.builder(
                          itemCount: usernames.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                usernames[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              leading: Checkbox(
                                value: _selectedUsername == usernames[index],
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    setState(() {
                                      _selectedUsername = usernames[index]; // Only select one
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('Failed to load users'));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
              

                        Row(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _changeUser(); // Trigger the PDF generation when the button is tapped
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
                                      'Switch User',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                             Center(
                              child: GestureDetector(
                                onTap: () {
                                  _deleteUser(); // Trigger the PDF generation when the button is tapped
                                },
                                child: Container(
                                  width: 250,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        HexColor('#ef5a4e'),
                                        HexColor('#ef5a4e')
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
                                      'Delete User',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 void _deleteUser() {
    if (_selectedUsername != null) {
      localStorageFunctions.deleteUser(_selectedUsername!); // Delete user from storage

      // Refresh the user list and reset the selected username
      setState(() {
        _selectedUsername = null; // Reset selected user
      });

      // Display a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User $_selectedUsername deleted')),
      );
    }
  }

void _changeUser() {
  if (_selectedUsername != null) {
    // Retrieve the selected user's email from local storage
    final email = localStorageFunctions.getUserEmailFromUsername(_selectedUsername!);

    if (email != null) {
      // Update the UserController with the new user details
      final userController = Get.find<UserController>();
      userController.setUserEmailAndName(email, _selectedUsername!);

      // Save the updated user details in local storage
      localStorageFunctions.saveUserDetails(email, _selectedUsername!);
      localStorageFunctions.saveCurrentUser(email, _selectedUsername!); // Save as the current user

      // Reinitialize Statslocalstorage for the new user
      final statsController = Get.find<Statslocalstorage>();
      statsController.setUserEmail(email); // Update user email in Statslocalstorage
      statsController.initializeUserData(); // Reload data for the new user

    //  print(statsController.userEmail);
     // print('Updated UserController - Email: ${userController.getUserEmail}, Name: ${userController.getUserName}');
      //print('LocalStorage - UserDetails: ${localStorageFunctions.getUserDetails()}');

      // // Navigate to PDFViewerScreen and pass the updated user data
      // Get.to(() => PDFViewerScreen(), arguments: {
      //   'userName': _selectedUsername!,
      //   'userEmail': email,
      // });

      // Display a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User changed to $_selectedUsername')),
      );
    } else {
      // Display an error message if the email is not found for the selected user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to find email for the selected user')),
      );
    }
  }
}

}

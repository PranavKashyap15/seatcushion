import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:cushion_1/materialprogress.dart';
import 'package:cushion_1/statslocalstorage.dart';
import 'package:cushion_1/usercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
   final TextEditingController _freqController = TextEditingController();
    final TextEditingController _DurationController = TextEditingController();
  final Localstoragefunctions localStorageFunctions = Localstoragefunctions();
   final MaterialProgressWidgetState ProgressWidget=MaterialProgressWidgetState();
  String? _selectedUsername;  // Store the selected username

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Row(
        children: [
          // Left half of the screen for the form
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
                    controller:_freqController,
                    decoration:const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    )
                  ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _DurationController,
                        decoration: const InputDecoration
                        (
                          labelText: 'Duration',
                          border:  OutlineInputBorder(),
                        ),
                      ),
                  ElevatedButton(
                    onPressed: _saveUserToLocalStorage,
                    child: const Text('Save User'),
                  ),
                ],
              ),
            ),
          ),
 const SizedBox(width: 40),
          // Right half of the screen for user list and selection
          Container(
            width: screenSize.width * 0.5 - 40,
            color: AppColors.bgLight,
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
                      'assets/changeuser.png', // Add your image here
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
                          'USERS LIST',
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
                      //    print(localStorageFunctions.getAllUsernames());
                          return const Center(child: Text('No users found'));
                        }
                        return ListView.builder(
                          itemCount: usernames.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(usernames[index],
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

                // Button to change the selected user
                ElevatedButton(
                  onPressed: _selectedUsername != null
                      ? _changeUser // Only enable if a user is selected
                      : null,
                  child: const Text('Change User'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void _saveUserToLocalStorage() {
  //   String username = _usernameController.text.trim();
  //   String email = _emailController.text.trim();

  //   if (username.isNotEmpty && email.isNotEmpty) {
  //     // Save the username and email using Localstoragefunctions
  //     localStorageFunctions.setUserEmailAndName(email, username);

  //     // Clear the input fields
  //     _usernameController.clear();
  //     _emailController.clear();

  //     // Refresh the user list
  //     setState(() {});

  //     // Show a confirmation message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('User $username added successfully!')),
  //     );
  //   } else {
  //     // Show an error message if fields are empty
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please enter both username and email')),
  //     );
  //   }
  // }
  void _saveUserToLocalStorage() {
  String username = _usernameController.text.trim();
  String email = _emailController.text.trim();
  String frequency = _freqController.text.trim();
  String duration = _DurationController.text.trim();

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
    _DurationController.clear();

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
      // Debugging: Check if values are being saved correctly
   //   print('Updated UserController - Email: ${userController.getUserEmail}, Name: ${userController.getUserName}');
    //  print('LocalStorage - UserDetails: ${localStorageFunctions.getUserDetails()}');
       MaterialProgressWidgetState.to.startReminderTimer();
           //MaterialProgressWidgetState.to.initializeMaterialProgress();

      // Update the UI to reflect the changed user
      setState(() {});

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


//  void _changeUser() {
//   if (_selectedUsername != null) {
//     // Use Localstoragefunctions to get the selected user's email
//     final email = localStorageFunctions.getUserEmailFromUsername(_selectedUsername!);
//     if (email != null) {
//       // Update both the UserController and Localstoragefunctions
//       localStorageFunctions.setUserEmailAndName(email, _selectedUsername!);
      
//       // This updates the UserController to reflect the newly selected user
//       final userController = Get.find<UserController>();
//       userController.setUserEmailAndName(email, _selectedUsername!);
//       print(userController.getUserEmail);
//        print(userController.getUserName);
//       // Update the state to reflect the changed user in the UI
//       setState(() {});

//       // Show a confirmation message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('User changed to $_selectedUsername')),
//       );
//       print(localStorageFunctions.getUserDetails());
//    //   print('USERMAIL ID $userController.getUserEmail');
       
//     } else {
//       // Show error message if the email is not found
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to find email for selected user')),
//       );
//     }
//   }
// }


}

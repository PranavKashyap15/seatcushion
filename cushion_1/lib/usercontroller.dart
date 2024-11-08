import 'package:cushion_1/localstoragefunctions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  var userEmail = ''.obs; // Observable for user email
  var userName = ''.obs;  // Observable for user name
  var userList = <String>[].obs;
 final GetStorage storage = GetStorage();

 void refreshUserList() {
    userList.value = Localstoragefunctions().getAllUsernames(); // Update user list from storage
  }

  // Call this function to fetch the latest user list when the app starts
  void loadUserList() {
    userList.value = Localstoragefunctions().getAllUsernames();
  }
  // Set email and name
  void setUserEmailAndName(String email, String name) {
    userEmail.value = email;
    userName.value = name;
  }

  // Set email
  void setUserEmail(String email) {
    userEmail.value = email;
     
  }

  // Set name
  void setUserName(String name) {
    userName.value = name;
      
  }
   // Getter for userEmail
  String get getUserEmail {
    return userEmail.value;
  }

  // Getter for userName
  String get getUserName {
    return userName.value;
  }
}

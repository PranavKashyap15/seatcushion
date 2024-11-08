// view_state_controller.dart
import 'package:get/get.dart';

class ViewStateController extends GetxController {
  var currentViewIndex = 0.obs; // Observable view index

  void updateView(int index) {
    currentViewIndex.value = index;
  }
}

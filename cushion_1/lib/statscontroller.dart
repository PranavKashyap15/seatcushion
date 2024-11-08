import 'package:cushion_1/localstoragefunctions.dart';
import 'package:get/get.dart';

class StatsController extends GetxController {
  var positionTimesInHours = <String, double>{}.obs;
  final Localstoragefunctions local = Localstoragefunctions();
  @override
  void onInit() {
    super.onInit();
    loadTimes();
  }
  void loadTimes() {
    positionTimesInHours['back'] = local.getTime('back').toDouble() / 3600;
    positionTimesInHours['forward'] = local.getTime('forward').toDouble() / 3600;
    positionTimesInHours['left'] = local.getTime('left').toDouble() / 3600;
    positionTimesInHours['right'] = local.getTime('right').toDouble() / 3600;
     positionTimesInHours['rightreposition'] = local.getTime('rightreposition').toDouble() / 3600;
    positionTimesInHours['leftreposition'] = local.getTime('leftreposition').toDouble() / 3600;
    positionTimesInHours['forwardreposition'] = local.getTime('forwardreposition').toDouble() / 3600;
      positionTimesInHours['backreposition'] = local.getTime('backreposition').toDouble() / 3600;
  }
  void updateTime(String position) {
    positionTimesInHours[position] = local.getTime(position).toDouble() / 3600;
  }
}

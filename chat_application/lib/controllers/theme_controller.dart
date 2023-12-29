import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ThemeController extends GetxController {
  RxBool isDark = false.obs;

  changeTheme() {
    isDark(!isDark.value);
  }
}

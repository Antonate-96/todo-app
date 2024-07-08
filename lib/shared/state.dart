import 'package:get/get.dart';
import 'package:todos/services/auth.dart';

import '../models/users.dart';

class UserController extends GetxController {
  Rxn<MyUser> user = Rxn<MyUser>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(Authservice().user);
  }
}

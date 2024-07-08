import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/view/home/home.dart';

import '../../shared/state.dart';
import 'authen/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<MyUser?>(context);
    final UserController c = Get.put(UserController());
    // return either the Home or Authenticate widget
    return Obx(
      () {
        log("State: ${c.user}");
        if (c.user.value == null) {
          return Authenticate();
        } else {
          return Home();
        }
      },
    );
  }
}

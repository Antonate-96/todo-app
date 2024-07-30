import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as Getx;
import 'package:todos/shared/constant.dart';
import 'package:todos/shared/state.dart';

class Chatgpt {
  Future gettodoslist({String? threadId, String? message}) async {
    Response response;

    final Dio dioClient = Dio();
    final UserController c = Getx.Get.put(UserController());

    try {
      response = await dioClient.post(buildship_url, data: {
        "message": message,
        "threadId": threadId,
        "userid": c.user.value!.uid.toString()
      });
      if (response.statusCode == 200) {
        log('${response.realUri}');
        log('${response.data["message"]}');
        return response.data;
      }
    } on DioException catch (e) {
      log('${e.response!.realUri}');
      log('${e.response!.data}');
      return "${e.response!.data}";
    }
  }
}

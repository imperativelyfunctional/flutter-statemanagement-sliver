import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliver/main/login_client.dart';

class Triple {
  final IconData data;
  final Color inner;
  final Color outer;

  Triple(this.data, this.inner, this.outer);
}

class MainController extends GetxController {
  final restClient = LoginClient(Dio(), baseUrl: "http://localhost:9000/");

  var icon = 0.obs;
  var validForm = false;
  var showSpinner = false;

  void switchIcon() {
    icon = ((++icon.value) % 4).obs;
  }

  Future<bool> login(LoginRequestBody login) async {
    var result = false;
    try {
      showSpinner = true;
      await restClient.login(login);
      result = true;
    } on DioError catch (e) {
      var statusCode = e.response?.statusCode;
      if (e.error != null && e.error is SocketException) {
        Get.snackbar("Warning", "Can not connect to server.",
            colorText: Colors.amber,
            backgroundColor: Colors.blueAccent.withAlpha(100),
            snackPosition: SnackPosition.BOTTOM);
      } else if (statusCode == 401 ||
          statusCode == 404) {
        //currently mock server only has expectations that handles 401 and 404
        Get.snackbar("Warning", "Email and password combination is incorrect.",
            colorText: Colors.amber,
            backgroundColor: Colors.green.withAlpha(100),
            snackPosition: SnackPosition.BOTTOM);
      }
      result = false;
    }
    showSpinner = false;
    update();
    return result;
  }

  void markFormValid(bool valid) {
    validForm = valid;
    update();
  }

  void updateSpinnerStatus(bool valid) {
    showSpinner = valid;
    update();
  }
}

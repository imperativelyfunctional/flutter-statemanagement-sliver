import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliver/gallery/gallery_client.dart';

class GalleryController extends GetxController {
  final restClient = GalleryClient(Dio(), baseUrl: "http://localhost:9000/");

  var images = <String>[].obs;

  var pageNumber = 0;

  var showShimmer = true.obs;
  var showProgressBar = false.obs;

  void addImages(images) {
    this.images.addAll(images);
  }

  fetchImages() async {
    try {
      pageNumber++;
      showProgressBar.value = true;
      final response = await restClient.getImages(pageNumber);
      images.addAll(response.data);
      showShimmer.value = false;
      showProgressBar.value = false;
    } on DioError catch (e) {
      if (e.error != null && e.error is SocketException) {
        Get.snackbar("Warning", "Can not connect to server.",
            colorText: Colors.amber,
            backgroundColor: Colors.blueAccent.withAlpha(100),
            snackPosition: SnackPosition.BOTTOM);
      } else if (e.response?.statusCode == 404) {
        Get.snackbar("Warning", "There is no more data.",
            colorText: Colors.amber,
            backgroundColor: Colors.green.withAlpha(100),
            snackPosition: SnackPosition.BOTTOM);
      }
      showShimmer.value = false;
      showProgressBar.value = false;
      pageNumber--;
    }
  }
}

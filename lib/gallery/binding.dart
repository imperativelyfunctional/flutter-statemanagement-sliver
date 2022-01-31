import 'package:get/get.dart';
import 'package:sliver/gallery/controller.dart';

class GalleryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryController>(() => GalleryController());
  }
}

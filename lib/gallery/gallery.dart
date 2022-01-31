import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver/gallery/controller.dart';

class GalleryWidget extends StatelessWidget {
  GalleryWidget({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  final controller = Get.find<GalleryController>();

  List<double> _calculateTileInformation(int index) {
    var remainder = index % 5;
    if (remainder == 0) {
      return [2, 2, 1];
    } else if (remainder == 1) {
      return [2, 1, 1 / 2];
    } else if (remainder == 2) {
      return [1, 1, 1 / 2];
    } else if (remainder == 3) {
      return [1, 1, 1 / 2];
    } else {
      return [4, 2, 1 / 2];
    }
  }

  @override
  StatelessElement createElement() {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        controller.fetchImages();
      }
    });
    controller.fetchImages();
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white24,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'テンパー',
                  style: TextStyle(color: Colors.white),
                ),
                background: Image.asset(
                  'images/bg2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(child: Obx(() {
              return controller.showShimmer.value
                  ? Shimmer.fromColors(
                      baseColor: Colors.blueGrey[300]!,
                      highlightColor: Colors.blueGrey[100]!,
                      enabled: true,
                      child: StaggeredGrid.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          children: [
                            ...List<String>.filled(10, "")
                                .mapIndexed((index, _) {
                              var tileInfo = _calculateTileInformation(index);
                              return StaggeredGridTile.count(
                                crossAxisCellCount: tileInfo[0].toInt(),
                                mainAxisCellCount: tileInfo[1].toInt(),
                                child: Card(
                                  child: AspectRatio(
                                      aspectRatio: tileInfo[2],
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(""),
                                      )),
                                ),
                              );
                            })
                          ]),
                    )
                  : StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: [
                          ...controller.images.mapIndexed((index, image) {
                            var tileInfo = _calculateTileInformation(index);
                            return StaggeredGridTile.count(
                              crossAxisCellCount: tileInfo[0].toInt(),
                              mainAxisCellCount: tileInfo[1].toInt(),
                              child: Card(
                                child: AspectRatio(
                                    aspectRatio: tileInfo[2],
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              image,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Image.asset(
                                                  'images/placeholder.png',
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            ),
                                            Positioned(
                                              right: -10,
                                              top: -20,
                                              width: 50,
                                              height: 50,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withAlpha(120),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          })
                        ]);
            }))
          ],
        ),
        Obx(() => Opacity(
              opacity: controller.showProgressBar.value ? 1 : 0,
              child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  )),
            )),
      ]),
    );
  }
}

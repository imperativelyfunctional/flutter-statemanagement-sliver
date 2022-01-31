import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'gallery_client.g.dart';

@RestApi()
abstract class GalleryClient {
  factory GalleryClient(Dio dio, {String baseUrl}) = _GalleryClient;

  @GET("/images")
  Future<HttpResponse<List<String>>> getImages(@Query("page") int page);
}

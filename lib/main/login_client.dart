import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'login_client.g.dart';

@RestApi()
abstract class LoginClient {
  factory LoginClient(Dio dio, {String baseUrl}) = _LoginClient;

  @POST("/login")
  Future<HttpResponse> login(@Body() LoginRequestBody login);
}

@JsonSerializable()
class LoginRequestBody {
  String? email;
  String? password;

  LoginRequestBody(this.email, this.password);

  factory LoginRequestBody.fromJson(Map<String, dynamic> json) => _$LoginRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);
}

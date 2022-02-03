

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tutapp/app/constants.dart';
import 'package:tutapp/data/responses/responses.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient{

  factory AppServiceClient(Dio dio, {String baseUrl}) =  _AppServiceClient;

    @POST(Constant.loginUrl)
  Future<AuthenticationResponse> login(
        @Field("email") String email,
        @Field("password") String password,
        @Field("imei") String imei,
        @Field("deviceType") String deviceType,


        );

}
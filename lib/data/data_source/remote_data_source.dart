 import 'package:tutapp/data/network/app_api.dart';
import 'package:tutapp/data/requests/request.dart';
import 'package:tutapp/data/responses/responses.dart';

abstract class RemoteDataSource{
 Future<AuthenticationResponse> login(LoginRequest loginRequest);

 }


 class RemoteDataSourceImplementer implements RemoteDataSource{
   AppServiceClient _appServiceClient;
   RemoteDataSourceImplementer(this._appServiceClient);

   @override
  Future<AuthenticationResponse> login (LoginRequest loginRequest) async{

     return await _appServiceClient.login(loginRequest.email, loginRequest.password, "621ee9a75b3e0396", "pass");
  }
}
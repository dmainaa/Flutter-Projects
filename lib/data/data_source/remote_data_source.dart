 import 'package:tutapp/data/network/app_api.dart';
import 'package:tutapp/data/requests/request.dart';
import 'package:tutapp/data/responses/responses.dart';

abstract class RemoteDataSource{
 Future<AuthenticationResponse> login(LoginRequest loginRequest);
 Future<AuthenticationResponse> register(RegisterRequest registerRequest);
 Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest forgotPasswordRequest);

 }


 class RemoteDataSourceImplementer implements RemoteDataSource{
   AppServiceClient _appServiceClient;
   RemoteDataSourceImplementer(this._appServiceClient);

   @override
  Future<AuthenticationResponse> login (LoginRequest loginRequest) async{

     return await _appServiceClient.login(loginRequest.email, loginRequest.password, "621ee9a75b3e0396", "pass");
  }

   @override
  Future<ForgotPasswordResponse> forgotPassword (
      ForgotPasswordRequest forgotPasswordRequest) async{
   return await _appServiceClient.forgotPassword(forgotPasswordRequest.email);
  }

   @override
  Future<AuthenticationResponse> register(RegisterRequest registerRequest) async{
     return await _appServiceClient.register(
       registerRequest.countryMobileCode,
       registerRequest.userName,
       registerRequest.email,
       registerRequest.password,

       registerRequest.profilePicture,

     );
  }
}
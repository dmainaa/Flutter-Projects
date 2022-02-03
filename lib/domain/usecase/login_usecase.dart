

import 'package:dartz/dartz.dart';
import 'package:tutapp/app/functions.dart';
import 'package:tutapp/data/network/failure.dart';
import 'package:tutapp/data/requests/request.dart';
import 'package:tutapp/domain/model/model.dart';
import 'package:tutapp/domain/repository/repository.dart';
import 'package:tutapp/domain/usecase/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication>{
  Repository _repository;


  LoginUseCase(this._repository);



  @override
  Future<Either<Failure, Authentication>> execute(LoginUseCaseInput input) async{
    DeviceInfo deviceInfo = await getDeviceDetails();
   return  await _repository.login(LoginRequest(input.email, input.password, deviceInfo.identifier, deviceInfo.name));

  }
}

class LoginUseCaseInput{
  String email;
  String password;

  LoginUseCaseInput(this.email, this.password);
}
import 'package:dartz/dartz.dart';
import 'package:tutapp/data/network/failure.dart';
import 'package:tutapp/data/requests/request.dart';
import 'package:tutapp/data/responses/responses.dart';
import 'package:tutapp/domain/model/model.dart';
import 'package:tutapp/domain/repository/repository.dart';
import 'package:tutapp/domain/usecase/base_usecase.dart';

class ForgotPasswordUseCase extends BaseUseCase<ForgotPasswordCaseInput, ForgotPasswordResponse>{
  Repository repository;


  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, ForgotPasswordResponse>> execute (
      ForgotPasswordCaseInput input) async{
    return await repository.forgotPassword(ForgotPasswordRequest(input.email));

  }
}




class ForgotPasswordCaseInput{
  String email;

  ForgotPasswordCaseInput(this.email);
}
import 'package:dartz/dartz.dart';
import 'package:tutapp/data/network/failure.dart';
import 'package:tutapp/data/requests/request.dart';
import 'package:tutapp/domain/model/model.dart';
import 'package:tutapp/domain/repository/repository.dart';
import 'package:tutapp/domain/usecase/base_usecase.dart';

class RegisterUseCase implements BaseUseCase<RegisterUseCaseInput, Authentication>{
  Repository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(RegisterUseCaseInput input) async{
    return await _repository.register(RegisterRequest(input.countryMobileCode, input.userName, input.email, input.password, input.profilePicture));

  }
}

class RegisterUseCaseInput{
  String countryMobileCode;
  String userName;
  String email;
  String password;
  String profilePicture;

  RegisterUseCaseInput(this.countryMobileCode, this.userName, this.email,
      this.password, this.profilePicture);
}
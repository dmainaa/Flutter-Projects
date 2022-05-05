import 'package:dartz/dartz.dart';
import 'package:tutapp/data/network/failure.dart';
import 'package:tutapp/data/requests/request.dart';
import 'package:tutapp/data/responses/responses.dart';
import '../model/model.dart';

abstract class Repository{

  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest);
  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword(ForgotPasswordRequest request);


}
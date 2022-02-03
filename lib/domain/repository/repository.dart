import 'package:dartz/dartz.dart';
import 'package:tutapp/data/network/failure.dart';
import 'package:tutapp/data/requests/request.dart';
import '../model/model.dart';

abstract class Repository{

  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);


}


import 'package:dartz/dartz.dart';
import 'package:tutapp/data/network/failure.dart';

abstract class BaseUseCase<In, Out>{
  //You can create the usecase in anycase that you want
  Future<Either<Failure, Out>> execute(In input);
}
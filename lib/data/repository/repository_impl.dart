

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tutapp/data/data_source/remote_data_source.dart';
import 'package:tutapp/data/network/error_handler.dart';
import 'package:tutapp/data/network/failure.dart';
import 'package:tutapp/data/network/network_info.dart';
import 'package:tutapp/data/requests/request.dart';
import '../../domain/model/model.dart';
import '../../domain/repository/repository.dart';
import 'package:tutapp/data/mapper/mapper.dart';

class RepositoryImpl extends Repository{
  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);
  @override
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest) async{

    if(await _networkInfo.isConnected){

//        print('Request Response Status');
//
//        final response = await _remoteDataSource.login(loginRequest);
//
//        if(response.status == AppInternalStatus.SUCCESS){
//
//        print('The request was a success');
//
//        return Right(response.toDomain());
//      }else{
//        return Left(Failure(response.status ?? AppInternalStatus.FAILURE, response.message ?? ResponseCodeMessage.NOT_FOUND));
//      }

      try{
        print('Request Response Status');
        final response = await _remoteDataSource.login(loginRequest);
        print('Request Response Status $response');
        if(response.status == AppInternalStatus.SUCCESS){
          print('The request was a success');

          return Right(response.toDomain());
        }else{
          print('The request was a failure: ');
          return Left(Failure(response.status ?? AppInternalStatus.FAILURE, response.message ?? ResponseCodeMessage.NOT_FOUND));
        }
      }catch(error){

        print('The request was a failure: ');
        return Left(ErrorHandler.handle(error).failure);
      }

    }else{

      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());

    }
  }
}
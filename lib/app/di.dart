
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutapp/app/app_prefs.dart';
import 'package:tutapp/data/data_source/remote_data_source.dart';
import 'package:tutapp/data/network/app_api.dart';
import 'package:tutapp/data/network/dio_factory.dart';
import 'package:tutapp/data/network/network_info.dart';
import 'package:tutapp/data/repository/repository_impl.dart';
import 'package:tutapp/domain/repository/repository.dart';
import 'package:tutapp/domain/usecase/forgotpassword_usecase.dart';
import 'package:tutapp/domain/usecase/login_usecase.dart';
import 'package:tutapp/domain/usecase/register_usecase.dart';
import 'package:tutapp/presentation/forgot_password/forgot_passwordviewmodel.dart';
import 'package:tutapp/presentation/login/login_viewmodel.dart';
import 'package:tutapp/presentation/register/register_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule()async{

  final sharedPreferences =  await SharedPreferences.getInstance();

  //shared preferences instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);


  //app preferences instance
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));


  //app networkinfo instance
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(DataConnectionChecker()));

  //dio factory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  //app service client
  final dio = await instance<DioFactory>().getDio();

  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  //remote data source

  instance.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImplementer(instance()));

  //repository

  instance.registerLazySingleton<Repository>(() => RepositoryImpl(instance(), instance()));

  initLoginModule();

}


initLoginModule(){

  if(!GetIt.I.isRegistered<LoginUseCase>()){
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
  if(!GetIt.I.isRegistered<ForgotPasswordUseCase>()){
    instance.registerFactory<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(() => ForgotPasswordViewModel(instance()));
  }



}

initRegisterModule(){
  if(!GetIt.I.isRegistered<RegisterUseCase>()){
    instance.registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(() => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}
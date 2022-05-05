

import 'dart:async';
import 'dart:ffi';

import 'package:analyzer/file_system/file_system.dart';
import 'package:tutapp/presentation/base/baseviewmodel.dart';

class RegisterViewModel extends BaseViewModel{
  StreamController _userNameStreamController = StreamController<String>.broadcast();
  StreamController _passwordStreamController = StreamController<String>.broadcast();
  StreamController _emailStreamController = StreamController<String>.broadcast();
  StreamController _mobileNumberStreamController = StreamController<String>.broadcast();
  StreamController _profilePictureStreamController = StreamController<File>.broadcast();
  StreamController _isAllInputValidStreamController = StreamController<Void>.broadcast();

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _emailStreamController.close();
    _mobileNumberStreamController.close();
    _profilePictureStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  void start() {

  }
}

abstract class RegisterViewModelInput{
    register();

    Sink get inputUserName;
    Sink get inputMobileNumber;
    Sink get inputEmail;
    Sink get inputPassword;
    Sink get inputProfilePicture;

}

abstract class RegisterViewModelOutput{
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsMobileNumberValid;
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsProfilePictureValid;



}
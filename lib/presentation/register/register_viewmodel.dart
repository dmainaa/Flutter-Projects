

import 'dart:async';
import 'dart:ffi';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:tutapp/domain/usecase/register_usecase.dart';
import 'package:tutapp/presentation/base/baseviewmodel.dart';
import 'package:tutapp/presentation/common/freezed_data_classes.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer_impl.dart';

class RegisterViewModel extends BaseViewModel with RegisterViewModelInput, RegisterViewModelOutput{

  StreamController _userNameStreamController = StreamController<String>.broadcast();
  StreamController _passwordStreamController = StreamController<String>.broadcast();
  StreamController _emailStreamController = StreamController<String>.broadcast();
  StreamController _mobileNumberStreamController = StreamController<String>.broadcast();
  StreamController _profilePictureStreamController = StreamController<File>.broadcast();
  StreamController _isAllInputValidStreamController = StreamController<Void>.broadcast();
  StreamController _isUserRegisteredSuccessfully = StreamController<Void>.broadcast();

  RegisterUseCase registerUseCase;

  var registerObject = RegisterObject("", "", "", "", "", "");




  RegisterViewModel(this.registerUseCase);

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
    inputState.add(ContentState());
  }

  //Sinks


  @override
  Sink get inputAllInputsValid {
    return _isAllInputValidStreamController.sink;
  }

  @override
  Sink get inputProfilePicture {
    return _profilePictureStreamController.sink;
  }

  @override
  Sink get inputPassword {
    return _passwordStreamController.sink;
  }

  @override
  Sink get inputEmail {
    return _emailStreamController.sink;
  }

  @override
  Sink get inputMobileNumber {
    return _mobileNumberStreamController.sink;
  }


  @override
  Sink get isUserRegistered {
    return _isUserRegisteredSuccessfully.sink;
  }

  @override
  Sink get inputUserName {
    return _userNameStreamController.sink;
  }

  @override
  register()  async{
      debugPrint("Register has been called");
      inputState.add(LoadingState(StateRendererType.POPUP_LOADING_STATE, ""));
        (await registerUseCase.execute(RegisterUseCaseInput("+254", registerObject.userName, "abc@gmail.com", "123456", ""))).fold(
              (failure) => {
                inputState.add(ContentState()),

                isUserRegistered.add(null)


              }, (data) => inputState.add(ContentState()));

  }

  //Streams

  @override
  Stream<String?> get outputErrorMobileNumber {
      return  outputIsMobileNumberValid.map((isValid) => isValid ? null : "Invalid Phone Number");
  }

  @override
  Stream<String?> get outputErrorEmail {
     return outputIsEmailValid.map((isValid) => isValid ? null : "Invalid Email");
  }

  @override
  Stream<bool> get outputIsPasswordValid {
      return  _passwordStreamController.stream.map((password) => _isPasswordValid(password));
  }

  @override
  Stream<String?> get outputErrorPassword {
    return outputIsPasswordValid.map((isValid) => isValid ? null : "Invalid Password");
  }

  @override
  Stream<File> get outputProfilePicture {
    return _profilePictureStreamController.stream.map((file) => file);
  }

  @override
  Stream<bool> get outputIsEmailValid {
    return _emailStreamController.stream.map((email) => _isEmailValid(email));
  }


  @override
  Stream<bool> get isUserRegisteredSuccessfully {
    return _isUserRegisteredSuccessfully.stream.map((event) => true);
  }

  @override
  Stream<bool> get outputIsMobileNumberValid {
    return _mobileNumberStreamController.stream.map((mobileNumber) => _isMobileNumberValid(mobileNumber));
  }

  @override
  Stream<bool> get outputIsUserNameValid {
      return _userNameStreamController.stream.map((userName) => _isUserNameValid(userName));
  }


  @override
  Stream<String?> get outputErrorUserName {
    return  outputIsUserNameValid.map((isUserNameValid) => isUserNameValid ? null : "Invalid Username");
  }

  @override
  Stream<bool> get outputIsAllInputsValid {
      return _isAllInputValidStreamController.stream.map((_) => _validateAllInputs());
  }


  bool _isUserNameValid(String userName){
    return userName.length >= 1 ;

  }

  bool _isEmailValid(String email){
    print(email);
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
  }

  bool _isMobileNumberValid(String userName){
    return userName.length >= 10 ;

  }

  bool _validateAllInputs(){

    return
        registerObject.email.isNotEmpty &&
                registerObject.password.isNotEmpty &&
                registerObject.userName.isNotEmpty &&
//                registerObject.countryMobileCode.isNotEmpty &&
                registerObject.mobileNumber.isNotEmpty;

  }

  _validate(){
    inputAllInputsValid.add(null);
  }


  bool _isPasswordValid(String userName){
    return userName.length >= 5;

  }


  @override
  setUserName(String username) {
    debugPrint("Entered username $username");
    inputUserName.add(username);
    if(_isUserNameValid(username)){
      //update register object with value
      registerObject = registerObject.copyWith(userName: username);

    }else{
      //reset username value in register viewobject
      registerObject = registerObject.copyWith(userName: "");
    }
    _validate();
  }

  @override
  setEmail(String email) {
    debugPrint("Entered email $email");
    inputEmail.add(email);
    if(_isEmailValid(email)){
      //update register object with value
      registerObject = registerObject.copyWith(email: email);

    }else{
      //reset username value in register viewobject
      registerObject = registerObject.copyWith(email: "");
    }
    _validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    debugPrint("Entered phone number $mobileNumber");
    inputMobileNumber.add(mobileNumber);
    if(_isMobileNumberValid(mobileNumber)){

      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);

    }else{

      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    _validate();
  }

  @override
  setPassword(String password) {
    debugPrint("Entered password $password");
    inputPassword.add(password);
    if(_isPasswordValid(password)){

      registerObject = registerObject.copyWith(password: password);

    }else{

      registerObject = registerObject.copyWith(password: "");
    }
    _validate();
  }

  @override
  setProfilePicture(File file) {
    debugPrint("Entered file path ${file.path}");
    inputProfilePicture.add(file);
    if(file.path.isNotEmpty){
      print("File has been added successfully");
      registerObject = registerObject.copyWith(profilePicture: file.path);

    }else{

      registerObject = registerObject.copyWith(profilePicture: "");
    }
    _validate();
  }

  @override
  setCountryCode(String countryCode) {
    debugPrint("Entered country code $countryCode");
    if(countryCode.isNotEmpty){

      registerObject = registerObject.copyWith(countryMobileCode: countryCode);

    }else{

      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    _validate();

  }


}

abstract class RegisterViewModelInput{
    register();

    setUserName(String username);

    setEmail(String email);
    setMobileNumber(String mobileNumber);
    setPassword(String password);
    setProfilePicture(File file);
    setCountryCode(String countryCode);

    Sink get inputUserName;
    Sink get inputMobileNumber;
    Sink get inputEmail;
    Sink get inputPassword;
    Sink get inputProfilePicture;
    Sink get inputAllInputsValid;
    Sink get isUserRegistered;

}

abstract class RegisterViewModelOutput{

  Stream<bool> get outputIsUserNameValid;

  Stream<String?> get outputErrorUserName;

  Stream<bool> get outputIsMobileNumberValid;

  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;

  Stream<String?> get outputErrorEmail;

  Stream<File> get outputProfilePicture;

  Stream<bool> get outputIsPasswordValid;

  Stream<bool> get outputIsAllInputsValid;

  Stream<String?> get outputErrorPassword;

  Stream<bool> get isUserRegisteredSuccessfully;



}
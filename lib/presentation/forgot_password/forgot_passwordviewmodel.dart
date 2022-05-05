

import 'dart:async';

import 'package:tutapp/domain/usecase/forgotpassword_usecase.dart';
import 'package:tutapp/presentation/base/baseviewmodel.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel implements ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutPuts{

  ForgotPasswordUseCase _forgotPasswordUseCase;
  String email = "";
  StreamController _emailStreamController = StreamController<String>.broadcast();
  StreamController _passwordResetController = StreamController<String>.broadcast();


  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  @override
  void start() {
    inputState.add(ContentState());
  }

  bool validateEmail(){
    print(email);
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
  }


  @override
  Stream<bool> get isEmailValid {
    return _emailStreamController.stream.map((_) => validateEmail());
  }



  @override
  setEmail(String entered_email) {

    email = entered_email;
    inputEmail.add(email);

  }

  void requestResetPassword() async{
    inputState.add(LoadingState(StateRendererType.POPUP_LOADING_STATE, null));
    (await (_forgotPasswordUseCase.execute(ForgotPasswordCaseInput("abc@gmail.com")))).fold((failure) => {
     inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message))

   }, (data) => {

     inputState.add(ContentState()),

      inputPasswordReset.add("Success")

   });
  }



  @override
  Sink get inputEmail {

    return _emailStreamController.sink;
  }

  @override
  Stream<bool> get isPasswordResetSuccessfully {
   return _emailStreamController.stream.map((event) => true);
  }

  @override
  Sink get inputPasswordReset {
    return _passwordResetController.sink;
  }
}

abstract class ForgotPasswordViewModelInputs{
  setEmail(String email);

  requestResetPassword();

  Sink get inputEmail;

  Sink get inputPasswordReset;

}

abstract class ForgotPasswordViewModelOutPuts{
  Stream<bool> get isEmailValid;
  Stream<bool> get isPasswordResetSuccessfully;

}
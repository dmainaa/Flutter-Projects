

import 'dart:async';

import 'package:tutapp/domain/usecase/login_usecase.dart';
import 'package:tutapp/presentation/base/baseviewmodel.dart';
import 'package:tutapp/presentation/common/freezed_data_classes.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer_impl.dart';

class LoginViewModel extends BaseViewModel with LoginViewModelInputs, LoginViewModelOutputs {

  StreamController _userNameStreamController = StreamController<String>.broadcast();
  StreamController _passwordStreamController = StreamController<String>.broadcast();
  StreamController _allInputIsValidController = StreamController<void>.broadcast();

  StreamController isUserLoggedInSuccessfully = StreamController<bool>.broadcast();

  var loginObject = LoginObject("", "");

  LoginUseCase _loginUseCase;


  LoginViewModel(this._loginUseCase);

  @override
  void start() {
    inputState.add(ContentState());
  }


  @override
  Sink get inputIsAllInputValid {
      return _allInputIsValidController.sink;
  }


  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _allInputIsValidController.close();
    isUserLoggedInSuccessfully.close();
  }

  @override
  Stream<bool> get outputIsAllInputValid{
    return _allInputIsValidController.stream.map((_) => isAllInputValid());
  }


  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream.map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUsernameValid => _userNameStreamController.stream.map((username) => _isUsernameValid(username));

  bool _isPasswordValid(String password){
    return password.isNotEmpty;
  }

 bool _isUsernameValid(String username){
    return username.isNotEmpty;
  }

  bool isAllInputValid(){
    return _isUsernameValid(loginObject.username) && _isPasswordValid(loginObject.password);
  }

  @override
  Sink get inputPassword {
    return _passwordStreamController.sink;
  }

  @override
  Sink get inputUserName {
    return _userNameStreamController.sink;
  }


  @override
  setPassword(String password) {
      inputPassword.add(password);
      loginObject = loginObject.copyWith(password: password);
      _validate();
  }

  @override
  setUserName(String userName) {
      inputUserName.add(userName);
      loginObject = loginObject.copyWith(username: userName);
      _validate();

  }

  _validate(){
    inputIsAllInputValid.add(null);
  }

  @override
  login() async{
    inputState.add(LoadingState(StateRendererType.POPUP_LOADING_STATE, null));
    print('Login has been called');
    (await _loginUseCase.execute(LoginUseCaseInput(loginObject.username, loginObject.password))).fold((failure) => {
        inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message))

    }, (data) => {

        inputState.add(ContentState()),

        isUserLoggedInSuccessfully.add(true)


    });
  }


}

abstract class LoginViewModelInputs{

  setUserName(String userName);
  setPassword (String password);

  login();

  Sink get inputUserName;

  Sink get inputPassword;

  Sink get inputIsAllInputValid;
}

abstract class LoginViewModelOutputs{
  Stream<bool> get outputIsUsernameValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<bool> get outputIsAllInputValid;
}


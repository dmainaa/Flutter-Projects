import 'package:flutter/material.dart';
import 'package:tutapp/app/app.dart';
import 'package:tutapp/app/di.dart';
import 'package:tutapp/presentation/login/login_viewmodel.dart';
import 'package:tutapp/presentation/resources/assets_manager.dart';
import 'package:tutapp/presentation/resources/color_manager.dart';
import 'package:tutapp/presentation/resources/routes_manager.dart';
import 'package:tutapp/presentation/resources/strings_manager.dart';
import 'package:tutapp/presentation/resources/value_manager.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = instance<LoginViewModel>();

  TextEditingController _userNameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  final   _formKey = GlobalKey<FormState>();

  _bind(){
    _viewModel.start();
    _userNameController.addListener(() => _viewModel.setUserName(_userNameController.text));
    _passwordController.addListener(() => _viewModel.setPassword(_passwordController.text));
  }
  @override
  void initState() {
    _bind();
  }

  Widget getContentWidget(){
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(AssetsManager.splashLogo),
                SizedBox(height: AppPadding.p28,),
                Padding(padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsUsernameValid,
                    builder: (context, snapshot){
                      return TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _userNameController,
                        decoration: InputDecoration(
                          hintText:  AppStrings.username,
                          labelText: AppStrings.username,
                          errorText: (snapshot.data ?? true) ? null : AppStrings.username,

                        ),

                      );
                    },
                  )
                  ,),
                SizedBox(height: AppPadding.p28,),
                Padding(padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsPasswordValid,
                    builder: (context, snapshot){
                      return TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText:  AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: (snapshot.data ?? true) ? null : AppStrings.passwordError,

                        ),

                      );
                    },
                  )
                  ,),
                  SizedBox(height: AppPadding.p28,),
                  Padding(padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsAllInputValid,
                      builder: (context, snapshot){
                        return SizedBox(
                          width: double.infinity,
                          height: AppSize.s40,
                          child: ElevatedButton(
                            onPressed: (snapshot.data ?? false) ?  (){_viewModel.login();} : null, child: Text(AppStrings.login),
                          ),
                        );
                      },
                    )
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    top: AppPadding.p8,
                    left: AppPadding.p28,
                    right: AppPadding.p28
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){Navigator.pushReplacementNamed(context, Routes.forgotPasswordRoute);}, child:  Text(
                    AppStrings.forgetPassword, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 12.0), textAlign: TextAlign.end,
                  )),
                      TextButton(onPressed: (){Navigator.pushReplacementNamed(context, Routes.registerRoute);}, child:  Text(
                        AppStrings.registerText, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 12.0), textAlign: TextAlign.end,
                      )),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getContentWidget() ;
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

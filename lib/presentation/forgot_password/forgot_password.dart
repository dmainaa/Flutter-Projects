import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:tutapp/presentation/forgot_password/forgot_passwordviewmodel.dart';
import 'package:tutapp/presentation/resources/assets_manager.dart';
import 'package:tutapp/presentation/resources/strings_manager.dart';
import 'package:tutapp/presentation/resources/value_manager.dart';
import 'package:tutapp/app/di.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController emailEditingController = TextEditingController();
  ForgotPasswordViewModel _viewModel = instance<ForgotPasswordViewModel>();
  final   _formKey = GlobalKey<FormState>();

  _bind(){

    emailEditingController.addListener(() => _viewModel.setEmail(emailEditingController.text));

  }


  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot){
          return snapshot.data?.getScreenWidget(context, getContentWidget(), (){})  ?? getContentWidget();
        },
      ),
    );
  }

  Widget getContentWidget(){
   return  Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AssetsManager.splashLogo),
            SizedBox(height: AppPadding.p28,),
            Padding(padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
              child: StreamBuilder<bool>(
                stream: _viewModel.isEmailValid,
                builder: (context, snapshot){
                  print(snapshot.data);
                  return TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailEditingController,
                    decoration: InputDecoration(
                      hintText:  AppStrings.email,
                      labelText: AppStrings.email,
                      errorText: (snapshot.data ?? true) ? null : "Enter a valid email",
                    ),

                  );
                },
              )
              ,),
            SizedBox(height: AppPadding.p28,),
            Padding(padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<bool>(
                  stream: _viewModel.isEmailValid,
                  builder: (context, snapshot){
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false) ?  (){_viewModel.requestResetPassword();} : null, child: Text(AppStrings.login),
                      ),
                    );
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}

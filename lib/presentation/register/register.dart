
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutapp/data/mapper/mapper.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:tutapp/presentation/register/register_viewmodel.dart';
import 'package:tutapp/presentation/resources/assets_manager.dart';
import 'package:tutapp/presentation/resources/color_manager.dart';
import 'package:tutapp/presentation/resources/routes_manager.dart';
import 'package:tutapp/presentation/resources/strings_manager.dart';
import 'package:tutapp/presentation/resources/value_manager.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  RegisterViewModel _viewModel = GetIt.instance<RegisterViewModel>();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _userNameTextEditingController = TextEditingController();
  TextEditingController _mobileNumberTextEditingController = TextEditingController();
  TextEditingController _userEmailEditingController = TextEditingController();
  TextEditingController _userPasswordTextEditingController = TextEditingController();

  ImagePicker imagePicker = GetIt.instance<ImagePicker>();



  @override
  void initState() {
    super.initState();

    _bind();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.primary),
        backgroundColor: ColorManager.white,
      ),
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot){
          return Center(
              child: snapshot.data?.getScreenWidget(context, getContentWidget(), (){_viewModel.register();}) ?? getContentWidget());
        },
      ),
    );
  }

  Widget getContentWidget(){
    return  Container(
      padding: const EdgeInsets.only(top: AppPadding.p60),

      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(AssetsManager.splashLogo),
              SizedBox(height: AppSize.s12,),
              Padding(
                padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorUserName,
                  builder: (context, snapshot){
                    return TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userNameTextEditingController,
                      decoration: InputDecoration(
                        hintText:  AppStrings.username,
                        labelText: AppStrings.username,
                        errorText: snapshot.data,

                      ),

                    );
                  },
                )
                ,),
              SizedBox(height: AppSize.s12,),

              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: AppPadding.p12,
                      left: AppPadding.p28,
                      right: AppPadding.p28,
                      bottom: AppPadding.p12),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: CountryCodePicker(
                        onChanged: (country){
                          _viewModel.setCountryCode(country.dialCode ?? EMPTY);
                        },
                        initialSelection: "+254",
                        showCountryOnly: true,
                        hideMainText: true,
                        showOnlyCountryWhenClosed: true,
                        favorite: ["+254", "+255", "+256"],
                      )),
                      Expanded(flex: 3, child: StreamBuilder<String?>(
                        stream: _viewModel.outputErrorMobileNumber,
                        builder: (context, snapshot){
                          return TextField(
                            keyboardType: TextInputType.phone,
                            controller: _mobileNumberTextEditingController,
                            decoration: InputDecoration(
                              hintText:  AppStrings.mobileNumber,
                              labelText: AppStrings.mobileNumber,
                              errorText: snapshot.data,

                            ),

                          );
                        },
                      ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppPadding.p12,),
              Padding(
                padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorEmail,
                  builder: (context, snapshot){
                    return TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userEmailEditingController,
                      decoration: InputDecoration(
                        hintText:  AppStrings.email,
                        labelText: AppStrings.email,
                        errorText: snapshot.data,

                      ),

                    );
                  },
                )
                ,),
              SizedBox(height: AppSize.s12,),

              Padding(padding: const EdgeInsets.only(
                  left: AppPadding.p28, 
                  right: AppPadding.p28,
                  top: AppPadding.p12,
                  
              ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorPassword,
                  builder: (context, snapshot){
                    return TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userPasswordTextEditingController,
                      decoration: InputDecoration(
                        hintText:  AppStrings.password,
                        labelText: AppStrings.password,
                        errorText: snapshot.data,

                      ),

                    );
                  },
                )
                ,),
          SizedBox(height: AppSize.s12,),
          Padding(
            padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
            child: Container(
              height: AppSize.s40,
              decoration: BoxDecoration(
                border: Border.all(color: ColorManager.lightgrey)
              ),
              child: GestureDetector(
                child: _getMediaWidget(),
                onTap: (){
                  _showPicker(context);
                },
              ),
            ),
          ),
              SizedBox(height: AppPadding.p28,),
              Padding(padding: const EdgeInsets.only(left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsAllInputsValid,
                    builder: (context, snapshot){
                      debugPrint(snapshot.data.toString());
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(

                          onPressed: (snapshot.data ?? false) ?  (){
                            _viewModel.register();
                          } : null, child: Text(AppStrings.register),
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
                child: TextButton(onPressed: (){Navigator.of(context).pop();}, child:  Text(
                  AppStrings.haveAnAccount, style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 6.0), textAlign: TextAlign.end,
                )),
                ),




            ],
          ),
        ),
      ),

    );
  }

  _showPicker(BuildContext context){
    showModalBottomSheet(context: context, builder: (context){
      return SafeArea(
        child: Wrap(
          children: [
             ListTile(
               trailing: Icon(Icons.arrow_forward),
               leading: Icon(Icons.camera),
               title: Text(AppStrings.photoGallery),
               onTap: (){
                  _imageFromGallery();
                  Navigator.of(context).pop(true);
               },
             ),
            ListTile(
              trailing: Icon(Icons.arrow_forward),
              leading: Icon(Icons.camera_alt_rounded),
              title: Text(AppStrings.photoPicture),
              onTap: (){
                _imageFromCamera();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );
    });
  }

  _imageFromGallery() async{
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async{
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  Widget _getMediaWidget(){
    return Padding(
        padding: EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(AppStrings.profilePicture),),
            Flexible(child: StreamBuilder<File>(
              stream: _viewModel.outputProfilePicture,
              builder: (context, snapshot){
                  return _imagePickedByUser(snapshot.data);
              },
            ),),
            Flexible(child: SvgPicture.asset("assets/images/photo_camera_ic.svg"))
          ],
        ),
    );
  }



  _bind(){
    _viewModel.start();
    
    _userNameTextEditingController.addListener(() {

      _viewModel.setUserName(_userNameTextEditingController.text);

    });
    _userPasswordTextEditingController.addListener(() {

      _viewModel.setPassword(_userPasswordTextEditingController.text);

    });
    _userEmailEditingController.addListener(() {

      _viewModel.setEmail(_userEmailEditingController.text);

    });
    _mobileNumberTextEditingController.addListener(() {

      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);

    });

    _viewModel.isUserRegisteredSuccessfully.listen((event) {
      //Navigate to main screen
      SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }
}

Widget _imagePickedByUser(File? image) {
    if(image != null && image.path.isNotEmpty){
      return Image.file(image);
    }else{
      return Container();
    }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutapp/domain/model/model.dart';

import 'package:tutapp/presentation/onboardiing/onboarding_viewmodel.dart';
import 'package:tutapp/presentation/resources/assets_manager.dart';
import 'package:tutapp/presentation/resources/color_manager.dart';
import 'package:tutapp/presentation/resources/routes_manager.dart';
import 'package:tutapp/presentation/resources/strings_manager.dart';
import 'package:tutapp/presentation/resources/value_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingView extends StatefulWidget {
  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {





  String string14 = "fkalfa";

  PageController _pageController = PageController(initialPage: 0);

  OnboardingViewModel _viewModel = OnboardingViewModel();

  _bind(){
    _viewModel.start();
  }



  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bind();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SlideViewObject>(stream: _viewModel.outputSliderViewObject, builder: (context, snapshot){
      return _getContentWidget(snapshot.data);
    },);
  }

  Widget _getContentWidget(SlideViewObject? slideViewObject){
    if(slideViewObject == null){
      return Container();
    } else return Scaffold(

      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,


      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: slideViewObject.numOfSlides,
        onPageChanged: (index) {
          _viewModel.onPageChanged(index);
        },

        itemBuilder: (context, index) {
          return OnBoardingPage(slideViewObject.sliderObject);
        },

      ),
      bottomSheet: Container(
        color: ColorManager.white,
        height: AppSize.s100,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {Navigator.pushReplacementNamed(context, Routes.loginRoute);}, child: Text(
                AppStrings.skip, style: Theme.of(context).textTheme.subtitle2, textAlign: TextAlign.end,
              )),
            ),
            _getBottomSheetWidget(slideViewObject)
          ],
        ),

      ),
    );
  }


  Widget _getBottomSheetWidget(SlideViewObject slideViewObject) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primary
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding: EdgeInsets.all(AppPadding.p14), child: GestureDetector(
            onTap: (){
              _pageController.animateToPage(_viewModel.goPrevious(), duration: Duration(milliseconds: DurationConstant.d300), curve: Curves.bounceInOut);
            },
            child: SizedBox(
              height: AppSize.s20,
              width: AppSize.s20,
              child: SvgPicture.asset(AssetsManager.leftArrowIc),


            ),
          ),),
          Row(
            children: [
              for(int i =0; i<slideViewObject.numOfSlides; i++)
                Padding(padding: EdgeInsets.all(AppPadding.p8), child: _getProperCircle(i, slideViewObject.currentIndex),),

            ],
          ),
          //circle indicators
          Padding(padding: EdgeInsets.all(AppPadding.p14), child: GestureDetector(
            onTap: (){
              _pageController.animateToPage(_viewModel.goNext(), duration: Duration(milliseconds: DurationConstant.d300), curve: Curves.bounceInOut);
            },
            child: SizedBox(
              height: AppSize.s20,
              width: AppSize.s20,
              child: SvgPicture.asset(AssetsManager.rightArrowIc),


            ),
          ),)
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int _currentIndex){
    if(index == _currentIndex){
      return SvgPicture.asset(AssetsManager.hollowCircleIc);
    }else{
      return SvgPicture.asset(AssetsManager.solidCircleIc);
    }
  }

}



class OnBoardingPage extends StatelessWidget {


  SliderObject _sliderObject;


  OnBoardingPage(this._sliderObject);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: AppSize.s40,),
        Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Text(_sliderObject.title, style: Theme.of(context).textTheme.headline1,)),
        Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Text(_sliderObject.subTitle, style: Theme.of(context).textTheme.subtitle1,)),
        SizedBox(height: AppSize.s60,),

        SvgPicture.asset(_sliderObject.image),

      ],
    );
  }

}






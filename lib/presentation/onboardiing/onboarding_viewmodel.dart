import 'dart:async';

import 'package:tutapp/domain/model.dart';
import 'package:tutapp/presentation/base/baseviewmodel.dart';
import 'package:tutapp/presentation/resources/assets_manager.dart';
import 'package:tutapp/presentation/resources/strings_manager.dart';

class OnboardingViewModel extends BaseViewModel with OnBoardingViewModelInputs, OnBoardingViewModelOutputs{

  final StreamController _streamController = StreamController<SlideViewObject>();

  late List<SliderObject> _list;



  int _currentIndex = 0;


  @override
  Sink get inputSliderViewObject {
      return _streamController.sink;
  }

  @override
  void start() {
    _list = _getSliderObjects();
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  int goPrevious() {

    int previousIndex = _currentIndex -- ;
    if(previousIndex == -1){
      _currentIndex = _list.length -1;//This will create an infinite loop
    }


    return _currentIndex;
  }

  @override
  int goNext() {
    int nextIndex = _currentIndex++ ;
    if(nextIndex >= _list.length){
      _currentIndex = 0;//This will create an infinite loop
    }

    return _currentIndex;
  }

  void _postDataToView(){
    inputSliderViewObject.add(SlideViewObject(_list[_currentIndex], _list.length  , _currentIndex));
  }

  List<SliderObject> _getSliderObjects() =>
      [
        SliderObject(AppStrings.onBoardingTitle1, AppStrings.onBoardingTitle1,
            AssetsManager.onboardingLogo1),
        SliderObject(AppStrings.onBoardingTitle2, AppStrings.onBoardingTitle2,
            AssetsManager.onboardingLogo2),
        SliderObject(AppStrings.onBoardingTitle3, AppStrings.onBoardingTitle3,
            AssetsManager.onboardingLogo3),
        SliderObject(AppStrings.onBoardingTitle4, AppStrings.onBoardingTitle4,
            AssetsManager.onboardingLogo4),

      ];



  @override
  Stream<SlideViewObject> get outputSliderViewObject => _streamController.stream.map((slideViewObject) => slideViewObject);
}

abstract class OnBoardingViewModelInputs{
    void goNext(); //When the user clicks the right arrow
    void goPrevious();
    void onPageChanged(int index);

    Sink get inputSliderViewObject  => throw UnimplementedError();



}

abstract class OnBoardingViewModelOutputs{

  Stream<SlideViewObject> get outputSliderViewObject => throw UnimplementedError();
}

class SlideViewObject{
  SliderObject sliderObject;

  int numOfSlides;

  int currentIndex;

  SlideViewObject(this.sliderObject, this.numOfSlides, this.currentIndex);
}
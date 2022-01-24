abstract class BaseViewModel extends BaseViewModelInputs with BaseViewModelOutputs{


  //shared variables and functions that will be used through any view model
}

abstract class BaseViewModelInputs{
    void start(); //called when initializing the view model
    void dispose(); //called when the view model dies
}

abstract class BaseViewModelOutputs{

}
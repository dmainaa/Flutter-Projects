import 'dart:async';

import 'package:tutapp/presentation/common/state_renderer/state_renderer_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs with BaseViewModelOutputs{

    StreamController _inputStateStreamController = StreamController<FlowState>.broadcast();


    @override
  Sink get inputState => _inputStateStreamController.sink;

  @override
  void dispose() {
    _inputStateStreamController.close();
  }

    @override
  Stream<FlowState> get outputState => _inputStateStreamController.stream.map((flowstate) => flowstate);
//shared variables and functions that will be used through any view model


}

abstract class BaseViewModelInputs{
    void start(); //called when initializing the view model
    void dispose(); //called when the view model dies

    Sink get inputState;
}

abstract class BaseViewModelOutputs{
    Stream<FlowState> get outputState;
}
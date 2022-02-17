

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutapp/data/mapper/mapper.dart';
import 'package:tutapp/presentation/common/state_renderer/state_renderer.dart';
import 'package:tutapp/presentation/resources/strings_manager.dart';

abstract class FlowState{

  StateRendererType getStateRendererType();

  String getMessage();
}

class LoadingState extends FlowState{

  StateRendererType stateRendererType;
  String message;


  LoadingState(this.stateRendererType, String? message):
    message = message ?? AppStrings.loading
  ;


  @override
  StateRendererType getStateRendererType() {
    return stateRendererType;
  }

  @override
  String getMessage() {
    return message;
  }
}

class ErrorState extends FlowState{

  StateRendererType stateRendererType;
  String message;


  ErrorState(this.stateRendererType, this.message);

  @override
  StateRendererType getStateRendererType() {
    return stateRendererType;
  }

  @override
  String getMessage() {
    return message;
  }
}

class ContentState extends FlowState {

  ContentState();

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.CONTENT_SCREEN_STATE;
  }

  @override
  String getMessage() {
    return EMPTY;
  }
}

class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);

  @override
  StateRendererType getStateRendererType() {
    return StateRendererType.EMPTY_SCREEN_STATE;
  }

  @override
  String getMessage() {
    return message;
  }
}

extension FlowStateExtension on FlowState{
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget, Function retryActionFunction){
      switch(this.runtimeType){
        case LoadingState: {
          if(getStateRendererType() == StateRendererType.POPUP_LOADING_STATE){
            showPopUp(context, getStateRendererType(), getMessage());

            return contentScreenWidget;
          }else{
            return StateRenderer(stateRendererType: getStateRendererType(), message: getMessage(), retryActionFunction: retryActionFunction,);
          }

        }
        case ContentState: {
          dismissDialog(context);
          return contentScreenWidget;
        }
        case ErrorState: {
          dismissDialog(context);
          if(getStateRendererType() == StateRendererType.POPUP_ERROR_STATE){
            showPopUp(context, getStateRendererType(), getMessage());

            return contentScreenWidget;
          }else{
            return StateRenderer(stateRendererType: getStateRendererType(), message: getMessage(), retryActionFunction: retryActionFunction,);
          }

        }
        default: {
            return contentScreenWidget;
        }
      }
  }

  dismissDialog(BuildContext context){
    if(_isThereCurrentDialogShowing(context)){
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }
  _isThereCurrentDialogShowing(BuildContext context)=> ModalRoute.of(context)?.isCurrent != true;

  showPopUp(BuildContext context, StateRendererType stateRendererType, String message){

    WidgetsBinding.instance?.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(stateRendererType: stateRendererType, message: message, retryActionFunction: (){}) ));
  }
}

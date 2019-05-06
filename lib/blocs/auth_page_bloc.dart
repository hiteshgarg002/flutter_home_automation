import 'dart:io';

import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class AuthPageBloc implements BlocBase {
  BehaviorSubject<bool> _viewPwdStatusController;
  PublishSubject<bool> _loginButtonClickedStatusController;
  PublishSubject<bool> _signupStatusController;
  PublishSubject<File> _selectedPhotoController;

  AuthPageBloc() {
    _viewPwdStatusController = BehaviorSubject<bool>();
    _loginButtonClickedStatusController = PublishSubject<bool>();
    _signupStatusController = PublishSubject<bool>();
    _selectedPhotoController = PublishSubject<File>();
  }

  Sink<bool> get _setViewPwdStatus => _viewPwdStatusController.sink;
  Observable<bool> get getViewPwdStatus => _viewPwdStatusController.stream;

  Sink<bool> get _setLoginButtonClickedStatus =>
      _loginButtonClickedStatusController.sink;
  Observable<bool> get getLoginButtonClickedStatus =>
      _loginButtonClickedStatusController.stream;

  Sink<bool> get _setSignupStatus => _signupStatusController.sink;
  Observable<bool> get getSignupStatus => _signupStatusController.stream;

  Sink<File> get _setSelectedPhoto => _selectedPhotoController.sink;
  Observable<File> get getSelectedPhoto => _selectedPhotoController.stream;

  void setSelectedPhoto(File photo) {
    _setSelectedPhoto.add(photo);
  }

  void setSignupStatus(bool status) {
    _setSignupStatus.add(status);
  }

  void setLoginButtonStatus(bool status) {
    _setLoginButtonClickedStatus.add(status);
  }

  void setViewPwdStatus(bool status) {
    _setViewPwdStatus.add(status);
  }

  @override
  void dispose() async {
    await _viewPwdStatusController.drain();
    await _loginButtonClickedStatusController.drain();
    await _signupStatusController.drain();
    await _selectedPhotoController.drain();

    await _viewPwdStatusController.close();
    await _loginButtonClickedStatusController.close();
    await _signupStatusController.close();
    await _selectedPhotoController.close();
  }
}

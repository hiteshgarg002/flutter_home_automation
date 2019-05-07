import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProfileDialogBloc implements BlocBase {
  PublishSubject<bool> _initialLoadingController;
  PublishSubject<bool> _nameUpdateLoadingController;
  PublishSubject<bool> _sharedPreferencesLoadingController;
  PublishSubject<bool> _photoUploadingController;
  PublishSubject<bool> _nameEditModeController;

  ProfileDialogBloc() {
    _initialLoadingController = PublishSubject<bool>();
    _sharedPreferencesLoadingController = PublishSubject<bool>();
    _photoUploadingController = PublishSubject<bool>();
    _nameEditModeController = PublishSubject<bool>();
    _nameUpdateLoadingController = PublishSubject<bool>();
  }

  Sink<bool> get _setInitialLoadingStatus => _initialLoadingController.sink;
  Observable<bool> get _getInitialLoadingStatus =>
      _initialLoadingController.stream;

  Sink<bool> get _setSharedPreferencesLoadingStatus =>
      _sharedPreferencesLoadingController.sink;
  Observable<bool> get _getSharedPreferencesLoadingStatus =>
      _sharedPreferencesLoadingController.stream;

  Observable<bool> get getLoadingStatusCheck => Observable.combineLatest2(
          _getSharedPreferencesLoadingStatus, _getInitialLoadingStatus,
          (bool spLoading, bool iLoading) {
        return !spLoading && !iLoading;
      });

  Sink<bool> get _setPhotoUploadingStatus => _photoUploadingController.sink;
  Observable<bool> get getPhotoUploadingStatus =>
      _photoUploadingController.stream;

  Sink<bool> get _setNameEditModeStatus => _nameEditModeController.sink;
  Observable<bool> get getNameEditModeStatus => _nameEditModeController.stream;

  Sink<bool> get _setNameUpdateLoadingStatus =>
      _nameUpdateLoadingController.sink;
  Observable<bool> get getNameUpdateLoadingStatus =>
      _nameUpdateLoadingController.stream;

  void setNameUpdateLoadingStatus(bool status) {
    _setNameUpdateLoadingStatus.add(status);
  }

  void setNameEditModeStatus(bool status) {
    _setNameEditModeStatus.add(status);
  }

  void setPhotoUploadingStatus(bool status) {
    _setPhotoUploadingStatus.add(status);
  }

  void setSharedPreferencesLoadingStatus(bool status) {
    _setSharedPreferencesLoadingStatus.add(status);
  }

  void setInitialLoadingStatus(bool status) {
    _setInitialLoadingStatus.add(status);
  }

  @override
  void dispose() async {
    await _initialLoadingController.drain();
    await _sharedPreferencesLoadingController.drain();
    await _photoUploadingController.drain();
    await _nameEditModeController.drain();
    await _nameUpdateLoadingController.drain();

    await _initialLoadingController.close();
    await _sharedPreferencesLoadingController.close();
    await _photoUploadingController.close();
    await _nameEditModeController.close();
    await _nameUpdateLoadingController.close();
  }
}

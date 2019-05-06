import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class HomePageBloc implements BlocBase {
  BehaviorSubject<int> _drawerPageIndexController;
  BehaviorSubject<bool> _collapsedAppBarController;

  HomePageBloc() {
    _drawerPageIndexController = BehaviorSubject<int>();
    _collapsedAppBarController = BehaviorSubject<bool>();
  }

  Sink<int> get _setDrawerPageIndex => _drawerPageIndexController.sink;
  Observable<int> get getDrawerPageIndex => _drawerPageIndexController.stream;

  Sink<bool> get _setCollapsedAppBarStatus => _collapsedAppBarController.sink;
  Observable<bool> get getCollapsedAppBatStatus =>
      _collapsedAppBarController.stream;

  void setDrawerPageIndex(int index) {
    _setDrawerPageIndex.add(index);
  }

  void setCollapsedAppBarStatus(bool status) {
    _setCollapsedAppBarStatus.add(status);
  }

  @override
  void dispose() async {
    await _drawerPageIndexController.drain();
    await _collapsedAppBarController.drain();

    await _drawerPageIndexController.close();
    await _collapsedAppBarController.close();
  }
}

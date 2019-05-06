import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/add_appliance_page_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/models/auduino_model.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/appliance_type_enum.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:navigate/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAppliancePage extends StatefulWidget {
  final String roomId;
  final Function reloadRoom;

  AddAppliancePage({
    @required this.roomId,
    @required this.reloadRoom,
  });

  @override
  _AddAppliancePageState createState() => _AddAppliancePageState();
}

class _AddAppliancePageState extends State<AddAppliancePage> {
  final String _addButtonTag = "ADD_APPLIANCE";
  AddAppliancePageBloc _addAppliancePageBloc;
  List<ArduinoModel> _arduinoList;
  List<DropdownMenuItem<String>> _arduinoDropDownItemsList;
  List<DropdownMenuItem<int>> _pinDropDownItemsList;
  String _selectedDeviceId;
  int _selectedDevicePIN;
  String _applianceType;
  TextEditingController _applianceNameTextController;
  SharedPreferences _prefs;
  final GlobalKey<ScaffoldState> _sfKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _arduinoList = List<ArduinoModel>();
    _arduinoDropDownItemsList = List<DropdownMenuItem<String>>();
    _pinDropDownItemsList = List<DropdownMenuItem<int>>();
    _addAppliancePageBloc = BlocProvider.of<AddAppliancePageBloc>(context);

    _applianceNameTextController = TextEditingController();

    _setArduinoList();
    _setSharedPreferences();
  }

  Future _setSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future _setArduinoList() async {
    _arduinoList.addAll(await _addAppliancePageBloc.getAllArduinos());

    DropdownMenuItem<String> selectDeviceItem = DropdownMenuItem<String>(
      value: "",
      child: Text(
        "-- Select Device --",
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );

    _arduinoDropDownItemsList.add(selectDeviceItem);

    for (ArduinoModel arduinoModel in _arduinoList) {
      DropdownMenuItem<String> item = DropdownMenuItem<String>(
        value: arduinoModel.id,
        child: Text(
          "Device - ${arduinoModel.arduinoId}",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      _arduinoDropDownItemsList.add(item);
    }

    _addAppliancePageBloc.setLoadingStatus(false);
  }

  void _setPinList() {
    int deviceIndex = _arduinoList.indexWhere((ArduinoModel arduinoModel) {
      return arduinoModel.id == _selectedDeviceId;
    });

    ArduinoModel arduinoModel = _arduinoList[deviceIndex];

    if (_pinDropDownItemsList.isNotEmpty) {
      _pinDropDownItemsList.clear();
    }

    DropdownMenuItem<int> selectPinItem = DropdownMenuItem<int>(
      value: -1,
      child: Text(
        "-- PIN --",
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );

    _pinDropDownItemsList.add(selectPinItem);

    for (int pin in arduinoModel.unusedPinsList) {
      DropdownMenuItem<int> item = DropdownMenuItem<int>(
        value: pin,
        child: Text(
          "PIN - $pin",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      _pinDropDownItemsList.add(item);
    }
  }

  Widget _buildDeviceDropDownWidget() {
    return DropdownButtonHideUnderline(
      child: StreamBuilder<String>(
        initialData: "",
        stream: _addAppliancePageBloc.getArduinoDropDownValue,
        builder: (BuildContext context,
            AsyncSnapshot<String> dropDownValueSnapshot) {
          return DropdownButton<String>(
            hint: Text(
              "-- Select Device --",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            value: dropDownValueSnapshot.data,
            isDense: true,
            items: _arduinoDropDownItemsList,
            onChanged: (String value) {
              _selectedDeviceId = value;
              _setPinList();
              _addAppliancePageBloc.setArduinoDropDownValue(value);
            },
          );
        },
      ),
    );
  }

  Widget _buildPinDropDownWidget() {
    return StreamBuilder<String>(
      initialData: "",
      stream: _addAppliancePageBloc.getArduinoDropDownValue,
      builder: (BuildContext context,
          AsyncSnapshot<String> arduinoDropDownValueSnapshot) {
        return DropdownButtonHideUnderline(
          child: StreamBuilder<int>(
            initialData: -1,
            stream: _addAppliancePageBloc.getPinDropDownValue,
            builder: (BuildContext context,
                AsyncSnapshot<int> dropDownValueSnapshot) {
              int index = _pinDropDownItemsList
                  .indexWhere((DropdownMenuItem<int> item) {
                return item.value == dropDownValueSnapshot.data;
              });

              if (index == -1) {
                _selectedDevicePIN = -1;
              }

              return DropdownButton<int>(
                hint: Text(
                  "-- PIN --",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                value: index != -1 ? dropDownValueSnapshot.data : -1,
                isDense: true,
                items: _pinDropDownItemsList,
                onChanged: (int value) {
                  // print("Pin value :- $value");
                  _selectedDevicePIN = value;

                  _addAppliancePageBloc.setPinDropDownValue(value);
                },
              );
            },
          ),
        );
      },
    );
  }

  OutlineInputBorder _buildTextFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        width: 1.0,
        color: Colors.black,
        style: BorderStyle.solid,
      ),
    );
  }

  Widget _buildApplianceNameTextFieldWidget() {
    return TextField(
      controller: _applianceNameTextController,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      keyboardType: TextInputType.text,
      cursorWidth: 0.8,
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: 17.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        disabledBorder: _buildTextFieldOutlineInputBorder(),
        focusedBorder: _buildTextFieldOutlineInputBorder(),
        errorBorder: _buildTextFieldOutlineInputBorder(),
        focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
        border: _buildTextFieldOutlineInputBorder(),
        enabledBorder: _buildTextFieldOutlineInputBorder(),
        contentPadding: EdgeInsets.only(
          left: 14.0,
          right: 14.0,
          top: 16.0,
          bottom: 16.0,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "Appliance name",
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.grey,
        ),
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        FocusScope.of(context).detach();
      },
    );
  }

  Widget _buildCustomAppBarWidget(double height, double width) {
    return PreferredSize(
      preferredSize: Size(width, height * 0.22),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 25.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Hero(
          //     transitionOnUserGestures: true,
          //     tag: "$_addButtonTag",
          //     child: Padding(
          //       padding: EdgeInsets.only(right: 7.0),
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.add_circle,
          //           color: Colors.black,
          //           size: 25.0,
          //         ),
          //         onPressed: () {},
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 60.0, left: 25.0),
              child: Text(
                "Add Appliance",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplianceTypeWidget() {
    return StreamBuilder<ApplianceType>(
      initialData: ApplianceType.NONE,
      stream: _addAppliancePageBloc.getApplianceType,
      builder: (BuildContext context,
          AsyncSnapshot<ApplianceType> applianceTypeSnapshot) {
        switch (applianceTypeSnapshot.data) {
          case ApplianceType.READING:
            _applianceType = "READING";
            break;

          case ApplianceType.STATUS:
            _applianceType = "STATUS";
            break;

          default:
            _applianceType = "";
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  color: applianceTypeSnapshot.data == ApplianceType.NONE ||
                          applianceTypeSnapshot.data == ApplianceType.READING
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: Center(
                  child: Text(
                    "Status",
                    style: TextStyle(
                      color: applianceTypeSnapshot.data == ApplianceType.NONE ||
                              applianceTypeSnapshot.data ==
                                  ApplianceType.READING
                          ? Colors.black
                          : Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () {
                _addAppliancePageBloc.setApplianceType(ApplianceType.STATUS);
              },
            ),
            GestureDetector(
              child: Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  color: applianceTypeSnapshot.data == ApplianceType.NONE ||
                          applianceTypeSnapshot.data == ApplianceType.STATUS
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: Center(
                  child: Text(
                    "Reading",
                    style: TextStyle(
                      color: applianceTypeSnapshot.data == ApplianceType.NONE ||
                              applianceTypeSnapshot.data == ApplianceType.STATUS
                          ? Colors.black
                          : Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              onTap: () {
                _addAppliancePageBloc.setApplianceType(ApplianceType.READING);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddApplianceButtonWidget() {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      icon: Hero(
        transitionOnUserGestures: true,
        tag: "$_addButtonTag",
        child: Icon(
          Icons.add_circle,
          color: Colors.black,
        ),
      ),
      label: Text(
        "Add appliance",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
      ),
      highlightColor: Colors.white54,
      highlightedBorderColor: Colors.lightBlue,
      splashColor: Colors.lightBlue,
      padding: EdgeInsets.all(12.0),
      onPressed: _addAppliance,
    );
  }

  Future _addAppliance() async {
    if (_selectedDeviceId == null) {
      _showSnackBar("Device must be selected!");
    } else if (_selectedDevicePIN == -1) {
      _showSnackBar("PIN must be selected!");
    } else if (_applianceNameTextController.text.isEmpty) {
      _showSnackBar("Appliance name must not be empty!");
    } else if (_applianceType.isEmpty) {
      _showSnackBar("Appliance type must be selected!");
    } else {
      await NetworkCalls.addAppliance(
        roomId: widget.roomId,
        applianceName: _applianceNameTextController.text,
        arduinoId: _selectedDeviceId,
        pin: _selectedDevicePIN,
        userId: _prefs.getString("userId"),
        applianceType: _applianceType,
      );

      widget.reloadRoom();
      Navigator.pop(context);

      // if (response.containsKey("error")) {
      //   _showSnackBar("Error adding appliance!", color: Colors.orange);
      // } else if (response.containsKey("room")) {
      //   Navigator.pop(context);
      // }
    }
  }

  void _showSnackBar(String content, {Color color}) {
    _sfKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: color != null ? color : CustomColors.darkGrey,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.error,
              size: 24.0,
              color: Colors.white,
            ),
            SizedBox(
              width: 7.0,
            ),
            Text(
              "$content",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(Colors.white);

    return Scaffold(
      key: _sfKey,
      appBar: _buildCustomAppBarWidget(width, height),
      backgroundColor: Colors.white,
      body: StreamBuilder<bool>(
        initialData: true,
        stream: _addAppliancePageBloc.getLoadingStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
          return !loadingSnapshot.data
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 35.0,
                    ),
                    Center(
                      child: _buildDeviceDropDownWidget(),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0),
                      child: _buildApplianceNameTextFieldWidget(),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: _buildPinDropDownWidget(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Divider(),
                    ),
                    Center(
                      child: Chip(
                        backgroundColor: Colors.black45,
                        label: Text(
                          "Appliance Type",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    _buildApplianceTypeWidget(),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: _buildAddApplianceButtonWidget(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 2.0,
                    backgroundColor: Colors.transparent,
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);
    super.dispose();
  }
}

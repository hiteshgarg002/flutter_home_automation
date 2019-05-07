import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_home_automation/blocs/profile_dialog_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDialog extends StatefulWidget {
  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  double height, width;
  ProfileDialogBloc _profileDialogBloc;
  TextEditingController _nameController;
  SharedPreferences _prefs;
  String _nameInitials, _photoUrl, _email, _name;
  File _image;
  int _numRooms = 0, _numAppliances = 0;

  @override
  void initState() {
    super.initState();

    _profileDialogBloc = BlocProvider.of<ProfileDialogBloc>(context);

    _setup();
    _nameController = TextEditingController();
  }

  Future _setup() async {
    _prefs = await SharedPreferences.getInstance();
    Map res = await _getRoomsAppliancesCount();

    if (!(res.containsKey("error"))) {
      _numRooms = res["numRooms"];
      _numAppliances = res["numAppliances"];
    }

    if (_prefs.getString("name").contains(" ")) {
      _nameInitials =
          "${_prefs.getString("name").substring(0, 1)}${_prefs.getString("name").split(" ")[1].substring(0, 1)}";
    } else {
      _nameInitials = "${_prefs.getString("name").substring(0, 1)}";
    }
    _photoUrl = "${_prefs.getString("photoUrl")}";
    _email =
        "${_prefs.getString("email").substring(0, _prefs.getString("email").indexOf("@"))}";
    _name = "${_prefs.getString("name")}";

    Future.delayed(Duration(seconds: 1), () {
      _profileDialogBloc.setSharedPreferencesLoadingStatus(false);
      _profileDialogBloc.setInitialLoadingStatus(false);
    });
  }

  Future<Map> _getRoomsAppliancesCount() async {
    return await NetworkCalls.getRoomsAppliancesCount(
        _prefs.getString("userId"));
  }

  Future _showImageSourceModal() async {
    await showRoundedModalBottomSheet(
      autoResize: false,
      color: CustomColors.grey,
      radius: ((4.064 * height) / 100),
      dismissOnTap: false,
      context: context,
      builder: (BuildContext context) {
        return _buildImageSourceModalContentWidget();
      },
    );
  }

  Future _getImageFromCamera() async {
    if (_image != null) {
      _image = null;
    }

    _image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (_image != null) {
      _profileDialogBloc.setPhotoUploadingStatus(true);
      Map res = await NetworkCalls.updatePhoto(
        _prefs.getString("userId"),
        _image,
      );

      await _prefs.setString("photoUrl", res["photoUrl"]);
      _photoUrl = "${_prefs.getString("photoUrl")}";

      _profileDialogBloc.setPhotoUploadingStatus(false);
    }
  }

  Future _getImageFromGallery() async {
    if (_image != null) {
      _image = null;
    }

    _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      _profileDialogBloc.setPhotoUploadingStatus(true);
      Map res = await NetworkCalls.updatePhoto(
        _prefs.getString("userId"),
        _image,
      );

      await _prefs.setString("photoUrl", res["photoUrl"]);
      _photoUrl = "${_prefs.getString("photoUrl")}";

      _profileDialogBloc.setPhotoUploadingStatus(false);
    }
  }

  Future _deletePhoto() async {
    _profileDialogBloc.setPhotoUploadingStatus(true);
    await NetworkCalls.deletePhoto(_prefs.getString("userId"),
        _prefs.getString("photoUrl").replaceAll("/", ":"));

    await _prefs.setString("photoUrl", "");
    _photoUrl = "";

    _profileDialogBloc.setPhotoUploadingStatus(false);
  }

  Widget _buildImageSourceModalContentWidget() {
    return Container(
      height: _photoUrl.isEmpty
          ? ((20.320 * height) / 100)
          : ((27.093 * height) / 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _photoUrl.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                  ),
                  iconSize: 30,
                  color: Colors.orange,
                  onPressed: () {
                    _deletePhoto();
                    Navigator.pop(context);
                  },
                )
              : Container(),
          _photoUrl.isNotEmpty
              ? SizedBox(
                  height: ((1.0 * height) / 100),
                )
              : Container(),
          GestureDetector(
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(
                "CAMERA",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ((2.032 * height) / 100),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              _getImageFromCamera();
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: ((1.064 * height) / 100),
          ),
          GestureDetector(
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(
                "GALLERY",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ((2.032 * height) / 100),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              _getImageFromGallery();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureWidget() {
    return Container(
      height: ((11.650 * height) / 100),
      width: ((11.650 * height) / 100),
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _profileDialogBloc.getPhotoUploadingStatus,
        builder:
            (BuildContext context, AsyncSnapshot<bool> photoUploadingSnapshot) {
          return !photoUploadingSnapshot.data
              ? Stack(
                  children: <Widget>[
                    GestureDetector(
                      child: CircleAvatar(
                        radius: ((5.689 * height) / 100),
                        backgroundColor: Colors.black,
                        child: Center(
                          child: _photoUrl.isNotEmpty
                              ? CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: ((5.418 * height) / 100),
                                  backgroundImage: CachedNetworkImageProvider(
                                    "${DioAPI.baseURL}/$_photoUrl",
                                    cacheManager: DefaultCacheManager(),
                                  ),
                                )
                              : Text(
                                  "$_nameInitials",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ((3.167 * height) / 100),
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      onTap: _showImageSourceModal,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(((0.406 * height) / 100)),
                        child: Container(
                          height: ((3.386 * height) / 100),
                          width: ((3.386 * height) / 100),
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: ((2.709 * height) / 100),
                              color: Colors.black,
                            ),
                            mini: true,
                            onPressed: _showImageSourceModal,
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildRoomsAppliancesWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: ((4.064 * height) / 100),
              backgroundColor: Colors.amber,
              child: Center(
                child: Text(
                  "$_numRooms",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ((1.896 * height) / 100),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ((0.677 * height) / 100),
            ),
            Text("Rooms"),
          ],
        ),
        // SizedBox(width: ((1.354* height) / 100),),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: ((4.064 * height) / 100),
              backgroundColor: Colors.amber,
              child: Center(
                child: Text(
                  "$_numAppliances",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ((1.896 * height) / 100),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ((0.677 * height) / 100),
            ),
            Text("Appliances"),
          ],
        ),
      ],
    );
  }

  OutlineInputBorder _buildTextFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(((3.386 * height) / 100)),
      borderSide: BorderSide(
        width: ((0.094 * height) / 100),
        color: Colors.black,
        style: BorderStyle.solid,
      ),
    );
  }

  Widget _buildEditNameTextFieldWidget() {
    return TextField(
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.words,
      controller: _nameController,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      keyboardType: TextInputType.text,
      cursorWidth: ((0.203 * height) / 100),
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: ((2.09 * height) / 100),
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
          left: ((1.354 * height) / 100),
          right: ((1.354 * height) / 100),
          top: ((1.093 * height) / 100),
          bottom: ((1.093 * height) / 100),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "New name",
        hintStyle: TextStyle(
          fontSize: ((1.828 * height) / 100),
          color: Colors.grey,
        ),
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        FocusScope.of(context).detach();
      },
    );
  }

  Future _onPressDoneButton() async {
    if (_nameController.text.isNotEmpty) {
      _profileDialogBloc.setNameUpdateLoadingStatus(true);

      Map res = await NetworkCalls.updateName(
          _prefs.getString("userId"), _nameController.text);
      if (res.containsKey("name")) {
        _prefs.setString("name", res["name"]);
        _name = res["name"];
      }

      _nameController.clear();

      _profileDialogBloc.setNameEditModeStatus(false);
      _profileDialogBloc.setNameUpdateLoadingStatus(false);
    }
  }

  Widget _buildNameWidget() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _profileDialogBloc.getNameUpdateLoadingStatus,
      builder: (BuildContext context, AsyncSnapshot nameUpdateLoadingSnapshot) {
        return !nameUpdateLoadingSnapshot.data
            ? StreamBuilder<bool>(
                initialData: false,
                stream: _profileDialogBloc.getNameEditModeStatus,
                builder: (BuildContext context,
                    AsyncSnapshot<bool> nameEditModeSnapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      !nameEditModeSnapshot.data
                          ? IconButton(
                              splashColor: Colors.white,
                              highlightColor: Colors.white,
                              icon: Icon(Icons.edit),
                              color: Colors.white,
                              iconSize: ((2.709 * height) / 100),
                              onPressed: () {},
                            )
                          : IconButton(
                              icon: Icon(Icons.cancel),
                              color: Colors.black,
                              iconSize: ((2.709 * height) / 100),
                              onPressed: () {
                                _profileDialogBloc.setNameEditModeStatus(false);
                                if (_nameController.text.isNotEmpty) {
                                  _nameController.clear();
                                }
                              },
                            ),
                      !nameEditModeSnapshot.data
                          ? Chip(
                              backgroundColor: Colors.black,
                              label: Text(
                                "$_name",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                  fontSize: ((1.896 * height) / 100),
                                ),
                              ),
                            )
                          : Container(
                              width: 150.0,
                              child: _buildEditNameTextFieldWidget(),
                            ),
                      !nameEditModeSnapshot.data
                          ? IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.black,
                              iconSize: ((2.709 * height) / 100),
                              onPressed: () {
                                _profileDialogBloc.setNameEditModeStatus(true);
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.done),
                              color: Colors.black,
                              iconSize: ((2.709 * height) / 100),
                              onPressed: _onPressDoneButton,
                            ),
                    ],
                  );
                },
              )
            : Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 8.0),
                height: ((3.8 * height) / 100),
                width: ((3.8 * height) / 100),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 2.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              );
      },
    );
  }

  Widget _buildDialogContentWidget() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _profileDialogBloc.getLoadingStatusCheck,
      builder: (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
        return loadingSnapshot.data
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: _buildProfilePictureWidget(),
                  ),
                  SizedBox(
                    height: ((1.354 * height) / 100),
                  ),
                  Text(
                    "$_email",
                    style: TextStyle(
                      fontSize: ((1.896 * height) / 100),
                      color: Colors.black,
                    ),
                  ),
                  _buildNameWidget(),
                  SizedBox(
                    height: ((5.418 * height) / 100),
                  ),
                  _buildRoomsAppliancesWidget(),
                ],
              )
            : Center(
                child: Container(
                  height: ((3.386 * height) / 100),
                  width: ((3.386 * height) / 100),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2.0,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      backgroundColor: Colors.transparent,
      elevation: ((2.709 * height) / 100),
      child: SizedBox(
        height: height * 0.48,
        width: width * 0.76,
        child: Card(
          elevation: ((4.064 * height) / 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: _buildDialogContentWidget(),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';

class AddRoomPage extends StatefulWidget {
  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
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

  Widget _buildPinTextFieldWidget() {
    return TextField(
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      keyboardType: TextInputType.phone,
      cursorWidth: 0.8,
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        // prefixIcon: Icon(
        //   Icons.phone,
        //   color: Colors.lightBlue,
        //   size: 22.0,
        // ),
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
        hintText: "PIN",
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.grey,
        ),
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: () {},
    );
  }

  Widget _buildRoomNameTextFieldWidget() {
    return TextField(
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
        // prefixIcon: Icon(
        //   Icons.email,
        //   color: Colors.lightBlue,
        //   size: 22.0,
        // ),
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
        hintText: "Room name",
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.grey,
        ),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: CustomColors.grey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: height * 0.10,
              decoration: BoxDecoration(
                color: CustomColors.darkGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    45.0,
                  ),
                  bottomRight: Radius.circular(
                    45.0,
                  ),
                ),
              ),
              alignment: AlignmentDirectional.topStart,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Add Room",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Card(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  ImageIcon(
                    AssetImage("assets/room.png"),
                    size: 28,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Room name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: _buildRoomNameTextFieldWidget(),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
              Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  ImageIcon(
                    AssetImage("assets/pin.png"),
                    size: 26,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    "PIN",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(width: 55.0,
                child: _buildPinTextFieldWidget()),
            ),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

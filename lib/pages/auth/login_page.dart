import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/auth_page_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:flutter_home_automation/widgets/login_signup_bottom_custom_painer_widget.dart';
import 'package:flutter_home_automation/widgets/login_top_custom_painer_widget.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:navigate/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String email, password;

  LoginPage({
    this.email,
    this.password,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _emailPhoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final String BULB_ANIM_HERO_TAG = "BULBANIMHEROTAG";

  ScrollController _scrollController;
  AuthPageBloc _authPageBloc;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<ScaffoldState> _sfKey;
  SharedPreferences _prefs;
  double height, width;

  @override
  void initState() {
    super.initState();

    _sfKey = GlobalKey<ScaffoldState>();
    _authPageBloc = BlocProvider.of<AuthPageBloc>(context);
    _scrollController = ScrollController();

    _emailController = TextEditingController(
      text: widget.email != null ? widget.email : "",
    );
    _passwordController = TextEditingController(
      text: widget.password != null ? widget.password : "",
    );
  }

  OutlineInputBorder _buildTextFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(((3.386 * height) / 100)),
      borderSide: BorderSide(
        width: 1.0,
        color: Colors.transparent,
        style: BorderStyle.solid,
      ),
    );
  }

  Future _login(AsyncSnapshot<bool> loginClickedStatusSnapshot) async {
    _authPageBloc.setLoginButtonStatus(!loginClickedStatusSnapshot.data);

    Map<String, String> userData = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    Map response = await NetworkCalls.login(userData);

    // print("Rsponse :- $response");

    if (response.containsKey("error")) {
      _authPageBloc.setLoginButtonStatus(false);

      _sfKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "${response["error"]}",
            style: TextStyle(
              color: Colors.white,
              fontSize: ((2.032 * height) / 100),
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      await _saveUserInfo(response["user"]);

      Navigate.navigate(
        context,
        "/homePage",
        transactionType: TransactionType.fromRight,
        replaceRoute: ReplaceRoute.all,
      );
    }
  }

  Future _saveUserInfo(Map response) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("email", response["email"]);
    await _prefs.setString("password", response["password"]);
    await _prefs.setInt("phone", response["phone"]);
    await _prefs.setString("name", response["name"]);
    await _prefs.setString("photoUrl", response["photoUrl"]);
    await _prefs.setString("userId", response["_id"]);
    await _prefs.setString("homeId", response["homeId"]);
  }

  Widget _buildLoginWidget() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _authPageBloc.getLoginButtonClickedStatus,
      builder: (BuildContext context,
          AsyncSnapshot<bool> loginClickedStatusSnapshot) {
        return loginClickedStatusSnapshot.data
            ? Loading(
                size: 23.0,
                indicator: BallSpinFadeLoaderIndicator(),
              )
            : GestureDetector(
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: ((2.032 * height) / 100),
                  ),
                ),
                onTap: () {
                  _login(loginClickedStatusSnapshot);
                },
              );
      },
    );
  }

  Widget _buildEmailOrPhoneTextFieldWidget() {
    return TextField(
      controller: _emailController,
      focusNode: _emailPhoneFocusNode,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      keyboardType: TextInputType.text,
      cursorWidth: ((0.067 * height) / 100),
      cursorColor: Colors.white,
      style: TextStyle(
        fontSize: ((2.032 * height) / 100),
        color: Colors.white,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.lightBlue,
          size: ((2.980 * height) / 100),
        ),
        disabledBorder: _buildTextFieldOutlineInputBorder(),
        focusedBorder: _buildTextFieldOutlineInputBorder(),
        errorBorder: _buildTextFieldOutlineInputBorder(),
        focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
        border: _buildTextFieldOutlineInputBorder(),
        enabledBorder: _buildTextFieldOutlineInputBorder(),
        contentPadding: EdgeInsets.only(
          left: ((1.896 * height) / 100),
          right: ((1.896 * height) / 100),
          top: ((2.167 * height) / 100),
          bottom: ((2.167 * height) / 100),
        ),
        filled: true,
        fillColor: CustomColors.grey,
        hintText: "Email or Phone",
        hintStyle: TextStyle(
          fontSize: ((2.032 * height) / 100),
          color: Colors.grey,
        ),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
    );
  }

  Widget _buildPasswordTextFieldWidget() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _authPageBloc.getViewPwdStatus,
      builder:
          (BuildContext context, AsyncSnapshot<bool> viewPwdStatusnapshot) {
        return TextField(
          controller: _passwordController,
          obscureText: !viewPwdStatusnapshot.data,
          focusNode: _passwordFocusNode,
          scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          keyboardType: TextInputType.text,
          cursorWidth: ((0.067 * height) / 100),
          cursorColor: Colors.white,
          style: TextStyle(
            fontSize: ((2.032 * height) / 100),
            color: Colors.white,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.security,
              color: Colors.lightBlue,
              size: ((2.980 * height) / 100),
            ),
            suffixIcon: GestureDetector(
              child: Icon(
                Icons.remove_red_eye,
                size: ((2.709 * height) / 100),
                color: viewPwdStatusnapshot.data
                    ? Colors.white
                    : CustomColors.darkestGrey,
              ),
              onTap: () {
                _authPageBloc.setViewPwdStatus(!viewPwdStatusnapshot.data);
              },
            ),
            disabledBorder: _buildTextFieldOutlineInputBorder(),
            focusedBorder: _buildTextFieldOutlineInputBorder(),
            errorBorder: _buildTextFieldOutlineInputBorder(),
            focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
            border: _buildTextFieldOutlineInputBorder(),
            enabledBorder: _buildTextFieldOutlineInputBorder(),
            contentPadding: EdgeInsets.only(
              left: ((1.896 * height) / 100),
              right: ((1.896 * height) / 100),
              top: ((2.167 * height) / 100),
              bottom: ((2.167 * height) / 100),
            ),
            filled: true,
            fillColor: CustomColors.grey,
            hintText: "Password",
            hintStyle: TextStyle(
              fontSize: ((2.032 * height) / 100),
              color: Colors.grey,
            ),
          ),
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            FocusScope.of(context).detach();
          },
        );
      },
    );
  }

  Widget _buildForgotPwdWidget() {
    return Container(
      width: width,
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: EdgeInsets.only(right: 30),
        child: GestureDetector(
          child: Text(
            "Forgot password!",
            style: TextStyle(
              color: Colors.white30,
              fontSize: ((1.896 * height) / 100),
              fontWeight: FontWeight.normal,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildTopWidget() {
    return Container(
      height: height * 0.43,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: CustomPaint(
              painter: LoginSignupTopCustomPainter(),
              child: Container(
                width: width,
                height: height * 0.20,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Hero(
              tag: "$BULB_ANIM_HERO_TAG",
              transitionOnUserGestures: true,
              child: Image(
                image: AssetImage("assets/bulb_gif.gif"),
                height: height * 0.25,
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.topRight,
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       top: height * 0.02,
          //       right: width * 0.04,
          //     ),
          //     child: FloatingActionButton(
          //       backgroundColor: Colors.lightBlue,
          //       mini: true,
          //       child: Icon(
          //         Icons.add,
          //         color: Colors.white,
          //         size: ((2.980 * height) / 100),
          //       ),
          //       elevation: ((1.354 * height) / 100),
          //       onPressed: () {
          //         Navigate.navigate(
          //           context,
          //           "/signupPage",
          //           transactionType: TransactionType.fadeIn,
          //         );
          //       },
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: height * 0.03,
                left: width * 0.05,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ((2.032 * height) / 100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddleWidget() {
    return Container(
      height: height * 0.37,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: ((2.709 * height) / 100),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ((4.064 * height) / 100)),
            child: _buildEmailOrPhoneTextFieldWidget(),
          ),
          SizedBox(
            height: ((1.354 * height) / 100),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ((4.064 * height) / 100)),
            child: _buildPasswordTextFieldWidget(),
          ),
          SizedBox(
            height: ((2.709 * height) / 100),
          ),
          _buildForgotPwdWidget(),
        ],
      ),
    );
  }

  Widget _buildBottomWidget() {
    return CustomPaint(
      painter: LoginSignupBottomCustomPainter(),
      child: Container(
        width: width,
        height: height * 0.20,
        alignment: AlignmentDirectional.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: height * 0.04,
            // right: width * 0.10,
          ),
          child: _buildLoginWidget(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);

    return Scaffold(
      key: _sfKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.darkGrey,
      body: SingleChildScrollView(
        // physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildTopWidget(),
            _buildMiddleWidget(),
            _buildBottomWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

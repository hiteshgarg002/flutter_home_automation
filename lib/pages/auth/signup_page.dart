// import 'dart:io';
// import 'package:flutter_home_automation/blocs/auth_page_bloc.dart';
// import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
// import 'package:flutter_home_automation/networks/network_calls.dart';
// import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
// import 'package:loading/loading.dart';
// import 'package:navigate/navigate.dart';
// import 'package:rounded_modal/rounded_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_home_automation/utils/custom_colors.dart';
// import 'package:flutter_home_automation/widgets/login_signup_bottom_custom_painer_widget.dart';
// import 'package:flutter_home_automation/widgets/login_top_custom_painer_widget.dart';
// import 'package:image_picker/image_picker.dart';

// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final String BULB_ANIM_HERO_TAG = "BULBANIMHEROTAG";
//   File _image;
//   AuthPageBloc _authPageBloc;
//   final FocusNode _emailFocusNode = FocusNode();
//   final FocusNode _passwordFocusNode = FocusNode();
//   final FocusNode _phoneFocusNode = FocusNode();
//   final FocusNode _nameFocusNode = FocusNode();
//   GlobalKey<ScaffoldState> _sfKey;
//   TextEditingController _nameController;
//   TextEditingController _phoneController;
//   TextEditingController _emailController;
//   TextEditingController _passwordController;

//   @override
//   void initState() {
//     super.initState();

//     _sfKey = GlobalKey<ScaffoldState>();
//     _authPageBloc = BlocProvider.of<AuthPageBloc>(context);

//     _nameController = TextEditingController();
//     _phoneController = TextEditingController();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//   }

//   Future _getImageFromCamera() async {
//     if (_image != null) {
//       _image = null;
//     }

//     _image = await ImagePicker.pickImage(source: ImageSource.camera);

//     if (_image != null) {
//       _authPageBloc.setSelectedPhoto(_image);
//     }
//   }

//   Future _getImageFromGallery() async {
//     if (_image != null) {
//       _image = null;
//     }

//     _image = await ImagePicker.pickImage(source: ImageSource.gallery);

//     if (_image != null) {
//       _authPageBloc.setSelectedPhoto(_image);
//     }
//   }

//   Widget _buildImageSourceModalContentWidget() {
//     return Container(
//       height: ((20.320 * height) / 100),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           GestureDetector(
//             child: Text(
//               "CAMERA",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: ((2.032 * height) / 100),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             onTap: () {
//               _getImageFromCamera();
//               Navigator.pop(context);
//             },
//           ),
//           SizedBox(
//             height: ((4.064 * height) / 100),
//           ),
//           GestureDetector(
//             child: Text(
//               "GALLERY",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: ((2.032 * height) / 100),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             onTap: () {
//               _getImageFromGallery();
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future _showImageSourceModal() async {
//     await showRoundedModalBottomSheet(
//       autoResize: false,
//       color: CustomColors.grey,
//       radius: ((4.064 * height) / 100),
//       dismissOnTap: false,
//       context: context,
//       builder: (BuildContext context) {
//         return _buildImageSourceModalContentWidget();
//       },
//     );
//   }

//   OutlineInputBorder _buildTextFieldOutlineInputBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(((3.386 * height) / 100)),
//       borderSide: BorderSide(
//         width: 1.0,
//         color: Colors.transparent,
//         style: BorderStyle.solid,
//       ),
//     );
//   }

//   Widget _buildNameTextFieldWidget() {
//     return TextField(
//       controller: _nameController,
//       focusNode: _nameFocusNode,
//       scrollPadding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       keyboardType: TextInputType.text,
//       cursorWidth: ((0.067 * height) / 100),
//       cursorColor: Colors.white,
//       style: TextStyle(
//         fontSize: ((2.032 * height) / 100),
//         color: Colors.white,
//       ),
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           Icons.email,
//           color: Colors.lightBlue,
//           size: ((2.980 * height) / 100),
//         ),
//         disabledBorder: _buildTextFieldOutlineInputBorder(),
//         focusedBorder: _buildTextFieldOutlineInputBorder(),
//         errorBorder: _buildTextFieldOutlineInputBorder(),
//         focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
//         border: _buildTextFieldOutlineInputBorder(),
//         enabledBorder: _buildTextFieldOutlineInputBorder(),
//         contentPadding: EdgeInsets.only(
//           left: ((1.896 * height) / 100),
//           right: ((1.896 * height) / 100),
//           top: ((2.167 * height) / 100),
//           bottom: ((2.167 * height) / 100),
//         ),
//         filled: true,
//         fillColor: CustomColors.grey,
//         hintText: "Name",
//         hintStyle: TextStyle(
//           fontSize: ((2.032 * height) / 100),
//           color: Colors.grey,
//         ),
//       ),
//       textInputAction: TextInputAction.next,
//       onEditingComplete: () {
//         FocusScope.of(context).requestFocus(_emailFocusNode);
//       },
//     );
//   }

//   Widget _buildEmailTextFieldWidget() {
//     return TextField(
//       controller: _emailController,
//       focusNode: _emailFocusNode,
//       scrollPadding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       keyboardType: TextInputType.emailAddress,
//       cursorWidth: ((0.067 * height) / 100),
//       cursorColor: Colors.white,
//       style: TextStyle(
//         fontSize: ((2.032 * height) / 100),
//         color: Colors.white,
//       ),
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           Icons.email,
//           color: Colors.lightBlue,
//           size: ((2.980 * height) / 100),
//         ),
//         disabledBorder: _buildTextFieldOutlineInputBorder(),
//         focusedBorder: _buildTextFieldOutlineInputBorder(),
//         errorBorder: _buildTextFieldOutlineInputBorder(),
//         focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
//         border: _buildTextFieldOutlineInputBorder(),
//         enabledBorder: _buildTextFieldOutlineInputBorder(),
//         contentPadding: EdgeInsets.only(
//           left: ((1.896 * height) / 100),
//           right: ((1.896 * height) / 100),
//           top: ((2.167 * height) / 100),
//           bottom: ((2.167 * height) / 100),
//         ),
//         filled: true,
//         fillColor: CustomColors.grey,
//         hintText: "Email",
//         hintStyle: TextStyle(
//           fontSize: ((2.032 * height) / 100),
//           color: Colors.grey,
//         ),
//       ),
//       textInputAction: TextInputAction.next,
//       onEditingComplete: () {
//         FocusScope.of(context).requestFocus(_phoneFocusNode);
//       },
//     );
//   }

//   Widget _buildPhoneTextFieldWidget() {
//     return TextField(
//       controller: _phoneController,
//       focusNode: _phoneFocusNode,
//       scrollPadding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       keyboardType: TextInputType.phone,
//       cursorWidth: ((0.067 * height) / 100),
//       cursorColor: Colors.white,
//       style: TextStyle(
//         fontSize: ((2.032 * height) / 100),
//         color: Colors.white,
//       ),
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           Icons.phone,
//           color: Colors.lightBlue,
//           size: ((2.980 * height) / 100),
//         ),
//         disabledBorder: _buildTextFieldOutlineInputBorder(),
//         focusedBorder: _buildTextFieldOutlineInputBorder(),
//         errorBorder: _buildTextFieldOutlineInputBorder(),
//         focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
//         border: _buildTextFieldOutlineInputBorder(),
//         enabledBorder: _buildTextFieldOutlineInputBorder(),
//         contentPadding: EdgeInsets.only(
//           left: ((1.896 * height) / 100),
//           right: ((1.896 * height) / 100),
//           top: ((2.167 * height) / 100),
//           bottom: ((2.167 * height) / 100),
//         ),
//         filled: true,
//         fillColor: CustomColors.grey,
//         hintText: "Phone",
//         hintStyle: TextStyle(
//           fontSize: ((2.032 * height) / 100),
//           color: Colors.grey,
//         ),
//       ),
//       textInputAction: TextInputAction.next,
//       onEditingComplete: () {
//         FocusScope.of(context).requestFocus(_passwordFocusNode);
//       },
//     );
//   }

//   Widget _buildPasswordTextFieldWidget() {
//     return StreamBuilder<bool>(
//       initialData: false,
//       stream: _authPageBloc.getViewPwdStatus,
//       builder:
//           (BuildContext context, AsyncSnapshot<bool> viewPwdStatusnapshot) {
//         return TextField(
//           controller: _passwordController,
//           obscureText: !viewPwdStatusnapshot.data,
//           focusNode: _passwordFocusNode,
//           scrollPadding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           keyboardType: TextInputType.text,
//           cursorWidth: ((0.067 * height) / 100),
//           cursorColor: Colors.white,
//           style: TextStyle(
//             fontSize: ((2.032 * height) / 100),
//             color: Colors.white,
//           ),
//           decoration: InputDecoration(
//             prefixIcon: Icon(
//               Icons.security,
//               color: Colors.lightBlue,
//               size: ((2.980 * height) / 100),
//             ),
//             suffixIcon: GestureDetector(
//               child: Icon(
//                 Icons.remove_red_eye,
//                 size: ((2.709 * height) / 100),
//                 color: viewPwdStatusnapshot.data
//                     ? Colors.white
//                     : CustomColors.darkestGrey,
//               ),
//               onTap: () {
//                 _authPageBloc.setViewPwdStatus(!viewPwdStatusnapshot.data);
//               },
//             ),
//             disabledBorder: _buildTextFieldOutlineInputBorder(),
//             focusedBorder: _buildTextFieldOutlineInputBorder(),
//             errorBorder: _buildTextFieldOutlineInputBorder(),
//             focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
//             border: _buildTextFieldOutlineInputBorder(),
//             enabledBorder: _buildTextFieldOutlineInputBorder(),
//             contentPadding: EdgeInsets.only(
//               left: ((1.896 * height) / 100),
//               right: ((1.896 * height) / 100),
//               top: ((2.167 * height) / 100),
//               bottom: ((2.167 * height) / 100),
//             ),
//             filled: true,
//             fillColor: CustomColors.grey,
//             hintText: "Password",
//             hintStyle: TextStyle(
//               fontSize: ((2.032 * height) / 100),
//               color: Colors.grey,
//             ),
//           ),
//           textInputAction: TextInputAction.done,
//           onEditingComplete: () {
//             FocusScope.of(context).detach();
//           },
//         );
//       },
//     );
//   }

//   Future _signup() async {
//     _authPageBloc.setSignupStatus(true);

//     Map<String, String> userData = {
//       "name": _nameController.text,
//       "email": _emailController.text,
//       "phone": _phoneController.text,
//       "password": _passwordController.text,
//     };

//     Map response = await NetworkCalls.signup(userData, _image);

//     if (response.containsKey("error")) {
//       _authPageBloc.setSignupStatus(false);

//       _sfKey.currentState.showSnackBar(
//         SnackBar(
//           content: Text(
//             "${response["error"]}",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: ((2.032 * height) / 100),
//             ),
//           ),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } else {
//       Navigate.navigate(
//         context,
//         "/loginPage",
//         transactionType: TransactionType.fadeIn,
//         replaceRoute: ReplaceRoute.all,
//         arg: <String, String>{
//           "email": response["user"]["email"],
//           "password": response["user"]["password"],
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     final double width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       key: _sfKey,
//       backgroundColor: CustomColors.darkGrey,
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             height: height * 0.24,
//             child: Stack(
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: CustomPaint(
//                     painter: LoginSignupTopCustomPainter(),
//                     child: Container(
//                       height: height * 0.20,
//                       width: width,
//                       child: Stack(
//                         children: <Widget>[
//                           Align(
//                             alignment: Alignment.topLeft,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: <Widget>[
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.arrow_back_ios,
//                                     color: Colors.white,
//                                     size: ((2.709 * height) / 100),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                                 Text(
//                                   "Signup",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: ((2.032 * height) / 100),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Align(
//                             alignment: Alignment.topRight,
//                             child: Hero(
//                               tag: "$BULB_ANIM_HERO_TAG",
//                               transitionOnUserGestures: true,
//                               child: Image(
//                                 image: AssetImage("assets/bulb_gif.gif"),
//                                 height: height * 0.085,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: StreamBuilder<File>(
//                     stream: _authPageBloc.getSelectedPhoto,
//                     builder: (BuildContext context,
//                         AsyncSnapshot<File> selectedPhotoSnapshot) {
//                       return selectedPhotoSnapshot.hasData
//                           ? GestureDetector(
//                               child: CircleAvatar(
//                                 radius: 36.0,
//                                 backgroundImage:
//                                     FileImage(selectedPhotoSnapshot.data),
//                                 // backgroundColor: Colors.white,
//                                 // child: Center(
//                                 //   child: Icon(
//                                 //     Icons.add_a_photo,
//                                 //     color: Colors.lightBlue,
//                                 //     size: ((3.386 * height) / 100),
//                                 //   ),
//                                 // ),
//                               ),
//                               onTap: _showImageSourceModal,
//                             )
//                           : GestureDetector(
//                               child: CircleAvatar(
//                                 radius: 36.0,
//                                 backgroundColor: Colors.white,
//                                 child: Center(
//                                   child: Icon(
//                                     Icons.add_a_photo,
//                                     color: Colors.lightBlue,
//                                     size: ((3.386 * height) / 100),
//                                   ),
//                                 ),
//                               ),
//                               onTap: _showImageSourceModal,
//                             );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.only(
//                 top: ((3.386 * height) / 100),
//                 right: ((4.064 * height) / 100),
//                 left: ((4.064 * height) / 100),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   _buildNameTextFieldWidget(),
//                   SizedBox(
//                     height: ((2.032 * height) / 100),
//                   ),
//                   _buildEmailTextFieldWidget(),
//                   SizedBox(
//                     height: ((2.032 * height) / 100),
//                   ),
//                   _buildPhoneTextFieldWidget(),
//                   SizedBox(
//                     height: ((2.032 * height) / 100),
//                   ),
//                   _buildPasswordTextFieldWidget(),
//                 ],
//               ),
//             ),
//           ),
//           CustomPaint(
//             painter: LoginSignupBottomCustomPainter(),
//             child: Container(
//               width: width,
//               height: height * 0.20,
//               alignment: AlignmentDirectional.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   bottom: height * 0.02,
//                   // right: width * 0.10,
//                 ),
//                 child: StreamBuilder<bool>(
//                   initialData: false,
//                   stream: _authPageBloc.getSignupStatus,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<bool> signupStatusSnapshot) {
//                     return !signupStatusSnapshot.data
//                         ? FloatingActionButton(
//                             mini: true,
//                             elevation: ((1.354 * height) / 100),
//                             backgroundColor: Colors.white,
//                             child: Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.black,
//                             ),
//                             onPressed: _signup,
//                           )
//                         : Loading(
//                             size: ((3.386 * height) / 100),
//                             indicator: BallSpinFadeLoaderIndicator(),
//                           );
//                   },
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

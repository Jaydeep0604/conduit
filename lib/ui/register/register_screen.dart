import 'dart:io';
import 'package:conduit/bloc/register_bloc/register_event.dart';
import 'package:conduit/bloc/register_bloc/register_state.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/utils/responsive.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:conduit/widget/stepper.dart';
import 'package:conduit/widget/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

import '../../bloc/register_bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key, required this.screenSize}) : super(key: key);
  var screenSize;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailCtr = TextEditingController();
  late TextEditingController passwordctr = TextEditingController();
  late TextEditingController userNameCtr = TextEditingController();
  late TextEditingController bioCtr = TextEditingController();
  late TextEditingController profilePhotoCtr = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  GlobalKey<FormState> _form2 = GlobalKey<FormState>();

  int _currentStep = 0;
  bool isLoading = false;
  bool _obsecureText = true;
  late RegisterBloc registerBloc;
  AuthModel? authModel;

  void _toggleObscured() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  void initState() {
    super.initState();
    registerBloc = context.read<RegisterBloc>();
    _form = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: AppColors.white2,
          extendBodyBehindAppBar:
              Responsive.isSmallScreen(context) ? true : false,
          appBar: Responsive.isSmallScreen(context)
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                    ),
                  ),
                )
              : AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.primaryColor,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                    ),
                  ),
                  title: Text("Conduit",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 25,
                        fontFamily: ConduitFontFamily.robotoBold,
                      )),
                ),
          body: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoadingState) {
                setState(() {
                  isLoading = true;
                });
                FocusManager.instance.primaryFocus!.unfocus();
                CToast.instance.showLoaderDialog(context);
                // CToast.instance.showLoading(context);
              } else {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is RegisterNoInternetState) {
                CToast.instance.dismiss(context);
                CToast.instance.showError(context, NO_INTERNET);
              }
              if (state is RegisterDoneState) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => LoginScreen()));
                CToast.instance.showSuccess(context, state.msg);
              }

              if (state is RegisterErrorState) {
                CToast.instance.dismiss(context);
                CToast.instance.showError(context, state.msg);
              }
            },
            child: ThemeContainer(
              screenSize: widget.screenSize,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.isSmallScreen(context)
                        ? widget.screenSize.width / 25
                        : widget.screenSize.width / 50,
                    right: Responsive.isSmallScreen(context)
                        ? widget.screenSize.width / 25
                        : widget.screenSize.width / 50,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Text(
                        "conduit",
                        style: TextStyle(
                          fontSize: 50,
                          color: AppColors.primaryColor,
                          fontFamily: ConduitFontFamily.robotoBold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("A place to share your knowledge.",
                          style: TextStyle(
                            fontSize: 17,
                            color: AppColors.black,
                            fontFamily: ConduitFontFamily.robotoRegular,
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      ConduitStepper(
                        onTap: (index) {
                          if (index == 0) {
                            setState(() {
                              _currentStep = index;
                            });
                          } else {
                            if (_form.currentState!.validate()) {
                              setState(() {
                                _currentStep = _currentStep + 1;
                              });
                            }
                          }
                        },
                        currentInde: _currentStep,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Sign up to Conduit',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: ConduitFontFamily.robotoRegular,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_currentStep == 0)
                        Form(
                          key: _form,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username*",
                                style: TextStyle(
                                    fontFamily: ConduitFontFamily.robotoLight),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    ConduitEditText(
                                      controller: userNameCtr,
                                      textInputType: TextInputType.text,
                                      hint: "Username",
                                      maxLines: 1,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(30),
                                        FilteringTextInputFormatter(
                                            RegExp(r'[a-zA-Z]'),
                                            allow: true),
                                        LengthLimitingTextInputFormatter(25)
                                      ],
                                      validator: (value) {
                                        if (value
                                                ?.trimLeft()
                                                .trimRight()
                                                .isEmpty ??
                                            true) {
                                          return "Enter username";
                                        }
                                        if (value != null && value.length < 3) {
                                          return "Username must be minimum 3 characters";
                                        }
                                        return null;
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Email*",
                                style: TextStyle(
                                    fontFamily: ConduitFontFamily.robotoLight),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    ConduitEditText(
                                      hint: "Email",
                                      maxLines: 1,
                                      controller: emailCtr,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(60),
                                        FilteringTextInputFormatter.deny(" "),
                                        FilteringTextInputFormatter.deny("[]"),
                                        FilteringTextInputFormatter.deny("["),
                                        FilteringTextInputFormatter.deny("]"),
                                        FilteringTextInputFormatter.deny("^"),
                                        FilteringTextInputFormatter.deny(""),
                                        FilteringTextInputFormatter.deny("`"),
                                        FilteringTextInputFormatter.deny("/"),
                                        // FilteringTextInputFormatter.deny("\"),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9a-zA-z._@]')),
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r"/"))
                                      ],
                                      validator: (value) {
                                        if (value?.trim().isEmpty ?? true) {
                                          return "Enter email address";
                                        } else if (!RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value ?? "")) {
                                          return "Enter valid email address";
                                        }
                                        return null;
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Boi (optional)",
                                style: TextStyle(
                                    fontFamily: ConduitFontFamily.robotoLight),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    ConduitEditText(
                                      controller: bioCtr,
                                      textInputType: TextInputType.text,
                                      minLines: 5,
                                      maxLines: 5,
                                      hint: "Bio",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoButton(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Text('Next',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          ?.copyWith(
                                              color: isLoading
                                                  ? Colors.white60
                                                  : Colors.white,
                                              fontWeight: FontWeight.w700)),
                                  onPressed: () {
                                    FocusNode? focusNode =
                                        FocusManager.instance.primaryFocus;
                                    if (focusNode != null) {
                                      if (focusNode.hasPrimaryFocus) {
                                        focusNode.unfocus();
                                      }
                                    }
                                    if (_form.currentState?.validate() ??
                                        false) {
                                      setState(() {
                                        _currentStep = _currentStep + 1;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_currentStep == 1)
                        Form(
                          key: _form2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Profile photo",
                              //   style: TextStyle(
                              //     fontFamily: ConduitFontFamily.robotoLight,
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // ConduitEditText(
                              //   controller: profilePhotoCtr,
                              //   maxLines: 1,
                              //   minLines: 1,
                              //   textInputType: TextInputType.url,
                              //   hint: "Profile photo url",
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              Text(
                                "Password*",
                                style: TextStyle(
                                  fontFamily: ConduitFontFamily.robotoLight,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    ConduitEditText(
                                      controller: passwordctr,
                                      hint: "Password",
                                      maxLines: 1,
                                      obsecureText: _obsecureText,
                                      textInputType:
                                          TextInputType.visiblePassword,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(' '),
                                        LengthLimitingTextInputFormatter(16)
                                      ],
                                      validator: (value) {
                                        if (value == "" ||
                                            (value?.trim().isEmpty ?? true)) {
                                          return "Enter password";
                                        }
                                        return null;
                                      },
                                      suffixIcon: InkWell(
                                        onTap: _toggleObscured,
                                        child: Transform.scale(
                                          scale: 0.9,
                                          child: Icon(
                                            _obsecureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: CupertinoButton(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Text('Sign Up',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          ?.copyWith(
                                              color: isLoading
                                                  ? Colors.white60
                                                  : Colors.white,
                                              fontWeight: FontWeight.w700)),
                                  onPressed: () {
                                    FocusNode? focusNode =
                                        FocusManager.instance.primaryFocus;
                                    if (focusNode != null) {
                                      if (focusNode.hasPrimaryFocus) {
                                        focusNode.unfocus();
                                      }
                                    }
                                    if (_form2.currentState?.validate() ??
                                        false) {
                                      AuthModel aModel =
                                          _createRegisterModel()!;
                                      if (_createRegisterModel != null) {
                                        registerBloc.add(
                                          RegisterSubmitEvent(
                                            authModel: aModel,
                                          ),
                                        );
                                        // CToast.instance.showSuccess(context,
                                        //     "Data added in ( RegisterSubmitEvent                                                                                                                                            )");
                                      } else {
                                        CToast.instance.showError(
                                            context, "Data not added");
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Responsive.isSmallScreen(context)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                          ConduitFontFamily.robotoRegular,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      Navigator.pop(context);
                                    }),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            ConduitFontFamily.robotoRegular,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: ConduitFontFamily.robotoRegular,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign In",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pop(context);
                                        },
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                        fontFamily:
                                            ConduitFontFamily.robotoRegular,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AuthModel? _createRegisterModel() {
    return AuthModel(
      username: userNameCtr.text.trimLeft().trimRight(),
      email: emailCtr.text.trim(),
      password: passwordctr.text.trim(),
      bio: bioCtr.text.trim(),
    );
  }
}

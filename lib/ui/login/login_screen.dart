import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/bloc/login_bloc/login_state.dart';
import 'package:conduit/bloc/register_bloc/register_bloc.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/ui/base/base_screen.dart';
import 'package:conduit/ui/register/register_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/utils/responsive.dart';
import 'package:conduit/utils/theme_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login_bloc/login_event.dart';
import '../../widget/conduitEditText_widget.dart';

class LoginScreen extends StatefulWidget {
  static const loginUrl = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isLoading2 = true;
  bool switchValue = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late LoginBloc loginBloc;
  late RegisterBloc registerBloc;
  late TextEditingController emailCtr = TextEditingController();
  late TextEditingController passwordCtr = TextEditingController();
  bool _obsecureText = true;
  @override
  void initState() {
    // emailCtr = TextEditingController();
    // passwordCtr = TextEditingController();
    registerBloc = context.read<RegisterBloc>();
    loginBloc = context.read<LoginBloc>();

    super.initState();
  }

  // @override
  // void loading() {
  //   CToast.instance.showLoading(context);
  // }

  void _toggleObscured() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: AppColors.black,
          appBar: Responsive.isSmallScreen(context)
              ? null
              : AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.primaryColor,
                  automaticallyImplyLeading: false,
                  title: Text(
                    "Conduit",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 25,
                      fontFamily: ConduitFontFamily.robotoBold,
                    ),
                  ),
                ),
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginNoInternetState) {
                CToast.instance.dismiss();
                CToast.instance.showError(context, NO_INTERNET);
              }
              if (state is LoginLoadingState) {
                CToast.instance.showLodingLoader(context);
                setState(() {
                  isLoading = true;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
              }
              if (state is LoginErrorState) {
                CToast.instance.dismiss();
                setState(() {
                  isLoading = false;
                });
                CToast.instance.showError(context, state.msg);
              }
              if (state is LoginSuccessState) {
                CToast.instance.dismiss();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BaseScreen(),
                    ),
                    (route) => false);
                CToast.instance.showSuccess(context, "login successfull");
              }
            },
            child: ThemeContainer(
              screenSize: screenSize,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Responsive.isSmallScreen(context)
                        ? screenSize.width / 25
                        : screenSize.width / 50,
                    right: Responsive.isSmallScreen(context)
                        ? screenSize.width / 25
                        : screenSize.width / 50,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Center(
                          child: Text(
                            "conduit",
                            style: TextStyle(
                              fontSize: 50,
                              color: AppColors.primaryColor,
                              fontFamily: ConduitFontFamily.robotoBold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text("A place to share your knowledge.",
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.black,
                                fontFamily: ConduitFontFamily.robotoRegular,
                              )),
                        ),
                        SizedBox(
                          height: 90,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Log in to Conduit',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              fontFamily: ConduitFontFamily.robotoBold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Email*",
                          style: TextStyle(
                              fontFamily: ConduitFontFamily.robotoBold,
                              color: AppColors.black_light),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              ConduitEditText(
                                hint: "Email",
                                controller: emailCtr,
                                maxLines: 1,
                                textInputType: TextInputType.emailAddress,
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
                                  FilteringTextInputFormatter.deny(RegExp(r"/"))
                                ],
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return "Enter email address";
                                  } 
                                  else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$",
                                  ).hasMatch(value ?? "")) {
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
                          "Password*",
                          style: TextStyle(
                              fontFamily: ConduitFontFamily.robotoBold,
                              color: AppColors.black_light),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Column(
                            children: [
                              ConduitEditText(
                                controller: passwordCtr,
                                hint: "Password",
                                obsecureText: _obsecureText,
                                maxLines: 1,
                                textInputType: TextInputType.visiblePassword,
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
                            color: isLoading
                                ? AppColors.text_color
                                : AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            child: Text(
                              'Sign in',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      color: isLoading
                                          ? Colors.white60
                                          : Colors.white,
                                      fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // FocusNode? focusNode =
                              //     FocusManager.instance.primaryFocus;
                              // if (focusNode != null) {
                              //   if (focusNode.hasPrimaryFocus) {
                              //     focusNode.unfocus();
                              //   }
                              // }
                              if (formKey.currentState?.validate() ?? false) {
                                setState(() {
                                  isLoading = true;
                                });
                                loginBloc.add(
                                  LoginSubmitEvent(
                                    authModel: AuthModel(
                                      password: passwordCtr.text.trim(),
                                      email: emailCtr.text.trim(),
                                    ),
                                  ),
                                );
                              }
                            },
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
                                      "Don't have an account? ",
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
                                        setState(() {
                                          emailCtr.clear();
                                          passwordCtr.clear();
                                        });
                                        formKey.currentState?.reset();
                                        Navigator.pushNamed(
                                            context, RegisterScreen.registerUrl,
                                            arguments: {
                                              "screenSize": screenSize,
                                            });
                                        // Navigator.push(
                                        //   context,
                                        //   CupertinoPageRoute(
                                        //     builder: (context) =>
                                        //         RegisterScreen(
                                        //       screenSize: screenSize,
                                        //     ),
                                        //   ),
                                        // );
                                      }),
                                      child: Text(
                                        "Sign up for Conduit.",
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
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                          ConduitFontFamily.robotoRegular,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Sign up for Conduit.",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              emailCtr.clear();
                                              passwordCtr.clear();
                                            });
                                            formKey.currentState?.reset();
                                            Navigator.pushNamed(context,
                                                RegisterScreen.registerUrl,
                                                arguments: {
                                                  "screenSize": screenSize,
                                                });
                                            // Navigator.push(
                                            //   context,
                                            //   CupertinoPageRoute(
                                            //     builder: (context) =>
                                            //         RegisterScreen(
                                            //       screenSize: screenSize,
                                            //     ),
                                            //   ),
                                            // );
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
      ),
    );
  }
}

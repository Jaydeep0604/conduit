import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/bloc/login_bloc/login_state.dart';
import 'package:conduit/bloc/register_bloc/register_bloc.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/ui/register/register_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/login_bloc/login_event.dart';
import '../../widget/conduitEditText_widget.dart';

class LoginScreen extends StatefulWidget {
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: AppColors.white2,
          body: SingleChildScrollView(
            child: MultiBlocListener(
              listeners: [
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginLoadingState) {
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
                      // CToast.instance.dismiss();
                    }
                    if (state is LoginErrorState) {
                      setState(() {
                        isLoading = false;
                      });
                      // this pop is for showLoaderDialog dismiss
                      Navigator.pop(context);
                      CToast.instance.showError(context, state.msg);
                    }

                    if (state is LoginSuccessState) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                      CToast.instance.showSuccess(context, "login successfull");
                    }
                  },
                ),
              ],
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 188, 215, 202),
                      Color.fromARGB(255, 234, 243, 238),
                      Color.fromARGB(255, 234, 243, 238),
                      Color.fromARGB(255, 234, 243, 238),
                      Color.fromARGB(255, 188, 215, 202),
                    ],
                  ),
                ),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Container(
                            height: 110,
                            child: Column(
                              children: [
                                Text(
                                  "conduit",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                      color: AppColors.primaryColor),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("A place to share your knowledge.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: AppColors.black))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 50),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 15, right: 30, left: 30),
                          child: Column(
                            children: [
                              ConduitEditText(
                                hint: "Enter Email Address",
                                controller: emailCtr,
                                maxLines: 1,
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
                                    return "Please enter email address";
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
                        Container(
                          padding:
                              EdgeInsets.only(top: 15, right: 30, left: 30),
                          child: Column(
                            children: [
                              ConduitEditText(
                                controller: passwordCtr,
                                hint: "Enter Password",
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
                                    return "Please enter password";
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
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            height: 45,
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
                              // isLoading
                              //     ? Container(
                              //         height: 40,
                              //         padding: EdgeInsets.all(8),
                              //         child: CToast.instance.showLoader(),
                              //       )
                              //     : Text('Sign in',
                              //         style: Theme.of(context)
                              //             .textTheme
                              //             .button
                              //             ?.copyWith(
                              //                 color: Colors.white,
                              //                 fontWeight: FontWeight.w500)),
                              onPressed: () {
                                FocusNode? focusNode =
                                    FocusManager.instance.primaryFocus;
                                if (focusNode != null) {
                                  if (focusNode.hasPrimaryFocus) {
                                    focusNode.unfocus();
                                  }
                                }

                                if (formKey.currentState?.validate() ?? false) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  loginBloc.add(
                                    LoginSubmitEvent(
                                      // email: emailCtr.text.trim(),
                                      // password: passwordCtr.text.trim(),
                                      // fcmToken: '1',
                                      // userDeviceId: '1',
                                      authModel: AuthModel(
                                        password: passwordCtr.text.trim(),
                                        email: emailCtr.text.trim(),
                                      ),
                                    ),
                                  );
                                  // CToast.instance.showSuccess(context,
                                  //     "Data added in ( RegisterSubmitEvent )");
                                }

                                // if (_form.currentState?.validate() ?? false) {
                                //   RegisterModel regModel =
                                //       _createRegisterModel()!;
                                //   if (_createRegisterModel != null) {
                                //     registerBloc.add(
                                //       RegisterSubmitEvent(
                                //         registerModel: regModel,
                                //       ),
                                //     );
                                //     CToast.instance.showSuccess(context,
                                //         "Data added in ( RegisterSubmitEvent )");
                                //   } else {
                                //     CToast.instance
                                //         .showError(context, "Data not added");
                                //   }
                                // }
                              },
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(right: 30, left: 30, top: 20),
                        //   alignment: Alignment.topRight,
                        //   child: MaterialButton(
                        //     minWidth: MediaQuery.of(context).size.width,
                        //     height: 40,
                        //     color: AppColors.primaryColor,
                        //     disabledColor: AppColors.Box_width_color,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12.0)),
                        //     child: isLoading
                        //         ? Container(
                        //             height: 40,
                        //             padding: EdgeInsets.all(8),
                        //             child: CToast.instance.showLoader(),
                        //           )
                        //         : Text('Sign in',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .button
                        //                 ?.copyWith(
                        //                     color: Colors.white,
                        //                     fontWeight: FontWeight.w700)),
                        //     onPressed: isLoading
                        //         ? null
                        //         : () {
                        //             FocusNode? focusNode =
                        //                 FocusManager.instance.primaryFocus;
                        //             if (focusNode != null) {
                        //               if (focusNode.hasPrimaryFocus) {
                        //                 focusNode.unfocus();
                        //               }
                        //             }
                        //             if (formKey.currentState?.validate() ??
                        //                 false) {
                        //               loginBloc.add(
                        //                 LoginSubmitEvent(
                        //                   // email: emailCtr.text.trim(),
                        //                   // password: passwordCtr.text.trim(),
                        //                   // fcmToken: '1',
                        //                   // userDeviceId: '1',
                        //                   authModel: AuthModel(
                        //                     password: passwordCtr.text.trim(),
                        //                     email: emailCtr.text.trim(),
                        //                   ),
                        //                 ),
                        //               );
                        //               // CToast.instance.showSuccess(context,
                        //               //     "Data added in ( RegisterSubmitEvent )");
                        //             }
                        //             // if (_form.currentState?.validate() ?? false) {
                        //             //   RegisterModel regModel =
                        //             //       _createRegisterModel()!;
                        //             //   if (_createRegisterModel != null) {
                        //             //     registerBloc.add(
                        //             //       RegisterSubmitEvent(
                        //             //         registerModel: regModel,
                        //             //       ),
                        //             //     );
                        //             //     CToast.instance.showSuccess(context,
                        //             //         "Data added in ( RegisterSubmitEvent )");
                        //             //   } else {
                        //             //     CToast.instance
                        //             //         .showError(context, "Data not added");
                        //             //   }
                        //             // }
                        //           },
                        //   ),
                        // ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(color: AppColors.black),
                            ),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  emailCtr.clear();
                                  passwordCtr.clear();
                                });
                                formKey.currentState?.reset();
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              }),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/bloc/login_bloc/login_state.dart';
import 'package:conduit/bloc/register_bloc/register_bloc.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/ui/register/register_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
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
  bool switchValue = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late LoginBloc loginBloc;
  late RegisterBloc registerBloc;
  late TextEditingController emailCtr =
      TextEditingController();
  late TextEditingController passwordCtr =
      TextEditingController();
  @override
  void initState() {
    // emailCtr = TextEditingController();
    // passwordCtr = TextEditingController();
    registerBloc = context.read<RegisterBloc>();
    loginBloc = context.read<LoginBloc>();

    super.initState();
  }

  @override
  void loading() {
    CToast.instance.showLoading(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white2,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginLoadingState) {
                  setState(() {
                    isLoading = true;
                  });
                  CToast.instance.showLoading(context);
                } else {
                  CToast.instance.dismiss();
                }
                if (state is LoginErrorState) {
                  setState(() {
                    isLoading = false;
                  });
                  CToast.instance.showError(context, state.msg);
                }

                if (state is LoginSuccessState) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  CToast.instance.showSuccess(context, "login successfull");
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            child: Container(
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
                        padding: EdgeInsets.only(top: 15, right: 30, left: 30),
                        child: Column(
                          children: [
                            ConduitEditText(
                              hint: "Enter Email Address",
                              controller: emailCtr,
                              inputformtters: [
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
                        padding: EdgeInsets.only(top: 15, right: 30, left: 30),
                        child: Column(
                          children: [
                            ConduitEditText(
                              controller: passwordCtr,
                              hint: "Enter Password",
                              // obsecureText: _obsecureText,
                              textInputType: TextInputType.visiblePassword,
                              inputformtters: [
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
                              // suffixIcon: GestureDetector(
                              //   onTap: _toggleObscured,
                              //   child: Transform.scale(
                              //     scale: 0.5,
                              //     child: ImageIcon(
                              //       _obsecureText
                              //           ? AssetImage(
                              //               "assets/icons/eye_off.png",
                              //             )
                              //           : AssetImage(
                              //               "assets/icons/eye_none.png",
                              //             ),
                              //       size: 12,
                              //       color: AppColors.button_color,
                              //     ),
                              //   ),
                              // ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: (() {
                          FocusManager.instance.primaryFocus!.unfocus();
                          setState(() {
                            // emailCtr.clear();
                            // passwordctr.clear();
                          });
                          // Navigator.pushNamed(
                          //         context, ForgetPassword.forgetPasswordUrl)
                          //     .then((value) {
                          //   formKey.currentState?.reset();
                          // });
                        }),
                        child: Container(
                          padding: EdgeInsets.only(right: 30, top: 0.2),
                          alignment: Alignment.topRight,
                          child: Text('Forgot Password?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      // fontFamily: KSMFontFamily.robotoRgular,
                                      color: AppColors.text_color)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 30, left: 30, top: 20),
                        alignment: Alignment.topRight,
                        child: FlatButton(
                          minWidth: MediaQuery.of(context).size.width,
                          height: 40,
                          color: AppColors.primaryColor,
                          disabledColor: AppColors.Box_width_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: isLoading
                              ? Container(
                                  height: 40,
                                  padding: EdgeInsets.all(8),
                                  child: CToast.instance.showLoader(),
                                )
                              : Text('Sign in',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                          onPressed: isLoading
                              ? null
                              : () {
                                  FocusNode? focusNode =
                                      FocusManager.instance.primaryFocus;
                                  if (focusNode != null) {
                                    if (focusNode.hasPrimaryFocus) {
                                      focusNode.unfocus();
                                    }
                                  }
                                  if (formKey.currentState?.validate() ??
                                      false) {
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
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            // emailCtr.clear();
                            // passwordctr.clear();
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        }),
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 20,
                            top: 40,
                          ),
                          alignment: Alignment.center,
                          child: Text('need account?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.primaryColor)),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

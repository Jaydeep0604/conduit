import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/bloc/register_bloc/register_event.dart';
import 'package:conduit/bloc/register_bloc/register_state.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/register_bloc/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailCtr = TextEditingController();
  late TextEditingController passwordctr = TextEditingController();
  late TextEditingController UserNameCtr = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obsecureText = true;
  late RegisterBloc registerBloc;
  AuthModel? authModel;

  // void _toggleObscured() {
  //   setState(() {
  //     _obsecureText = !_obsecureText;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // UserNameCtr = TextEditingController();
    // emailCtr = TextEditingController();
    registerBloc = context.read<RegisterBloc>();
    _form = GlobalKey<FormState>();
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
            BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterLoadingState) {
                  setState(() {
                    isLoading = true;
                  });
                  CToast.instance.showLoading(context);
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  CToast.instance.dismiss();
                }

                if (state is RegisterDoneState) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                  CToast.instance.showSuccess(context, "Success");
                }

                if (state is RegisterErrorState) {
                  CToast.instance.showError(context, state.msg);
                }
              },
            )
          ],
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                  key: _form,
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
                          'Sign Up',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 30, left: 30),
                        child: Column(
                          children: [
                            ConduitEditText(
                              controller: UserNameCtr,
                              textInputType: TextInputType.text,
                              hint: "Enter Your Username",
                              inputformtters: [
                                LengthLimitingTextInputFormatter(30),
                                FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'),
                                    allow: true),
                                LengthLimitingTextInputFormatter(25)
                              ],
                              validator: (value) {
                                if (value?.trimLeft().trimRight().isEmpty ??
                                    true) {
                                  return "Please enter Username";
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
                              controller: passwordctr,
                              hint: "Enter Password",
                              obsecureText: _obsecureText,
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
                          setState(() {
                            emailCtr.clear();
                            passwordctr.clear();
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
                              : Text('Sign Up',
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
                                  if (_form.currentState?.validate() ?? false) {
                                    AuthModel aModel = _createRegisterModel()!;
                                    if (_createRegisterModel != null) {
                                      registerBloc.add(
                                        RegisterSubmitEvent(
                                          authModel: aModel,
                                        ),
                                      );
                                      // CToast.instance.showSuccess(context,
                                      //     "Data added in ( RegisterSubmitEvent )");
                                    } else {
                                      CToast.instance
                                          .showError(context, "Data not added");
                                    }
                                  }
                                },
                        ),
                      ),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            emailCtr.clear();
                            passwordctr.clear();
                          });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => BlocProvider(
                          //               create: (context) => LoginBloc(),
                          //               child: LoginScreen(),
                          //             )));
                        }),
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 20,
                            top: 40,
                          ),
                          alignment: Alignment.center,
                          child: Text('Already have account?',
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

  AuthModel? _createRegisterModel() {
    return AuthModel(
        username: UserNameCtr.text.trimLeft().trimRight(),
        email: emailCtr.text.trim(),
        password: passwordctr.text.trim());
  }
}

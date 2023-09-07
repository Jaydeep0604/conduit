import 'package:conduit/bloc/register_bloc/register_event.dart';
import 'package:conduit/bloc/register_bloc/register_state.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/auth_model.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:flutter/cupertino.dart';
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
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.white2,
          appBar: AppBar(
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
                )),
          ),
          body: SingleChildScrollView(
            child: MultiBlocListener(
              listeners: [
                BlocListener<RegisterBloc, RegisterState>(
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
                      Navigator.pop(context);
                      CToast.instance.showError(context, NO_INTERNET);
                    }
                    if (state is RegisterDoneState) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => LoginScreen()));
                      CToast.instance.showSuccess(context, "Success");
                    }

                    if (state is RegisterErrorState) {
                      // this pop is for showLoaderDialog dismiss
                      Navigator.pop(context);
                      // UserNameCtr.clear();
                      // emailCtr.clear();
                      // passwordctr.clear();
                      CToast.instance.showError(context, state.msg);
                    }
                  },
                )
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
                                    fontSize: 50,
                                    color: AppColors.primaryColor,
                                    fontFamily: ConduitFontFamily.robotoBold,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("A place to share your knowledge.",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: AppColors.black,
                                      fontFamily:
                                          ConduitFontFamily.robotoRegular,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 30, top: 50),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: ConduitFontFamily.robotoRegular,
                            ),
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
                                maxLines: 1,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30),
                                  FilteringTextInputFormatter(
                                      RegExp(r'[a-zA-Z]'),
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
                          padding:
                              EdgeInsets.only(top: 15, right: 30, left: 30),
                          child: Column(
                            children: [
                              ConduitEditText(
                                hint: "Enter Email Address",
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
                                controller: passwordctr,
                                hint: "Enter Password",
                                maxLines: 1,
                                obsecureText: _obsecureText,
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
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(right: 30, left: 30, top: 20),
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
                              if (_form.currentState?.validate() ?? false) {
                                AuthModel aModel = _createRegisterModel()!;
                                if (_createRegisterModel != null) {
                                  registerBloc.add(
                                    RegisterSubmitEvent(
                                      authModel: aModel,
                                    ),
                                  );
                                  // CToast.instance.showSuccess(context,
                                  //     "Data added in ( RegisterSubmitEvent                                                                                                                                            )");
                                } else {
                                  CToast.instance
                                      .showError(context, "Data not added");
                                }
                              }
                            },
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: AppColors.black,
                                fontFamily: ConduitFontFamily.robotoRegular,
                              ),
                            ),
                            GestureDetector(
                              onTap: (() {
                                Navigator.pop(context);
                              }),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontFamily: ConduitFontFamily.robotoRegular,
                                ),
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

  AuthModel? _createRegisterModel() {
    return AuthModel(
        username: UserNameCtr.text.trimLeft().trimRight(),
        email: emailCtr.text.trim(),
        password: passwordctr.text.trim());
  }
}

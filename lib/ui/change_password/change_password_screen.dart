import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController confirmPasswordCtr = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obsecureText = false;
  bool _obsecureText2 = false;
  late ProfileBloc profileBloc;
  @override
  void initState() {
    profileBloc = context.read<ProfileBloc>();
    super.initState();
  }

  _toggleObscured() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  _toggleObscured2() {
    setState(() {
      _obsecureText2 = !_obsecureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            "Change Password",
            style: TextStyle(
              color: AppColors.white,
              fontFamily: ConduitFontFamily.robotoRegular,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ChangePasswordLoadingState) {
                  //return CToast.instance.showLoader();
                }
                if (state is ChangePasswordSuccessState) {
                  passwordCtr.clear();
                  confirmPasswordCtr.clear();
                  Navigator.pop(context);
                  print("password updated");
                  CToast.instance
                      .showError(context, "Password Updated Successfully");
                  ConduitFunctions.logOut(context);
                }
                if (state is ChangePasswordErrorState) {
                  Navigator.pop(context);
                  print("errrrrrrrrrrr ${state.message}");
                  // CToast.instance.showError(context, state.msg);
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Column(
                          children: [
                            TextFormField(
                              autofocus: false,
                              obscureText: _obsecureText,
                              cursorColor: AppColors.primaryColor,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(' '),
                                LengthLimitingTextInputFormatter(16)
                              ],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value!.length <= 6) {
                                  return "Password must be minimum 6 characters";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.white2,
                                contentPadding: const EdgeInsets.all(10),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: AppColors.primaryColor,
                                ),
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
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.white2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.white2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.white2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.white2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: AppColors.white2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter Your New Password",
                                // prefixText: 'GJ011685',
                              ),
                              controller: passwordCtr,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Column(
                          children: [
                            TextFormField(
                              autofocus: false,
                              obscureText: _obsecureText2,
                              cursorColor: AppColors.primaryColor,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(' '),
                                LengthLimitingTextInputFormatter(16)
                              ],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value?.trimLeft().trimRight().isEmpty ??
                                    true) {
                                  return "Please enter your confirm password";
                                } else if (value != passwordCtr.text) {
                                  return "Confirm password should match with new password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.white2,
                                  contentPadding: const EdgeInsets.all(10),
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: AppColors.primaryColor,
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: _toggleObscured2,
                                    child: Transform.scale(
                                      scale: 0.9,
                                      child: Icon(
                                        _obsecureText2
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: AppColors.white2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Enter Confirm Password"),
                              controller: confirmPasswordCtr,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: MaterialButton(
                            color: AppColors.primaryColor,
                            textColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              if (_formKey.currentState?.validate() ?? false) {
                                CToast.instance.showLoaderDialog(context);
                                profileBloc.add(
                                  ChangePasswordEvent(
                                    profileModel: ProfileModel(
                                      user: User(
                                        password: passwordCtr.text.toString(),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(
                                color: AppColors.white,
                                fontFamily: ConduitFontFamily.robotoRegular,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // void logOutUser() async {
  //   await hiveStore.logOut();
  //   // await hiveStore.init();
  // }
}

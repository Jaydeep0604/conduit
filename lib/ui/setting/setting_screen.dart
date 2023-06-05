import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? email, username, bio, image;
  TextEditingController? emailCtr, usernameCtr, bioCtr, imageCtr;
  late ProfileBloc profileBloc;
  bool isLoading = false;
  @override
  void initState() {
    profileBloc = context.read<ProfileBloc>();
    profileBloc.add(FetchProfileEvent());
    addData();
    super.initState();
  }

  addData() {
    emailCtr = TextEditingController(text: email);
    usernameCtr = TextEditingController(text: username);
    bioCtr = TextEditingController(text: bio);
    image;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        // backgroundColor: AppColors.white2,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Settings",
            style: TextStyle(fontSize: 20, color: AppColors.primaryColor2),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                  onTap: () {
                    onLogout();
                  },
                  child: Icon(
                    Icons.logout_outlined,
                    color: AppColors.white,
                  )),
            )
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState) {
                return CToast.instance.showLoader();
              }
              if (state is ProfileErrorState) {
                return CToast.instance.showError(context, state.message);
              }
              if(state is ProfileUpdateLoadingState)
              {
                return CToast.instance.showLoader();
              }
              if(state is ProfileUpdateSuccessState){
                profileBloc.add(FetchProfileEvent());
              }
              if(state is ProfileUpdateErrorState){
                return CToast.instance.showError(context, state.msg);
              }
              if (state is ProfileLoadedState) {
                email = state.profileList.first.user!.email;
                username = state.profileList.first.user!.username;
                bio = state.profileList.first.user!.bio;
                image = state.profileList.first.user!.image;
                addData();
                return SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Form(
                      // key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: AppColors.primaryColor, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                    state.profileList.first.user!.image!,
                                    alignment: Alignment.center),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 20, left: 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: false,
                                  // initialValue: detail!.userName.toString(),
                                  controller: usernameCtr,
                                  cursorColor: AppColors.primaryColor,
                                  keyboardType: TextInputType.text,
                                  
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.white2,
                                      contentPadding: const EdgeInsets.all(10),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                      //prefixText: 'GJ011685',
                                      hintText: "Username"),
                                  // controller: emailCtr,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 20, left: 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLines: 5,
                                  autofocus: false,
                                  // initialValue: detail.bio.toString(),
                                  controller: bioCtr,
                                  cursorColor: AppColors.primaryColor,
                                  keyboardType: TextInputType.text,
                                 
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.white2,
                                      contentPadding: const EdgeInsets.all(10),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                      hintText: "Bio"),
                                  // controller: emailCtr,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 20, left: 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: false,
                                  // initialValue: detail.email.toString(),
                                  controller: emailCtr,
                                  cursorColor: AppColors.primaryColor,
                                  keyboardType: TextInputType.text,
                                 
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.white2,
                                      contentPadding: const EdgeInsets.all(10),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                      hintText: "Email"
                                      //prefixText: 'GJ011685',
                                      ),
                                  // controller: emailCtr,
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 20, left: 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: false,
                                  // initialValue: textarearefcode.text,
                                  cursorColor: AppColors.primaryColor,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(16)
                                  ],
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.white2,
                                      contentPadding: const EdgeInsets.all(10),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                      hintText: "New Password"
                                      // prefixText: 'GJ011685',
                                      ),
                                  // controller: emailCtr,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: SizedBox(
                              width: 320,
                              height: 45,
                              child: MaterialButton(
                                color: AppColors.primaryColor,
                                textColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  profileBloc.add(
                                    UpdateProfileEvent(
                                      profileModel: ProfileModel(
                                        user: User(
                                          username: usernameCtr!.text.toString(),
                                          email: emailCtr!.text.toString(),
                                          bio: bioCtr!.text.toString(),
                                          image: image.toString()
                                          
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: isLoading == true
                                    ? Container(
                                        height: 40,
                                        padding: EdgeInsets.all(8),
                                        child: CToast.instance.showLoader(),
                                      )
                                    : Text(
                                        'Save Profile',
                                        style:
                                            TextStyle(color: AppColors.white),
                                      ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 25),
                          //   child: SizedBox(
                          //     width: 320,
                          //     height: 45,
                          //     child: MaterialButton(
                          //       textColor: AppColors.white,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //         side: BorderSide(color: Colors.red[400]!),
                          //       ),
                          //       onPressed: () {
                          //         FocusManager.instance.primaryFocus!.unfocus();
                          //         setState(() {
                          //           onLogout();
                          //         });
                          //       },
                          //       child: Text(
                          //         'Logout',
                          //         style: TextStyle(color: Colors.red[400]),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  onLogout() {
    showAlertBottomSheet().then((value) {
      if (value != null) {
        if (value == true) {
          //  settingBloc.add(LogoutEvent());
        }
      }
    });
  }

  Future showAlertBottomSheet() {
    return showCupertinoModalPopup(
      context: context,
      // backgroundColor: Color.fromARGB(255, 19, 19, 19),
      builder: (context) {
        return IntrinsicHeight(
          child: SafeArea(
            child: Container(
              color: AppColors.black,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Text(
                      "Are you sure you want to sign out ?",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: AppColors.white,
                            // fontFamily: KSMFontFamily.robotoThin,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                              height: 40,
                              color: AppColors.white,
                              disabledColor: AppColors.pholder_background,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: new Text('Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          // fontFamily: KSMFontFamily.robotoRgular
                                          )
                                      .copyWith(color: Colors.black)),
                              onPressed: () {
                                Navigator.pop(context, false);
                              }),
                        ),
                        // Expanded(
                        //   child: TextButton(
                        //     style: ButtonStyle(
                        //       minimumSize: MaterialStateProperty.all<Size>(
                        //           Size(MediaQuery.of(context).size.width, 40)),
                        //       shape: MaterialStateProperty.all<
                        //           RoundedRectangleBorder>(RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12.0),
                        //       )),
                        //       backgroundColor: MaterialStateProperty.all<Color>(
                        //           AppColors.pholder_background),
                        //     ),
                        //     child: new Text('Cancel',
                        //         // textAlign: TextAlign.center,
                        //         style:
                        //             Theme.of(context).textTheme.button?.copyWith(
                        //                   fontFamily: KSMFontFamily.robotoRgular,
                        //                   color: Colors.white,
                        //                 )),
                        //     onPressed: () {
                        //       Navigator.pop(context, false);
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FlatButton(
                            height: 40,
                            color: AppColors.primaryColor,
                            // disabledColor: AppColors.Bottom_bar_color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: new Text(
                              'Confirm',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      //fontFamily: KSMFontFamily.robotoRgular
                                      )
                                  .copyWith(color: AppColors.white),
                            ),
                            onPressed: () async {
                              await hiveStore.logOut();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
// for hivedata show 
// ValueListenableBuilder(
//             valueListenable:
//                 Hive.box<UserAccessData>(hiveStore.userDetailKey).listenable(),
//             builder: (BuildContext context, dynamic box, Widget? child) {
//               UserAccessData? detail = box.get(hiveStore.userId);
//               return Container();
//             },
//           ),
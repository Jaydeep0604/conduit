import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/config/constant.dart';
import 'package:conduit/main.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:conduit/ui/my_articles/my_articles_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/functions.dart';
import 'package:conduit/utils/image_string.dart';
import 'package:conduit/utils/message.dart';
import 'package:conduit/widget/conduitEditText_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  static const editProfileUrl = '/editProfile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email, username, bio, image;
  TextEditingController? emailCtr, usernameCtr, bioCtr, imageCtr;
  TextEditingController passwordCtr = TextEditingController();
  late ProfileBloc profileBloc;
  bool isLoading = false;
  bool isNoInternet = false;
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
    imageCtr = TextEditingController(text: image);
    image;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: WillPopScope(
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
              "Profile",
              style: TextStyle(
                color: AppColors.white,
                fontFamily: ConduitFontFamily.robotoRegular,
              ),
            ),
          ),
          body: SafeArea(
              child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoadingState) {
                CToast.instance.showLodingLoader(context);
              } else {
                CToast.instance.dismiss();
              }
              if (state is ProfileNoInternetState) {
                CToast.instance.dismiss();
                CToast.instance.showError(context, NO_INTERNET);
              }
              if (state is ProfileErrorState) {
                print("error ${state.message}");
                return CToast.instance.showError(context, state.message);
              }
              if (state is UpdateProfileSuccessState) {
                Navigator.pushNamedAndRemoveUntil(context,
                    MyArticlesScreen.myArticlesUrl, (route) => route.isFirst);
                // Navigator.popUntil(context, (route) => route.isFirst);
                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(builder: (context) {
                //     return ProfileScreen();
                //   }),
                // );
              }
              if (state is UpdateProfileErrorState) {
                // CToast.instance.dismiss(context);
                print("Profile not updated, please try again later");
                CToast.instance.showToastError(
                    "Profile not updated, please try again later");
              }
              if (state is ProfileLoadedState) {
                email = state.profileList.first.user!.email;
                username = state.profileList.first.user!.username;
                bio = state.profileList.first.user!.bio;
                image = state.profileList.first.user!.image;
                addData();
                CToast.instance.dismiss();
              }
            },
            builder: (context, state) {
              return ScrollConfiguration(
                behavior: NoGlow(),
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                child: image != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(image!,
                                            alignment: Alignment.center),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 45,
                                            color: AppColors.text_color,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ConduitEditText(
                              controller: imageCtr,
                              maxLines: 1,
                              minLines: 1,
                              prefixIcon: Icon(
                                Icons.link,
                                color: AppColors.primaryColor,
                              ),
                              textInputType: TextInputType.url,
                              hint: "Profile photo url",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ConduitEditText(
                              // readOnly: true,
                              controller: usernameCtr,
                              textInputType: TextInputType.text,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15),
                                child: SvgPicture.asset(
                                  ic_profile_icon,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              hint: "Username",
                              validator: (value) {
                                if (value!.length == 0) {
                                  return "Enter username";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ConduitEditText(
                                controller: bioCtr,
                                textInputType: TextInputType.text,
                                minLines: 5,
                                maxLines: 5,
                                hint: "Bio"),
                            SizedBox(
                              height: 20,
                            ),
                            ConduitEditText(
                              readOnly: true,
                              controller: emailCtr,
                              textInputType: TextInputType.emailAddress,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15),
                                child: SvgPicture.asset(
                                  ic_mail_icon,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              hint: "Email",
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              child: MaterialButton(
                                color: AppColors.primaryColor,
                                textColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    profileBloc.add(
                                      UpdateProfileEvent(
                                        profileModel: ProfileModel(
                                          user: User(
                                              username:
                                                  usernameCtr!.text.toString(),
                                              email: emailCtr!.text.toString(),
                                              bio: bioCtr!.text.toString(),
                                              image: imageCtr!.text.toString()),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontFamily: ConduitFontFamily.robotoRegular,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
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
                  ),
                ),
              );
            },
          )),
        ),
      ),
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
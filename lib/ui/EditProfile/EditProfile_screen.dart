import 'package:conduit/bloc/article_bloc/article_state.dart';
import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/model/profile_model.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email, username, bio, image;
  TextEditingController? emailCtr, usernameCtr, bioCtr, imageCtr;
  TextEditingController passwordCtr = TextEditingController();
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
              "EditProfiles",
              style: TextStyle(color: AppColors.white),
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return Center(
                    child: CToast.instance.showLoader(),
                  );
                }
                if (state is ProfileErrorState) {
                  print("errrrrrrrrrrr ${state.message}");
                  return CToast.instance.showError(context, state.message);
                }
                if (state is UpdateProfileSuccessState) {
                  Navigator.pop(context);
                }
                if (state is UpdateArticleErroeState) {
                  Navigator.pop(context);
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
                  // return
                }
                return SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Form(
                      key: _formKey,
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
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 20, left: 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: false, controller: usernameCtr,
                                  cursorColor: AppColors.primaryColor,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.white2,
                                      contentPadding: const EdgeInsets.all(10),
                                      prefixIcon: Icon(
                                        CupertinoIcons.person,
                                        color: AppColors.primaryColor,
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
                                      // prefixIcon: Icon(
                                      //   CupertinoIcons
                                      //       .pencil_ellipsis_rectangle,
                                      //   color: AppColors.primaryColor,
                                      // ),
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
                                      prefixIcon: Icon(
                                        CupertinoIcons.mail,
                                        color: AppColors.primaryColor,
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
                                  if (_formKey.currentState!.validate()) {
                                    FocusManager.instance.primaryFocus!
                                        .unfocus();
                                    CToast.instance.showLoaderDialog(context);

                                    profileBloc.add(
                                      UpdateProfileEvent(
                                        profileModel: ProfileModel(
                                          user: User(
                                              username:
                                                  usernameCtr!.text.toString(),
                                              email: emailCtr!.text.toString(),
                                              bio: bioCtr!.text.toString(),
                                              image: image.toString()),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: AppColors.white),
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
                );
              },
            ),
          ),
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
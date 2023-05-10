import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc profileBloc;
  @override
  void initState() {
    profileBloc = context.read<ProfileBloc>();
    profileBloc.add(FetchProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white2,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Container(),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "conduit",
              style: TextStyle(color: AppColors.primaryColor2, fontSize: 30),
            ),
            Text(
              "A place to share your knowledge.",
              style: TextStyle(color: AppColors.white2, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: SafeArea(child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileInitialState || state is ProfileLoadingState) {
              return Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  color: Colors.white,
                ),
              );
            }
            if (state is ProfileLoadedError) {
              return GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Form(
                    // key: _formKey,
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 50),
                        child: Container(
                            height: 650,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[500],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: CircleAvatar(
                                    child: Image.network(
                                        "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_960_720.png",
                                        alignment: Alignment.center),
                                    radius: 5,
                                  ),
                                ),
                                Container(
                                  color: AppColors.white,
                                  padding: EdgeInsets.only(
                                      left: 30, top: 5, right: 30),
                                  alignment: Alignment.topLeft,
                                  child: Text('${'--'}',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.grey)),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, right: 20, left: 20),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        autofocus: false,
                                        // initialValue:user!.userName.toString(),
                                        cursorColor: AppColors.primaryColor,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(8)
                                        ],
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.white2,
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            //prefixText: 'GJ011685',
                                            hintText: "Username"),
                                        // controller: emailCtr,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, right: 20, left: 20),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        maxLines: 5,
                                        autofocus: false,
                                        // initialValue: user!.bio.toString(),
                                        cursorColor: AppColors.primaryColor,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(8)
                                        ],
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.white2,
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            //prefixText: 'GJ011685',
                                            hintText: "Bio"),
                                        // controller: emailCtr,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, right: 20, left: 20),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        autofocus: false,
                                        // initialValue: textarearefcode.text,
                                        cursorColor: AppColors.primaryColor,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(8)
                                        ],
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.white2,
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                  padding: EdgeInsets.only(
                                      top: 20, right: 20, left: 20),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        autofocus: false,
                                        // initialValue: textarearefcode.text,
                                        cursorColor: AppColors.primaryColor,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(8)
                                        ],
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.white2,
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            prefixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 3,
                                                  color: AppColors.white2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        setState(() {
                                          // if (_formKey.currentState!.validate()) {
                                          //   Fluttertoast.showToast(
                                          //       msg: "Profile Saved",
                                          //       toastLength: Toast.LENGTH_SHORT,
                                          //       gravity: ToastGravity.SNACKBAR,
                                          //       timeInSecForIosWeb: 1,
                                          //       backgroundColor: AppColors.cursorcolor,
                                          //       textColor: Colors.white,
                                          //       fontSize: 16.0);
                                          //   Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => MyProfileScreen()),
                                          //   );
                                          // } else {}
                                        });
                                      },
                                      child: Text('Save Profile'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 25),
                                  child: SizedBox(
                                    width: 320,
                                    height: 45,
                                    child: MaterialButton(
                                      color: Colors.red[400],
                                      textColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        setState(() {
                                          // if (_formKey.currentState!.validate()) {
                                          //   Fluttertoast.showToast(
                                          //       msg: "Profile Saved",
                                          //       toastLength: Toast.LENGTH_SHORT,
                                          //       gravity: ToastGravity.SNACKBAR,
                                          //       timeInSecForIosWeb: 1,
                                          //       backgroundColor: AppColors.cursorcolor,
                                          //       textColor: Colors.white,
                                          //       fontSize: 16.0);
                                          //   Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => MyProfileScreen()),
                                          //   );
                                          // } else {}
                                        });
                                      },
                                      child: Text('Logout'),
                                    ),
                                  ),
                                ),
                              ],
                            ))),
                  ));
            }
            return SizedBox();
          },
        )),
      )),
    );
  }
}

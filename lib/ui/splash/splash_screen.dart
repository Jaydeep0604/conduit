import 'dart:async';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/ui/home/home_screen.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1200), () async {
      Box<UserAccessData>? detailModel =
          await hiveStore.isExistUserAccessData();
      if (detailModel!.values.isNotEmpty) {
        Navigator.push(
            context, (MaterialPageRoute(builder: (context) => HomeScreen())));
      }
      if (detailModel.values.isEmpty)
        Navigator.pushReplacement(
            context, (MaterialPageRoute(builder: (context) => LoginScreen())));
    });
    // Timer(
    //     Duration(seconds: 1),
    //     () => Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: 320),
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Text(
                'conduit',
                style: TextStyle(fontSize: 40, color: Colors.white),
              )),
          Center(
            child: Container(
                margin: EdgeInsets.only(
                  top: 380,
                ),
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Text(
                  'A place to share your knowledge.',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}

// Form(
//                 // key: _formKey,
//                 child: Padding(
//                     padding:
//                         const EdgeInsets.only(left: 10, right: 10, top: 50),
//                     child: Container(
//                         height: 650,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.grey[500],
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Container(
//                               height: 100,
//                               width: 100,
//                               child: CircleAvatar(
//                                 child: Image.network(
//                                     "https://cdn.pixabay.com/photo/2020/07/01/12/58/icon-5359553_960_720.png",
//                                     alignment: Alignment.center),
//                                 radius: 5,
//                               ),
//                             ),
//                             Container(
//                               color: AppColors.white,
//                               padding:
//                                   EdgeInsets.only(left: 30, top: 5, right: 30),
//                               alignment: Alignment.topLeft,
//                               child: Text('${'--'}',
//                                   maxLines: 1,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyMedium
//                                       ?.copyWith(
//                                           overflow: TextOverflow.ellipsis,
//                                           color: Colors.grey)),
//                             ),
//                             Container(
//                               padding:
//                                   EdgeInsets.only(top: 20, right: 20, left: 20),
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     autofocus: false,
//                                     // initialValue:user!.userName.toString(),
//                                     cursorColor: AppColors.primaryColor,
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: [
//                                       LengthLimitingTextInputFormatter(8)
//                                     ],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                     ),
//                                     decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: AppColors.white2,
//                                         contentPadding:
//                                             const EdgeInsets.all(10),
//                                         prefixIcon: Padding(
//                                           padding: const EdgeInsets.all(15.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         disabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         errorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         //prefixText: 'GJ011685',
//                                         hintText: "Username"),
//                                     // controller: emailCtr,
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding:
//                                   EdgeInsets.only(top: 20, right: 20, left: 20),
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     maxLines: 5,
//                                     autofocus: false,
//                                     // initialValue: user!.bio.toString(),
//                                     cursorColor: AppColors.primaryColor,
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: [
//                                       LengthLimitingTextInputFormatter(8)
//                                     ],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                     ),
//                                     decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: AppColors.white2,
//                                         contentPadding:
//                                             const EdgeInsets.all(10),
//                                         prefixIcon: Padding(
//                                           padding: const EdgeInsets.all(15.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         disabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         errorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         //prefixText: 'GJ011685',
//                                         hintText: "Bio"),
//                                     // controller: emailCtr,
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding:
//                                   EdgeInsets.only(top: 20, right: 20, left: 20),
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     autofocus: false,
//                                     // initialValue: textarearefcode.text,
//                                     cursorColor: AppColors.primaryColor,
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: [
//                                       LengthLimitingTextInputFormatter(8)
//                                     ],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                     ),
//                                     decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: AppColors.white2,
//                                         contentPadding:
//                                             const EdgeInsets.all(10),
//                                         prefixIcon: Padding(
//                                           padding: const EdgeInsets.all(15.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         disabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         errorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         hintText: "Email"
//                                         //prefixText: 'GJ011685',
//                                         ),
//                                     // controller: emailCtr,
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding:
//                                   EdgeInsets.only(top: 20, right: 20, left: 20),
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                     autofocus: false,
//                                     // initialValue: textarearefcode.text,
//                                     cursorColor: AppColors.primaryColor,
//                                     keyboardType: TextInputType.number,
//                                     inputFormatters: [
//                                       LengthLimitingTextInputFormatter(8)
//                                     ],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                     ),
//                                     decoration: InputDecoration(
//                                         filled: true,
//                                         fillColor: AppColors.white2,
//                                         contentPadding:
//                                             const EdgeInsets.all(10),
//                                         prefixIcon: Padding(
//                                           padding: const EdgeInsets.all(15.0),
//                                         ),
//                                         border: OutlineInputBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10)),
//                                         disabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         errorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         focusedErrorBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 3,
//                                               color: AppColors.white2),
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         hintText: "New Password"
//                                         // prefixText: 'GJ011685',
//                                         ),
//                                     // controller: emailCtr,
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(top: 25),
//                               child: SizedBox(
//                                 width: 320,
//                                 height: 45,
//                                 child: MaterialButton(
//                                   color: AppColors.primaryColor,
//                                   textColor: AppColors.white,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   onPressed: () {
//                                     setState(() {
//                                       // if (_formKey.currentState!.validate()) {
//                                       //   Fluttertoast.showToast(
//                                       //       msg: "Profile Saved",
//                                       //       toastLength: Toast.LENGTH_SHORT,
//                                       //       gravity: ToastGravity.SNACKBAR,
//                                       //       timeInSecForIosWeb: 1,
//                                       //       backgroundColor: AppColors.cursorcolor,
//                                       //       textColor: Colors.white,
//                                       //       fontSize: 16.0);
//                                       //   Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) => MyProfileScreen()),
//                                       //   );
//                                       // } else {}
//                                     });
//                                   },
//                                   child: Text('Save Profile'),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(top: 25),
//                               child: SizedBox(
//                                 width: 320,
//                                 height: 45,
//                                 child: MaterialButton(
//                                   color: Colors.red[400],
//                                   textColor: AppColors.white,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   onPressed: () {
//                                     setState(() {
//                                       // if (_formKey.currentState!.validate()) {
//                                       //   Fluttertoast.showToast(
//                                       //       msg: "Profile Saved",
//                                       //       toastLength: Toast.LENGTH_SHORT,
//                                       //       gravity: ToastGravity.SNACKBAR,
//                                       //       timeInSecForIosWeb: 1,
//                                       //       backgroundColor: AppColors.cursorcolor,
//                                       //       textColor: Colors.white,
//                                       //       fontSize: 16.0);
//                                       //   Navigator.push(
//                                       //     context,
//                                       //     MaterialPageRoute(
//                                       //         builder: (context) => MyProfileScreen()),
//                                       //   );
//                                       // } else {}
//                                     });
//                                   },
//                                   child: Text('Logout'),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ))),
//               );
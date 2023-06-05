
import 'package:conduit/model/user_data_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';

class UserStateContainer extends StatefulWidget {
  final Widget child;
  final UserData? user;
  final bool isLoggedIn = false;
  UserStateContainer({Key? key, required this.child, this.user})
      : super(key: key);

  @override
  UserStateContainerState createState() => UserStateContainerState();
  static UserStateContainerState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<
            InheritedUserStateContainer>() as InheritedUserStateContainer)
        .data;
  }
}

class UserStateContainerState extends State<UserStateContainer> {
  UserData? user;
  bool isLoggedIn = false;
  AllArticlesRepo repo =  AllArticlesImpl();
  void updateUser({required UserData? userResponseModel}) {
    user = userResponseModel;
    setState(() {
      user = user;
    });
  }

  updateLoggedStatus(bool isLogged) {
    setState(() {
      isLoggedIn = isLogged;
    });
  }

  updateLoggedStatusWithOutStatus(bool value) {
    isLoggedIn = value;
  }

  Future<void> initUser() async {
    repo.getProfileData().then((value) {
      setState(() {
        // user = value;
        isLoggedIn = true;
      });
    }, 
    onError: (error) {
      CToast.instance.showError(context, error.toString());
    }).onError((error, stackTrace) {
      CToast.instance.showError(context, error.toString());
    });
  }

  // Future<bool>
  Future<bool> logOutUser() async {
    try {
      bool message = await repo.logOut();
      // CToast.instance.showSuccess(context, message);
      return true;
    } catch (e) {
      CToast.instance.showError(context, (e as Exception).toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedUserStateContainer(child: widget.child, data: this);
  }
}

class InheritedUserStateContainer extends InheritedWidget {
  final UserStateContainerState data;
  InheritedUserStateContainer({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedUserStateContainer oldWidget) {
    return true;
  }
}

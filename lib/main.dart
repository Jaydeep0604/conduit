import 'package:conduit/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_bloc.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/register_bloc/register_bloc.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/repository/auth_repo.dart';
import 'package:conduit/ui/splash/splash_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAccessDataAdapter());
  await hiveStore.init();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: AppColors.white2,
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: AppColors.white2,
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: AppColors.white2,
  ));

  // ignore: unrelated_type_equality_checks
  if (SystemUiOverlayStyle.light == true) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: AppColors.white2,
    ));
  }

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => LoginBloc(),
    ),
    BlocProvider(
      create: (context) => CommentBloc(repo: AllArticlesImpl()),
    ),
    BlocProvider(
      create: (context) => RegisterBloc(authRepo: AuthRepoImpl()),
    ),
    BlocProvider(
      create: (context) => AllArticlesBloc(repo: AllArticlesImpl()),
    ),
    BlocProvider(
      create: (context) => MyArticlesBloc(repo: AllArticlesImpl()),
    ),
    BlocProvider(
      create: (context) => MyFavoriteArticlesBloc(repo: AllArticlesImpl()),
    ),
    BlocProvider(
      create: (context) => ArticleBloc(repo: AllArticlesImpl()),
    ),
    BlocProvider(
      create: (context) => AddCommentBloc(),
    ),
    BlocProvider(
      create: (context) => ProfileBloc(repo: AllArticlesImpl()),
    ),
  ], child: MyApp()));
}
// void main() {
//   runApp(MultiBlocProvider(
//     providers: [
//       BlocProvider(
//         create: (context) => LoginBloc(),
//       ),
//       BlocProvider(
//         create: (context) => RegisterBloc(authRepo: AuthRepoImpl()),
//       ),
//        BlocProvider(
//         create: (context) => ProfileBloc(),
//       ),
//     ],
//     child: MyApp()));
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

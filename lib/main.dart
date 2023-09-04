import 'package:conduit/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/follow_bloc/follow_bloc.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_bloc.dart';
import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_bloc.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/register_bloc/register_bloc.dart';
import 'package:conduit/bloc/tags_bloc/tags_bloc.dart';
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
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAccessDataAdapter());
  await hiveStore.init();
  // Directory tempDir =
  await getTemporaryDirectory();
  // String tempPath = tempDir.path;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: AppColors.white,
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: AppColors.white,
  ));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: AppColors.white,
  ));

  // ignore: unrelated_type_equality_checks
  if (SystemUiOverlayStyle.light == true) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: AppColors.white,
    ));
  }

  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
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
    BlocProvider(
      create: (context) => TagsBloc(repo: AllArticlesImpl()),
    ),
    BlocProvider(
      create: (context) => LikeBloc(repo: AllArticlesImpl()),
    ),
    BlocProvider(
      create: (context) => FollowBloc(repo: AllArticlesImpl()),
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

      title: 'Conduit',
      // theme: KSTheme.dark,
      home: SplashScreen(),
    );
  }
}

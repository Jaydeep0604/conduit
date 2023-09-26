import 'dart:io';
import 'package:conduit/bloc/follow_bloc/follow_bloc.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_bloc.dart';
import 'package:conduit/config/hive_store.dart';
import 'package:conduit/model/user_model.dart';
import 'package:conduit/navigator/route.dart';
import 'package:conduit/navigator/tab_items.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/ui/splash/splash_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAccessDataAdapter());
  await hiveStore.init();
  if (kIsWeb) {
    setPathUrlStrategy();
    runApp(
      MultiBlocProvider(
        providers: [
          // BlocProvider(
          //   create: (context) => AllArticlesBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => TagsBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => FeedBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => ArticleBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => LoginBloc(repo: AuthRepoImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => CommentBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => RegisterBloc(repo: AuthRepoImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => MyArticlesBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) =>
          //       MyFavoriteArticlesBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => AddCommentBloc(repo: AllArticlesImpl()),
          // ),
          // BlocProvider(
          //   create: (context) => ProfileBloc(repo: AllArticlesImpl()),
          // ),
          BlocProvider(
            create: (context) => LikeBloc(repo: AllArticlesImpl()),
          ),
          BlocProvider(
            create: (context) => FollowBloc(repo: AllArticlesImpl()),
          ),
        ],
        child: MyApp(),
      ),
    );
  }

  Directory tempDir = await getApplicationDocumentsDirectory();

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

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => AllArticlesBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => TagsBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => FeedBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => ArticleBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => LoginBloc(repo: AuthRepoImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => CommentBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => RegisterBloc(repo: AuthRepoImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => MyArticlesBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => MyFavoriteArticlesBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => AddCommentBloc(repo: AllArticlesImpl()),
        // ),
        // BlocProvider(
        //   create: (context) => ProfileBloc(repo: AllArticlesImpl()),
        // ),
        BlocProvider(
          create: (context) => LikeBloc(repo: AllArticlesImpl()),
        ),
        BlocProvider(
          create: (context) => FollowBloc(repo: AllArticlesImpl()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

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
      theme: ThemeData(
          // useMaterial3: true,
          // colorScheme: ColorScheme.fromSwatch()
          //     .copyWith(secondary: AppColors.white2, primary: AppColors.white),
          ),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      // home: SplashScreen(),
      initialRoute: SplashScreen.splashUrl,
      navigatorKey: globalNavigationKey,
      onGenerateRoute: CRoutes.generateGlobalRoute,
    );
  }
}

class ConduitFontFamily {
  static const robotoBlack = "Roboto Black";
  static const robotoBlackItalic = "Roboto BlackItalic";
  static const robotoBold = "Roboto Bold";
  static const robotoBoldItalic = "Roboto BoldItalic";
  static const robotoItalic = "Roboto Italic";
  static const robotoLight = "Roboto Light";
  static const robotoLightItalic = "Roboto LightItalic";
  static const robotoMedium = "Roboto Medium";
  static const robotoMediumItalic = "Roboto MediumItalic";
  static const robotoRegular = "Roboto Regular";
  static const robotoThin = "Roboto Thin";
  static const robotoThinItalic = "Roboto ThinItalic";
}

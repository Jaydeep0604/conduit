import 'package:conduit/bloc/add_comment_bloc/add_comment_bloc.dart';
import 'package:conduit/bloc/all_articles_bloc/all_articles_bloc.dart';
import 'package:conduit/bloc/article_bloc/article_bloc.dart';
import 'package:conduit/bloc/comment_bloc/comment_bloc.dart';
import 'package:conduit/bloc/feed_bloc/feed_bloc_screen.dart';
import 'package:conduit/bloc/follow_bloc/follow_bloc.dart';
import 'package:conduit/bloc/like_article_bloc/like_article_bloc.dart';
import 'package:conduit/bloc/login_bloc/login_bloc.dart';
import 'package:conduit/bloc/my_articles_bloc/my_articles_bloc.dart';
import 'package:conduit/bloc/my_favorite_article_bloc/my_favorite_article_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/register_bloc/register_bloc.dart';
import 'package:conduit/bloc/tags_bloc/tags_bloc.dart';
import 'package:conduit/repository/all_article_repo.dart';
import 'package:conduit/repository/auth_repo.dart';
import 'package:conduit/ui/EditProfile/EditProfile_screen.dart';
import 'package:conduit/ui/add_article/add_article_screen.dart';
import 'package:conduit/ui/base/base_screen.dart';
import 'package:conduit/ui/change_password/change_password_screen.dart';
import 'package:conduit/ui/comments/comments_screen.dart';
import 'package:conduit/ui/feed/yourfeed.dart';
import 'package:conduit/ui/global/global.dart';
import 'package:conduit/ui/global/global_item_detail_screen.dart';
import 'package:conduit/ui/login/login_screen.dart';
import 'package:conduit/ui/profile/profile_screen.dart';
import 'package:conduit/ui/register/register_screen.dart';
import 'package:conduit/ui/splash/splash_screen.dart';
import 'package:conduit/ui/tag_screen/tag_screen.dart';
import 'package:conduit/utils/route_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CRoutes {
  static const globalScreen = GlobalScreen.globalUrl;
  static const yourFeedScreen = YourFeedScreen.yourFeedUrl;
  static const addArticleScreen = AddArticleScreen.addArticleUrl;
  static const commentsScreen = CommentsScreen.commentUrl;
  static const editProfileScreen = CommentsScreen.commentUrl;
  static const profileScreen = ProfileScreen.profileUrl;
  static const tagScreen = TagScreen.tagUrl;

  static generateRoute(BuildContext context, int index,
      {required RouteSettings settings}) {
    Map<int, Widget> routeName = {
      0: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AllArticlesBloc(repo: AllArticlesImpl()),
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
        ],
        child: GlobalScreen(),
      ),
      1: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FeedBloc(repo: AllArticlesImpl()),
          ),
        ],
        child: YourFeedScreen(),
      ),
      2: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ArticleBloc(repo: AllArticlesImpl()),
          ),
        ],
        child: AddArticleScreen(isUpdateArticle: false),
      ),
    };

    return {
      GlobalScreen.globalUrl: (context) => routeName[index]!,
      YourFeedScreen.yourFeedUrl: (context) => YourFeedScreen(),
      AddArticleScreen.addArticleUrl: (context) => AddArticleScreen(
            isUpdateArticle:
                (settings.arguments as Map)['isUpdateArticle'] as dynamic,
            slug: (settings.arguments as Map)['slug'] as dynamic,
          ),
      EditProfileScreen.editProfileUrl: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ProfileBloc(repo: AllArticlesImpl()),
              ),
            ],
            child: EditProfileScreen(),
          ),
      TagScreen.tagUrl: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => TagsBloc(repo: AllArticlesImpl()),
              ),
            ],
            child: TagScreen(
              title: (settings.arguments as Map)['title'] as dynamic,
            ),
          )
    };
  }

  static Route<dynamic> generateGlobalRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.loginUrl:
        return SlideRightRouteWithBuilder(
          builder: (p0, p1, p2) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => LoginBloc(repo: AuthRepoImpl()),
                ),
                BlocProvider(
                  create: (context) => RegisterBloc(repo: AuthRepoImpl()),
                ),
              ],
              child: LoginScreen(),
            );
          },
          settings: settings,
        );
      case RegisterScreen.registerUrl:
        return SlideRightRouteWithBuilder(
          builder: (p0, p1, p2) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => LoginBloc(repo: AuthRepoImpl()),
                ),
                BlocProvider(
                  create: (context) => RegisterBloc(repo: AuthRepoImpl()),
                ),
              ],
              child: RegisterScreen(
                  screenSize:
                      (settings.arguments as Map)['screenSize'] as dynamic),
            );
          },
          settings: settings,
        );
      case GlobalItemDetailScreen.globalItemDetailUrl:
        return SlideRightRouteWithBuilder(
          builder: (p0, p1, p2) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ArticleBloc(repo: AllArticlesImpl()),
                ),
              ],
              child: GlobalItemDetailScreen(
                favorited: (settings.arguments as Map)['favorited'] as dynamic,
                isFollowed:
                    (settings.arguments as Map)['isFollowed'] as dynamic,
                slug: (settings.arguments as Map)['slug'] as dynamic,
                username: (settings.arguments as Map)['username'] as dynamic,
              ),
            );
          },
          settings: settings,
        );
      case ProfileScreen.profileUrl:
        return SlideRightRouteWithBuilder(
            builder: (p0, p1, p2) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ProfileBloc(repo: AllArticlesImpl()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        MyArticlesBloc(repo: AllArticlesImpl()),
                  ),
                  BlocProvider(
                    create: (context) => MyFavoriteArticlesBloc(
                      repo: AllArticlesImpl(),
                    ),
                  ),
                  // BlocProvider(
                  //   create: (context) => LikeBloc(repo: AllArticlesImpl()),
                  // ),
                  // BlocProvider(
                  //   create: (context) => FollowBloc(repo: AllArticlesImpl()),
                  // ),
                ],
                child: ProfileScreen(),
              );
            },
            settings: settings);
      case ChangePasswordScreen.changePasswordUrl:
        return SlideRightRouteWithBuilder(
            builder: (p0, p1, p2) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ProfileBloc(repo: AllArticlesImpl()),
                  ),
                ],
                child: ChangePasswordScreen(),
              );
            },
            settings: settings);
      case AddArticleScreen.addArticleUrl:
        return SlideRightRouteWithBuilder(
            builder: (p0, p1, p2) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ArticleBloc(repo: AllArticlesImpl()),
                  ),
                ],
                child: AddArticleScreen(
                  isUpdateArticle:
                      (settings.arguments as Map)['isUpdateArticle'] as dynamic,
                  slug: (settings.arguments as Map)['slug'] as dynamic,
                ),
              );
            },
            settings: settings);
      case CommentsScreen.commentUrl:
        return SlideRightRouteWithBuilder(
            builder: (p0, p1, p2) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => CommentBloc(repo: AllArticlesImpl()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        AddCommentBloc(repo: AllArticlesImpl()),
                  ),
                ],
                child: CommentsScreen(
                  slug: (settings.arguments as Map)['slug'] as dynamic,
                ),
              );
            },
            settings: settings);
      case BaseScreen.baseUrl:
        return MaterialPageRoute(
            builder: (context) => BaseScreen(), settings: settings);
      case SplashScreen.splashUrl:
        return MaterialPageRoute(
            builder: (context) => SplashScreen(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

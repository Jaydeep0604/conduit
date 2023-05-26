import 'package:conduit/bloc/profile_bloc/profile_bloc.dart';
import 'package:conduit/bloc/profile_bloc/profile_event.dart';
import 'package:conduit/bloc/profile_bloc/profile_state.dart';
import 'package:conduit/ui/favorite/favorite_screen.dart';
import 'package:conduit/ui/my_article/my_article_screen.dart';
import 'package:conduit/ui/setting/setting_screen.dart';
import 'package:conduit/utils/AppColors.dart';
import 'package:conduit/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late ProfileBloc profileBloc;
  bool isLoading = false;
  var _scrollController;

  void initState() {
    super.initState();
    profileBloc = context.read<ProfileBloc>();
    profileBloc.add(FetchProfileEvent());
    _scrollController = ScrollController();
  }

  late final _tabController = TabController(length: 2, vsync: this);

  final pages = [const MyArticlescreen(), FavoriteScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: AppColors.primaryColor2, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileErrorState) {
                  // CToast.instance.showError(context, state.message);
                }
                if (state is ProfileInitialState ||
                    state is ProfileLoadingState) {
                  return CToast.instance.showLoader();
                }
                if (state is ProfileLoadedState) {
                  return Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.white2,
                        border:
                            Border.all(color: AppColors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    '${state.profileList.last.image}',
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "${state.profileList.last.username}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${state.profileList.last.bio}",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SettingScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.settings,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text("Edit Profile Setting"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Divider(),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryColor,
              isScrollable: false,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.text_color,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      "My Articles",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: Container(
                      child: Text("Favorited Articles",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child: Divider(),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MyArticlescreen(),
                  FavoriteScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

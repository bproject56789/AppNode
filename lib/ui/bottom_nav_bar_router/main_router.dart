import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/user_mode.dart';
import 'package:ylc/ui/chat/chat_listing.dart';
import 'package:ylc/ui/consultation/my_consultations.dart';
import 'package:ylc/ui/homepage/drawer.dart';
import 'package:ylc/ui/homepage/homepage.dart';
import 'package:ylc/ui/profile/profile.dart';
import 'package:ylc/values/colors.dart';

class MainRouter extends StatefulWidget {
  @override
  _MainRouterState createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  int currentIndex = 0;
  final key = GlobalKey<ScaffoldState>();

  final List<IconData> bottomIconsData = [
    Icons.home,
    Icons.chat,
    Icons.collections_bookmark_outlined,
    Icons.person,
    Icons.more_horiz,
  ];

  void changeIndex(int i) {
    if (i == 4) {
      key.currentState.openEndDrawer();
      return;
    }
    if (currentIndex != i) {
      setState(() {
        currentIndex = i;
      });
    }
  }

  List<Widget> pages = [
    HomePage(),
    ChatListingPage(),
    MyConsultations(),
    Profile(),
    Container(color: Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      endDrawer: CustomDrawer(
        userMode: Provider.of<UserModel>(context, listen: false).isAdvocate
            ? UserMode.Advocate
            : UserMode.User,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: currentIndex,
        selectedItemColor: YlcColors.categoryBackGround,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(size: 26),
        unselectedIconTheme: IconThemeData(size: 22),
        type: BottomNavigationBarType.fixed,
        onTap: changeIndex,
        items: bottomIconsData
            .map(
              (data) => BottomNavigationBarItem(icon: Icon(data), label: ''),
            )
            .toList(),
      ),
      body: pages[currentIndex],
      // body: UploadDocuments(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/ui/home/home.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _cartKey = GlobalKey();
  GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey,
  };
  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: IndexedStack(
            index: selectedScreenIndex,
            children: [
              _navigator(_homeKey, homeIndex, const HomeScreen()),
              _navigator(
                  _cartKey, cartIndex, const Center(child: Text('CartScreen'))),
              _navigator(_profileKey, profileIndex,
                  const Center(child: Text('ProfileScreen'))),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: selectedScreenIndex,
              onTap: (value) {
                setState(() {
                  _history.remove(selectedScreenIndex);
                  _history.add(selectedScreenIndex);
                  selectedScreenIndex = value;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                    ),
                    label: 'خانه'),
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.cart,
                    ),
                    label: 'سبد خرید'),
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.person,
                    ),
                    label: 'پروفایل')
              ]),
        ));
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                      offstage: selectedScreenIndex != index,
                      child: child,
                    )),
          );
  }
}

import 'package:bloc/bloc.dart';
import 'package:ecommerce/features/home_screen/cubit/home_states.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../tabs/category_tab/category_tab.dart';
import '../../tabs/fav_tab/favs_tab.dart';
import '../../tabs/home_tab/home_tab.dart';
import '../../tabs/profile/profile_tab.dart';

@injectable
class HomeScreenViewModel extends Cubit<HomeStates> {
  static const int categoriesTabIndex = 1;

  HomeScreenViewModel() : super(HomeInitialState());
  int currentIndex = 0;
  final List<Widget> pages = const [
    HomeTab(),
    CategoryTab(),
    FavsTab(),
    ProfileTab(),
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeSelectedIndexState());
  }
}

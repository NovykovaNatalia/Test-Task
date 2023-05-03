import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leads_do_it_test/models/repo.dart';
import 'package:leads_do_it_test/themes/strings.dart';
import 'package:leads_do_it_test/themes/app_colors.dart';
import 'package:leads_do_it_test/themes/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'home_screen.dart';
import '../main.dart';

const _kActiveCheckboxIcon = 'assets/imgs/favorite_active.svg';
const _kInactiveCheckboxIcon = 'assets/imgs/favorite_not_active.svg';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  // var favoriteList = ["one", "two", "three"];
  // List<bool> _checked = List.filled(5, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.main,
        child: Column(
          children: [
            _buildTopping(),
            _buildBody()],
        ),
      ),
    );
  }

  Widget _buildTopping() {
    return AppBar(
      elevation: 1,
      backgroundColor: AppColors.main,
      title: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                },
                child: SvgPicture.asset(
                  'assets/imgs/btn.svg',
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                Strings.appName,
                style: Styles.textHeader,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: ListView.builder(
        itemCount: favoriteList.length,
        itemBuilder: (BuildContext context, int index) {
          Repo repo = favoriteList[index];
          return Card(
            child: ListTile(
              title: Text(repo.name),
              subtitle: Text(repo.owner),
              trailing: IconButton(
                icon:repo.isFavorite
                    ? SvgPicture.asset(
                  'assets/imgs/favorite_active.svg',
                )
                    : SvgPicture.asset(
                  'assets/imgs/favorite_not_active.svg',
                ),
                onPressed: () {
                  setState(() {
                        repo.isFavorite =
                        !repo.isFavorite;
                    repo.isFavorite = false;
                    favoriteList.remove(repo);
                  });
                  saveFavoriteList();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void saveFavoriteList() async {   //TODO: all sp operations in one utils file
    var prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(favoriteList.map((repo) => repo.toJson()).toList());
    await prefs.setString('favorite_list', json);
  }
}

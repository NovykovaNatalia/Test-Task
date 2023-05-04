import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leads_do_it_test/bloc/home/home_bloc.dart';
import 'package:leads_do_it_test/bloc/home/home_event.dart';
import 'package:leads_do_it_test/models/repo.dart';
import 'package:leads_do_it_test/themes/strings.dart';
import 'package:leads_do_it_test/themes/app_colors.dart';
import 'package:leads_do_it_test/themes/styles.dart';

import '../bloc/home/home_state.dart';
import '../themes/images.dart';

class FavouriteScreen extends StatefulWidget {
  final HomeBloc bloc;

  const FavouriteScreen(this.bloc, {Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => widget.bloc,
        child: Scaffold(
          body: Container(
            color: AppColors.main,
            child: Column(
              children: [
                _buildTopping(),
                _buildBody(),
              ],
            ),
          ),
        ));
  }

  Widget _buildTopping() {
    return AppBar(
      automaticallyImplyLeading: false, // add this line
      elevation: 1,
      backgroundColor: AppColors.main,
      title: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(Images.btnIcon),
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
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: widget.bloc,
        builder: (context, state) {
          return Expanded(
            child: ListView.builder(
              itemCount: state.favoriteList.length,
              itemBuilder: (BuildContext context, int index) {
                Repo repo = state.favoriteList[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.layer_1,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(repo.name),
                    subtitle: Text(repo.owner),
                    trailing: IconButton(
                      icon: repo.isFavorite
                          ? SvgPicture.asset(Images.activeCheckboxIcon)
                          : SvgPicture.asset(Images.inactiveCheckboxIcon),
                      onPressed: () {
                        widget.bloc.add(ChangeFavoriteByIndexEvent(repo));
                      },
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

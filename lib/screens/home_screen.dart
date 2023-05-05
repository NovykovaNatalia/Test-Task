import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:leads_do_it_test/bloc/home/home_event.dart';
import 'package:leads_do_it_test/bloc/home/home_state.dart';
import 'package:leads_do_it_test/screens/favorites_screen.dart';
import 'package:leads_do_it_test/themes/strings.dart';
import 'package:leads_do_it_test/themes/app_colors.dart';
import 'package:leads_do_it_test/themes/styles.dart';

import '../bloc/home/home_bloc.dart';
import '../widgets/custom_search_field.dart';
import '../themes/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _bloc;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _bloc = HomeBloc();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => _bloc,
        child: Scaffold(
          appBar: _buildTopping(),
          body: _buildBody(),
        ));
  }

  Column _buildBody() {
    return Column(
      children: [
        _buildSearchField(),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 18, bottom: 18),
            child: BlocBuilder<HomeBloc, HomeState>(
                bloc: _bloc,
                builder: (context, state) {
                  return Text(
                    state.searchResults.isEmpty
                        ? 'Search history'
                        : 'What we have found',
                    style: Styles.textHistory,
                  );
                }),
          ),
        ),
        BlocBuilder<HomeBloc, HomeState>(
            bloc: _bloc,
            builder: (context, state) {
              return state.searchQuery.isEmpty || state.searchResults.isEmpty
                  ? showSearchHistory()
                  : showFoundResults();
            }),
      ],
    );
  }

  Widget showFoundResults() {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _bloc,
      builder: (context, state) {
        return state.searchResults.isEmpty
            ? Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17),
                    child: Center(
                      child: Text(
                        Strings.noSearchResults,
                        style: Styles.hintText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: state.searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.layer_1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          _bloc.add(
                            ChangeFavoriteByIndexEvent(
                              state.searchResults[index],
                            ),
                          );
                        },
                        child: ListTile(
                          trailing: InkWell(
                            child: state.searchResults[index].isFavorite
                                ? SvgPicture.asset(Images.activeCheckboxIcon)
                                : SvgPicture.asset(Images.inactiveCheckboxIcon),
                            onTap: () {
                              _bloc.add(
                                ChangeFavoriteByIndexEvent(
                                  state.searchResults[index],
                                ),
                              );
                            },
                          ),
                          title: Text(state.searchResults[index].name),
                        ),
                      ),
                    );
                  },
                ),
              );
      },
    );
  }

  Widget showSearchHistory() {
    return BlocBuilder<HomeBloc, HomeState>(
        bloc: _bloc,
        builder: (context, state) {
          return Expanded(
              child: ListView.builder(
                  itemCount: state.searchHistory.queries.length,
                  itemBuilder: (BuildContext context, int index) {
                    final reversedIndex =
                        state.searchHistory.queries.length - index - 1;
                    return ListTile(
                      title: Text(
                          state.searchHistory.queries[reversedIndex].query),
                      subtitle: Text(state
                          .searchHistory.queries[reversedIndex].timeStamp
                          .toString()),
                    );
                  }));
        });
  }

  AppBar _buildTopping() {
    return AppBar(
      elevation: 1,
      backgroundColor: AppColors.main,
      title: Row(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                Strings.appName,
                style: Styles.textHeader,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => FavouriteScreen(_bloc)),
                  );
                },
                child: SvgPicture.asset(Images.favoritesIcon),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
        child: SearchField(
          onCloseTap: () {
            _bloc.add(ClearSearchQueryEvent());
          },
          onTextChanged: (text) {
            _bloc.add(ChangeSearchQueryEvent(text));
          },
          onTextSubmitted: () {
            _bloc.add(SearchTextEvent());
          },
        ));
  }
}

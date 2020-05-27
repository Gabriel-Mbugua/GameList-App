import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:loading_animations/loading_animations.dart';

import 'package:rawgapiimplementation/models/game.dart';
import '../api_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();
  bool _isSwitched = false;
  List<Game> _gamesList;
  List<Game> games;

  @override
  void didChangeDependencies() {
    _fetchData();
    super.didChangeDependencies();
  }

  Future<void> _fetchData() async {
    _isLoading = true;
    final apiService = APIService();
    games = await apiService.getGames();
    setState(() {
      _gamesList = games;
//      _isLoading = false;
    });
  }

  onItemChanged(String value) {
    setState(() {
      _gamesList = games.where(
          (game) => game.name.toLowerCase().contains(value.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _gamesList == null
//            ? Center(child: CircularProgressIndicator(strokeWidth: 2,))
            ? Center(child: LoadingJumpingLine.square(backgroundColor: Colors.red,))
            : NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxIsScrolled){
              return <Widget> [
                SliverAppBar(
                  title: Text("Games"),
                  floating: true,
                  backgroundColor: Colors.transparent,
                ),
              ];
            },
              body: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Search for a game",
                          suffixIcon: Icon(Icons.search),
                          border: InputBorder.none
                        ),
                        onChanged: (string) {
                          setState(() {
                            _gamesList = games
                                .where((game) => (game.name
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                                .toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _gamesList.length,
                        itemBuilder: (ctx, i) {
                          return Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: FadeInImage(
                                      image: NetworkImage(_gamesList[i].imageUrl),
                                      placeholder: AssetImage(
                                          "assets/controller_placeholder.png"),
                                    ),
                                  ),
                                  ExpandablePanel(
                                    hasIcon: true,
                                    iconColor: Colors.white,

                                    header: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _gamesList[i].name,
                                          style:
                                              Theme.of(context).textTheme.headline5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Rating: ${_gamesList[i].rating.toString()}",
                                          style:
                                              Theme.of(context).textTheme.headline6,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    expanded: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Released: ${_gamesList[i].released.toString()}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "PlayTime: ${_gamesList[i].playtime.toString()} hrs",
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

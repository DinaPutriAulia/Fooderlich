import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/material/icons.dart';

class Search extends SearchDelegate<String> {
  List<String> searchHistory = [];

  void addSearchHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('browseHistory') ?? [];
    searchHistory.insert(0, value);
    await prefs.setStringList('browseHistory', searchHistory);
  }

  void getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('browseHistory') ?? [];
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query != '') addSearchHistory(query);
    return Center(
      child: Text(
        'search not found',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    getSearchHistory();
    final count = searchHistory.length > 10 ? 10 : searchHistory.length;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(searchHistory.elementAt(index)),
          trailing: const Icon(Icons.north_west),
        );
      },
    );
  }
}

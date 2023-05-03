class SearchQuery {
  String query;
  DateTime timeStamp;

  SearchQuery(this.query, this.timeStamp);

  Map<String, dynamic> toJson() => {
    'query': query,
    'timeStamp': timeStamp.toIso8601String(),
  };

  static SearchQuery fromJson(Map<String, dynamic> json) => SearchQuery(
    json['query'],
    DateTime.parse(json['timeStamp']),
  );
}

class SearchHistory {   //TODO: mb we should find anotations like lomboc for json convertions
  List<SearchQuery> queries;

  SearchHistory({required this.queries});

  Map<String, dynamic> toJson() => {
    'queries': queries.map((query) => query.toJson()).toList(),
  };

  static SearchHistory fromJson(Map<String, dynamic> json) => SearchHistory(
    queries: (json['queries'] as List<dynamic>)
        .map((query) => SearchQuery.fromJson(query))
        .toList(),
  );
}
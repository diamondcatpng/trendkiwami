import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';

class Word {
  final String title;
  final DateTime updatedAt;
  final double score;
  final String chart;

  const Word({this.title, this.updatedAt, this.score, this.chart});
}

class SearchEngine {
  final String name;
  final Icon icon;
  final String pattern;

  const SearchEngine({this.name, this.icon, this.pattern});
}

class WordDetailsWidget extends StatelessWidget {
  final Word word;
  final List<SearchEngine> _engineList = const [
    SearchEngine(
      name: "Google",
      icon: Icon(BrandIcons.google),
      pattern: "https://www.google.com/search?q=@query&tbs=qdr:d",
    ),
    SearchEngine(
      name: "Yahoo! JAPAN",
      icon: Icon(BrandIcons.yahoo),
      pattern: "https://search.yahoo.co.jp/search?p=@query&vd=d",
    ),
    SearchEngine(
      name: "Twitter",
      icon: Icon(BrandIcons.twitter),
      pattern: "https://twitter.com/search?q=@query",
    ),
    SearchEngine(
      name: "YouTube",
      icon: Icon(BrandIcons.youtube),
      pattern:
          "https://www.youtube.com/results?search_query=@query&sp=EgQIAhAB",
    ),
  ];

  const WordDetailsWidget({this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.title),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Image.network(
            word.chart,
            alignment: Alignment.center,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return CircularProgressIndicator();
            },
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _engineList.length,
              itemBuilder: (context, index) {
                final engine = _engineList.elementAt(index);

                return ListTile(
                  leading: engine.icon,
                  title: Text('${engine.name} で検索'),
                  onTap: () async {
                    final query = Uri.encodeQueryComponent(word.title);
                    final url = engine.pattern.replaceAll("@query", query);

                    print(url);
                    await launch(url);
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class WordWidget extends StatelessWidget {
  final _url = 'https://trendkiwami.github.io/api/word.json';

  List<Word> _parseJson(List<dynamic> json) {
    return json.map((entry) {
      return Word(
        title: entry['title'],
        updatedAt: DateTime.parse(entry['updated_at']),
        score: entry['score'],
        chart: entry['chart'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ja', timeago.JaMessages());

    return FutureBuilder(
      future: http.get(_url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final json = jsonDecode(snapshot.data.body);
          final wordList = _parseJson(json);

          return ListView.separated(
            itemCount: wordList.length,
            itemBuilder: (context, index) {
              final rank = index + 1;
              final word = wordList.elementAt(index);
              final moment = timeago.format(word.updatedAt, locale: 'ja');

              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            '$rank',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Text(
                            word.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${word.score} スコア / $moment',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  final route = MaterialPageRoute(builder: (context) {
                    return WordDetailsWidget(word: word);
                  });
                  Navigator.of(context).push(route);
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),
            padding: EdgeInsets.symmetric(vertical: 8),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}

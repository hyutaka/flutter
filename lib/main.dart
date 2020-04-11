// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
//import 'package:flutter/semantics.dart';  // Add this line.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // int _count = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
      ),
      home: RandomWords(),
    );
    /*
    final wordPair = WordPair.random();
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter!'),
        ),
        body: Center(
          // child: Text('Hello Mundo'),
          // child: Text(wordPair.asPascalCase),
          child: RandomWords(),
        ),
        floatingActionButton: FloatingActionButton (
          onPressed: () {},
          tooltip: 'Aperta ai!',
          child: const Icon(Icons.add), 
          ),
      ),
    );
    */
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    //final WordPair wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase + '/'+ _count.toString());
    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
          _buildButtonColumn(color, Icons.share, 'SHARE'),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup name generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
      drawer: Drawer(
          child: ListView (
            children: <Widget>[
              DrawerHeader(child: Text('Drawer Header'),
                decoration: BoxDecoration( color: Colors.blue),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Item 1'),
                onTap: () {
                  // ToDo
                  Navigator.pop(context);
                }),
              ListTile( 
                leading: Icon(Icons.settings),
                title: Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                }
              )
            ],
          ) ,
        ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        //child: Container(height: 50.0,),
        child: buttonSection,
      ),
      floatingActionButton: 
      // https://stackoverflow.com/questions/53922053/how-to-properly-display-a-snackbar-in-flutter
        Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              setState(() {
                _suggestions.addAll(generateWordPairs().take(10));
              });
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  backgroundColor: Colors.blue,
                  content: new Text('Adicionado mais 10'),
                ),
              );
        
            },
            tooltip: 'Aperta ai!',
            child: const Icon(Icons.add),
          );
        }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suggestions.length,
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }

        final int index = i ~/ 2;
        if (index >= _suggestions.length) {
          //_suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index], index);
      },
    );
  }

  Widget _buildRow(WordPair pair, int i) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        i.toString() + ' - ' + pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          ); // ... to here.
        },
      ), // ... to here.
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

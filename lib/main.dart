import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  double poids;
  bool genre = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: setColor(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              texeAvecStyle(
                  "Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
              new Card(
                elevation: 10,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        texeAvecStyle("femme", color: Colors.pink),
                        new Switch(
                          value: genre,
                          inactiveTrackColor: Colors.pink,
                          activeTrackColor: Colors.blue,
                          onChanged: (bool b) {
                            setState(() {
                              genre = b;
                            });
                          },
                        ),
                        texeAvecStyle("homme", color:Colors.blue),
                      ],
                    ),
                    new TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String string) {
                        setState(() {
                          poids = double.tryParse(string);
                        });
                      },
                      decoration: new InputDecoration(
                        labelText: "Entrez votre poids en kilos"
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text texeAvecStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    return new Text(data,
        textAlign: TextAlign.center,
        style: new TextStyle(color: color, fontSize: fontSize));
  }

  Color setColor() {
    if (genre) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }
}

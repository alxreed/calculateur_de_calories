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
  int radioSelectionnee;
  Map mapActivite = {0: "Faible", 1: "Moderee", 2: "Forte"};
  int calorieBase;
  int calorieAvecActivite;
  bool genre = false;
  double age;
  double taille = 170.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: setColor(),
        ),
        body: new SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              padding(),
              texeAvecStyle(
                  "Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
              padding(),
              new Card(
                elevation: 10,
                child: new Column(
                  children: <Widget>[
                    padding(),
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
                        texeAvecStyle("homme", color: Colors.blue),
                      ],
                    ),
                    padding(),
                    new RaisedButton(
                      color: setColor(),
                      onPressed: (() => montrerPicker()),
                      child: texeAvecStyle(
                          (age == null)
                              ? "Appuyer pour entrer votre âge"
                              : "Votre âge est de ${age.toInt()}",
                          color: Colors.white),
                    ),
                    padding(),
                    texeAvecStyle("Votre taille est de ${taille.toInt()} cm",
                        color: setColor()),
                    padding(),
                    new Slider(
                      value: taille,
                      onChanged: (double d) {
                        setState(() {
                          taille = d;
                        });
                      },
                      activeColor: setColor(),
                      max: 215.0,
                      min: 100,
                    ),
                    padding(),
                    new TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String string) {
                        setState(() {
                          poids = double.tryParse(string);
                        });
                      },
                      decoration: new InputDecoration(
                          labelText: "Entrez votre poids en kilos"),
                    ),
                    padding(),
                    texeAvecStyle("Quel est votre activité sportive ?",
                        color: setColor()),
                    padding(),
                    rowRadio(),
                    padding()
                  ],
                ),
              ),
              padding(),
              new RaisedButton(
                color: setColor(),
                child: texeAvecStyle("Calculer", color: Colors.white),
                onPressed: calculerNombreDeCalories,
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

  Padding padding() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
    );
  }

  Row rowRadio() {
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            activeColor: setColor(),
            value: key,
            groupValue: radioSelectionnee,
            onChanged: (Object i) {
              setState(() {
                radioSelectionnee = i;
              });
            },
          ),
          texeAvecStyle(value, color: setColor()),
        ],
      );
      l.add(colonne);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  Future<Null> montrerPicker() async {
    DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
        initialDatePickerMode: DatePickerMode.year);
    if (choix != null) {
      var difference = new DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = (jours / 365);
      setState(() {
        age = ans;
      });
    }
  }

  void calculerNombreDeCalories() {
    if (age != null && poids != null && radioSelectionnee != null) {
      // calculer
      if (genre) {
        calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
      } else {
        calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
      }
      switch(radioSelectionnee) {
        case 0:
          calorieAvecActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;
      }

      setState(() {
        dialogue();
      });
    } else {
      //Alerte ya pas tous
      alerte();
    }
  }

  Future<Null> dialogue() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return SimpleDialog(
          title: texeAvecStyle("Votre besoin en calories", color: setColor()),
          contentPadding: EdgeInsets.all(15.0),
          children: <Widget>[
            padding(),
            texeAvecStyle("Votre besoin de base est de: $calorieBase"),
            padding(),
            texeAvecStyle("Votre besoin avec activité sportive est de: $calorieAvecActivite"),
            new RaisedButton(
              onPressed: () {
                Navigator.pop(buildContext);
              },
              child: texeAvecStyle("OK", color: Colors.white),
              color: setColor(),
            )
          ],
        );
      }
    );
  }

  Future<Null> alerte() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return new AlertDialog(
          title: texeAvecStyle("Erreur"),
          content: texeAvecStyle("Tous les champs ne sont pas remplis"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(buildContext);
              },
              child: texeAvecStyle("OK", color: Colors.red),
            )
          ],
        );
      }
    );
  }
}

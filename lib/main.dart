import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}


class cocktail {

  final String drinkID;
  final String drinkName;
  final String isAlcholic;
  final String glassType;
  final String DrinkInstructions;
  final String drinkImage;

  const cocktail({required this.drinkID, required this.drinkName,required this.isAlcholic, required this.glassType,
  required this.DrinkInstructions, required this.drinkImage});

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Cocktail Findr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  String _responseText = '';
  cocktail currentCocktail = cocktail(drinkID: "", drinkName: '', isAlcholic: "" , glassType: "", DrinkInstructions: "", drinkImage: "");
  String _imageLink = '';

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php/1'));

    if (response.statusCode == 200) {
      setState(() {
        String thumb = "";



        List<String> body = json.decode(response.body)['drinks'].toString().split(RegExp("\":\"|:|, str"));
        //print(body);
        for(int i = 0; i < body.length; i++){
           if(body[i].contains("DrinkThumb")){
            String temp = (body[i+1] + ":" + body[i+2]);
            thumb = temp;
          }
        }

        String ID = body[2];
        cocktail Response = new cocktail(drinkID: ID, drinkName: body[3], isAlcholic: body[15], glassType: body[17], DrinkInstructions: body[19], drinkImage: thumb);
        _responseText += Response.drinkName + Response.isAlcholic + Response.glassType + Response.DrinkInstructions;
        currentCocktail = Response;
        _imageLink = Response.drinkImage;

       /* for(int i = 0; i < body.length; i++){
          print('${body[i]} + number: ${i}');

        }
*/
      });
    } else {
      setState(() {
        _responseText = 'Error fetching data';
      });
    }
  }
  String _counter = '';
  late Future<cocktail> futureCocktail;


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      fetchData();
      _counter = '';
      _counter += _responseText;



    });
  }


  @override
  void initstate(){
    super.initState();

  }
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.


        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            if(_imageLink != '')Image.network(_imageLink.trim()),
            if(currentCocktail.drinkName != '')Text(
              '${currentCocktail.drinkName}',
              style: Theme.of(context).textTheme.headlineMedium,

            ), if(currentCocktail.DrinkInstructions != '')Text(
              '${currentCocktail.DrinkInstructions}', style: Theme.of(context).textTheme.bodyLarge,),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),

      ),  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

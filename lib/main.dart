import 'package:cst2335_final_project/airplanes/airplanes_page.dart';
import 'package:flutter/material.dart';
import 'package:cst2335_final_project/airplanes/airplanes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
    '/airplanespage': (context) => AirplanesPage(),
    },

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void navigateToAirplanesPage() {
      Navigator.pushNamed(context, "/airplanespage");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Row(
              children: [
                ElevatedButton(
                    onPressed: navigateToAirplanesPage,
                    child: Text("Airplane page") )
              ],
          )
        ],
        ),
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

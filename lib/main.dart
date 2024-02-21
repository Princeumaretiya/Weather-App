import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky/provider/provider.dart';
import 'package:sky/views/SplashScreen.dart';


void main() => runApp(
      const MyApp(),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => providers(),
        )
      ],
      builder: (context, child) => MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: Provider.of<providers>(context).themeDetails.isdark
            ? ThemeMode.light
            : ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: splashScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_01/bloc/background_image_bloc.dart';
import 'package:practica_01/bloc/timezone_bloc.dart';
import 'package:practica_01/home_page.dart';

import 'bloc/quote_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica 01',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<QuoteBloc>(
            create: (context) => QuoteBloc(),
          ),
          BlocProvider<TimezoneBloc>(
            create: (context) => TimezoneBloc(),
          ),
          BlocProvider<BackgroundImageBloc>(
            create: (context) => BackgroundImageBloc(),
          )
        ],
        child: HomePage(),
      ),
    );
  }
}

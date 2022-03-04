import 'dart:io';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_01/bloc/bloc/quote_bloc.dart';
import 'package:http/http.dart';
import 'package:practica_01/bloc/timezone_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List countryNameList = ["Andorra", "Mexico", "Peru", "Canada", "Argentina"];
  List flagList = ["ad", "mx", "pe", "ca", "ar"];

  getCountryImages() async {
    for (int i = 0; i < flagList.length; i++) {
      var flagUrl = await get(
        Uri.parse('https://flagcdn.com/32x24/${flagList[i]}.png'),
      );
    }
  }

  @override
  void initState() {
    BlocProvider.of<QuoteBloc>(context).add(GetQuoteEvent());
    BlocProvider.of<TimezoneBloc>(context).add(GetTimeZoneEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
        appBar: BackdropAppBar(
          title: Text("La Frase Diaria"),
          actions: [],
        ),
        backLayer: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Text(flagList[index]),
              title: Text(
                countryNameList[index],
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                BlocProvider.of<QuoteBloc>(context).add(GetQuoteEvent());
              },
            );
          },
        ),
        frontLayer: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black54, BlendMode.multiply),
                image: NetworkImage('https://picsum.photos/720/1080'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    BlocConsumer<TimezoneBloc, TimezoneState>(
                        builder: (context, state) {
                      return Text("HORA");
                    }, listener: (context, state) {
                      if (state is TimeZoneErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${state.errorMsg}"),
                          ),
                        );
                      }
                    }),
                  ],
                ),
                BlocConsumer<QuoteBloc, QuoteState>(
                  listener: (context, state) {
                    if (state is QuoteErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${state.errorMsg}"),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is QuoteSuccessState) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ListTile(
                                title: Text(
                                  state.url[index]["q"],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                                subtitle: Text(
                                  "- ${state.url[index]["a"]}",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 20),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

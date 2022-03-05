import 'dart:io';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:practica_01/bloc/quote_bloc.dart';
import 'package:practica_01/bloc/timezone_bloc.dart';

import 'bloc/background_image_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List countryNameList = ["Andorra", "Mexico", "Peru", "Canada", "Argentina"];
  List flagList = [
    "https://flagcdn.com/32x24/ad.png",
    "https://flagcdn.com/32x24/mx.png",
    "https://flagcdn.com/32x24/pe.png",
    "https://flagcdn.com/32x24/ca.png",
    "https://flagcdn.com/32x24/ar.png",
  ];
  List timezoneRegion = [
    "Europe/Andorra",
    "America/Mexico_City",
    "America/Lima",
    "America/Vancouver",
    "America/Argentina/Buenos_Aires"
  ];
  List flagFiles = [];

  @override
  void initState() {
    BlocProvider.of<BackgroundImageBloc>(context).add(GetBackgroundEvent());
    BlocProvider.of<QuoteBloc>(context).add(GetQuoteEvent());
    BlocProvider.of<TimezoneBloc>(context).add(
      GetTimeZoneEvent(
        timeZoneRegion: timezoneRegion[1],
        countryName: countryNameList[1],
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
        headerHeight: 500,
        appBar: BackdropAppBar(
          title: Text("La Frase Diaria"),
          actions: [],
        ),
        backLayer: Container(
          height: 230,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: ClipRRect(
                  child: Container(
                    child: Image(
                        image: NetworkImage(
                      flagList[index],
                    )),
                  ),
                ),
                title: Text(
                  countryNameList[index],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onTap: () {
                  BlocProvider.of<BackgroundImageBloc>(context)
                      .add(GetBackgroundEvent());
                  BlocProvider.of<QuoteBloc>(context).add(GetQuoteEvent());
                  BlocProvider.of<TimezoneBloc>(context).add(GetTimeZoneEvent(
                      timeZoneRegion: timezoneRegion[index],
                      countryName: countryNameList[index]));
                },
              );
            },
          ),
        ),
        frontLayer: Container(child: frontLayer()));
  }
}

Stack frontLayer() {
  return (Stack(alignment: Alignment.topCenter, children: <Widget>[
    Container(
        child: BlocConsumer<BackgroundImageBloc, BackgroundImageState>(
            builder: ((context, state) {
              if (state is BackgroundImageErrorState) {
                return Text("Image error");
              } else if (state is BackgroundImageSuccessState) {
                return Image.network(
                  state.url,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
            listener: ((context, state) {}))),
    Container(
      decoration: BoxDecoration(
        color: Colors.black38,
      ),
    ),
    Center(
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: BlocConsumer<TimezoneBloc, TimezoneState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is TimeZoneSuccessState) {
                    return Column(
                      children: [
                        Text(state.country,
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        Text(
                          "${state.url["datetime"]}".substring(11, 19),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 45),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 30),
              child: BlocConsumer<QuoteBloc, QuoteState>(
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
            ),
          ],
        ),
      ),
    ),
  ]));
}

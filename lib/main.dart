import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  int minutes = 0, seconds = 0, milliseconds = 0;
  String digitMinutes = "00", digitSeconds = "00", digitMilliseconds = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      started = false;
      seconds = 0;
      minutes = 0;
      milliseconds = 0;

      digitMilliseconds = "00";
      digitMinutes = "00";
      digitSeconds = "00";

      laps.clear();
    });
  }

  void addLaps() {
    String lap = "$digitMinutes:$digitSeconds.$digitMilliseconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start() {
    started = true;
    if (started) {
      timer = Timer.periodic(Duration(milliseconds: 2), (timer) {
        int localMilliseconds = milliseconds + 1;
        int localSeconds = seconds;
        int localMinutes = minutes;

        if (localMilliseconds > 99) {
          if (localSeconds > 59) {
            localMinutes++;
            localSeconds = 0;
          } else {
            localSeconds++;
            localMilliseconds = 0;
          }
        }
        setState(() {
          milliseconds = localMilliseconds;
          seconds = localSeconds;
          minutes = localMinutes;

          digitMilliseconds =
              (seconds >= 10) ? "$milliseconds" : "$milliseconds";
          digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
          digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "StopWatch",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: false,
        ),
        body: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "$digitMinutes:$digitSeconds.$digitMilliseconds",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 100, right: 100),
            height: 300,
            width: double.maxFinite,
            //color: Colors.grey,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: ListView.builder(
              itemCount: laps.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        "${laps[index]}",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(side: BorderSide.none),
                    fixedSize: Size(70, 70),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(0),
                  ),
                  onPressed: () {
                    (!started) ? start() : stop();
                  },
                  child: Icon(
                    (!started) ? Icons.play_arrow_outlined : Icons.pause,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.only(
                  top: 100,
                ),
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(side: BorderSide.none),
                    fixedSize: Size(70, 70),
                    alignment: Alignment.center,

                    padding: EdgeInsets.all(5),
                    // backgroundColor: Colors.transparent
                  ),
                  onPressed: () {
                    (!started) ? reset() : addLaps();
                  },
                  child: Icon(
                    applyTextScaling: true,
                    (!started) ? Icons.replay_outlined : Icons.flag,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ]),
        bottomNavigationBar: Container(
            height: 62,
            child: BottomNavigationBar(
              elevation: 50,
              currentIndex: 2,
              selectedItemColor: Colors.blue,
              items: [
                BottomNavigationBarItem(
                  tooltip: "data",
                  icon: Icon(
                    Icons.alarm_outlined,
                  ),
                  label: "Alarm",
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.transparent,
                  icon: Icon(
                    Icons.punch_clock_outlined,
                  ),
                  label: "World Clock",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer_outlined),
                  label: "Stopwatch",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.av_timer_outlined),
                  label: "Timer",
                )
              ],
              onTap: (int index) {
                setState(() {});
              },
            )));
  }
}

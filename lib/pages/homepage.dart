// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:airadio/model/radio.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<MyRadio>? radios;
  late MyRadio selectedRadio;
  late Color selectedColor;
  late bool isPlaying = false;

  //final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    fetchRadios();
    super.initState();
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    //selectedRadio = radios[0];
    //selectedColor = Color(int.tryParse(_selectedRadio.color));
    print(radios);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(
                  colors: [Colors.lightBlue, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight))
              .make(),
          AppBar(
            title: "AI Radio".text.xl4.bold.white.make().shimmer(
                primaryColor: Vx.purple300, secondaryColor: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(100.0).p16(),
          VxSwiper.builder(
            enlargeCenterPage: true,
            aspectRatio: 1,
            itemCount: radios!.length,
            itemBuilder: (context, index) {
              final rad = radios![index];
              return VxBox(
                child: ZStack(
                  [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: VxBox(
                        child: rad.category.text.uppercase.white.make().px16(),
                      )
                          .alignCenter
                          .height(40)
                          .black
                          .withRounded(value: 10)
                          .make(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: VStack(
                        [
                          rad.name.text.xl3.white.bold.make(),
                          5.heightBox,
                          rad.tagline.text.sm.white.semiBold.make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: [
                        Icon(
                          CupertinoIcons.play_circle,
                          color: Colors.white,
                        ),
                        10.heightBox,
                        "Double tap to play".text.gray300.make(),
                      ].vStack(),
                    )
                  ],
                  //clip: Clip.antiAlias,
                ),
              )
                  .clip(Clip.antiAlias)
                  .bgImage(
                    DecorationImage(
                      image: NetworkImage(rad.image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ),
                  )
                  .border(color: Colors.black, width: 5.0)
                  .withRounded(value: 60)
                  .make()
                  .p16()
                  .onInkDoubleTap(() {});
            },
          ).centered(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              CupertinoIcons.stop_circle,
              color: Colors.white,
              size: 50,
            ),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}

import 'dart:async';

import 'package:celebral_app/upload_image_screen.dart';
import 'package:flutter/material.dart';

class SplashScren extends StatefulWidget {
  const SplashScren({super.key});

  @override
  State<SplashScren> createState() => _SplashScrenState();
}

class _SplashScrenState extends State<SplashScren> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context)=> ImageUploadScreen())
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          color: Colors.white,
          child: Center(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 150,),
                  Center(
                    child: Container(
                      height: 250,
                      width: 250,
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(0),
                      //
                      // ),
                      child: Image.asset('assets/logo.jpg'),
                    ),
                  ),
                ],
              )

          ),
        )
    );
  }
}

import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  var blueColor = Color(0xFF090e42);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blueColor,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ListView(shrinkWrap: true, children: <Widget>[
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: 60.0,
                                    width: 60.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/google_logo.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              //Spacer(),
                            ],
                          ),
                        ),
                        onTap: (){print("Clicked A");},
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: 60.0,
                                    width: 60.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/facebook_logo.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  "Sign in with Facebook",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              //Spacer(),
                            ],
                          ),
                        ),
                        onTap: (){print("Clicked B");},
                      ),
                    ])),
              ]),
        ));
  }
}

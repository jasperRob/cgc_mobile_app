/*
  Introduction page with animation of moving images
  and buttons navigating to login and sign up
 */
import 'package:flutter/material.dart';
import 'login.dart';

class IntroPage extends StatefulWidget {

  IntroPage();

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));

    _backgroundAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();

              //_animationController.reverse();
            }
          });

    _animationController.forward();
    //_animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _signUpButton() {
    print("PUSHED");
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           SignUp(sessionToken: widget.sessionToken, userData: widget.userData)),
    // );
  }

  void _logInButton() {
//dispose();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //precacheImage(AssetImage("images/golfBG1.jpg"), context);

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/marnong_estate_the_view.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(_backgroundAnimation.value, 0),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                    padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    alignment: Alignment(0.0, -0.5),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/marnong_estate_header_logo.png',
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 140,
                          //height: MediaQuery.of(context).size.height,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  //margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Text(
                    'Compact Golf Course',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      //letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  child: RaisedButton(
                    child: Text('Log In'),
                    color: Color.fromRGBO(215, 188, 141, 1.0),
                    onPressed: _logInButton,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  child: RaisedButton(
                    child: Text('Sign Up'),
                    color: Color.fromRGBO(215, 188, 141, 1.0),
                    onPressed: _signUpButton,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

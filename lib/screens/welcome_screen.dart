import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/rounded_button.dart';
import 'login_screen.dart';




class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  ///used for named rout navigation
  static const String id = '/';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white
    ).animate(controller);
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.forward();
/*    animation.addStatusListener((status) {
      print(status);
      if(status == AnimationStatus.completed){
        controller.reverse(from: 1.0);
      }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });*/
    controller.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                 AnimatedTextKit(
                   animatedTexts: [
                     TypewriterAnimatedText(
                       speed: const Duration(milliseconds:250),
                       'Flash Chat',
                       textStyle:const TextStyle(
                       fontSize: 45.0,
                       fontWeight: FontWeight.w900,
                     ), )
                   ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),

            ///Login Button
            RoundedButton(colour: Colors.lightBlueAccent,title: 'Log In',onPressed: (){
               Navigator.pushNamed(context, LoginScreen.id);
            }),
            ///Register Button
            RoundedButton(colour: Colors.blueAccent,title: 'Register',onPressed: (){
               Navigator.pushNamed(context, RegistrationScreen.id);
            }),
          ],
        ),
      ),
    );
  }
}



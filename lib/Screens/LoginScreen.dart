import 'package:buy_it/Screens/admin/AdminHome.dart';
import 'package:buy_it/Screens/user/HomePage.dart';
import 'package:buy_it/Widgets/Custome_Logo.dart';
import 'package:buy_it/Widgets/Custome_TextField.dart';
import 'package:buy_it/provider/ModelHud.dart';
import 'package:buy_it/provider/adminMode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buy_it/Screens/SignUpScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../Widgets/constants.dart';
import 'package:buy_it/Services/Auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  String _email, _password;

  final _auth = Auth();

  final AdminPass = "123456";

  bool KeepMeLoggedIn=false;

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: Provider.of<ModelHud>(context).isLoding,
      child: Form(
        key: _globalKey,
        child: Scaffold(
          backgroundColor: KmainColor,
          body: ListView(
            children: [
              Customelogo(),
              SizedBox(
                height: height * .05,
              ),
              CustomeTextField(
                onClick: (value) {
                  _email = value;
                },
                hint: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(
                height: height * .01,
              ),
              CustomeTextField(
                  onClick: (value) {
                    _password = value;
                  },
                  icon: Icons.lock,
                  hint: 'Enter your Password'),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Checkbox(value: KeepMeLoggedIn,
                        onChanged: (value) {
                      setState(() {
                        KeepMeLoggedIn=value;
                      });
                    }),
                    Text('Remember Me')
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (context) => FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.black,
                      onPressed: () async {
                        if(KeepMeLoggedIn==true){
                          KeepUserLoggedIn();
                        }
                        _validate(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You Don\'t have an account?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.id);
                    },
                    child: Text(
                      ' Sign Up',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Provider.of<AdminMode>(context, listen: false)
                            .ChangeisAdmin(true);
                      },
                      child: Text(
                        'i\'m an admin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin
                                ? KmainColor
                                : Colors.black),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Provider.of<AdminMode>(context, listen: false)
                            .ChangeisAdmin(false);
                      },
                      child: Text(
                        'i\'m a user',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Provider.of<AdminMode>(context).isAdmin
                                ? Colors.black
                                : KmainColor),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context)async {
    final modelhud = Provider.of<ModelHud>(context,listen: false);
    modelhud.changeisLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();

      if (Provider.of<AdminMode>(context,listen: false).isAdmin) {
        if (_password == AdminPass) {
          try {
             await _auth.signIn(_email, _password);
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelhud.changeisLoading(false);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(e.message)));
          }
        } else {
          modelhud.changeisLoading(false);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Something went wrong!')));
        }
      } else {
        try {
          await _auth.signIn(_email, _password);
          Navigator.pushNamed(context, HomePage.id);
        } catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
        }
      }
    }
    modelhud.changeisLoading(false);
  }

  void KeepUserLoggedIn()async {
    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setBool(kKeepUserLoggedIn, KeepMeLoggedIn);
  }
}

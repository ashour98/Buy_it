import 'package:buy_it/Screens/user/HomePage.dart';
import 'package:buy_it/Widgets/Custome_Logo.dart';
import 'package:buy_it/Widgets/Custome_TextField.dart';
import 'package:buy_it/provider/ModelHud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'LoginScreen.dart';
import '../Widgets/constants.dart';
import 'package:buy_it/Services/Auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _globalKey= GlobalKey<FormState>();
  static String id = 'SignUp';
  final _auth=Auth();
  String _email,_password;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: KmainColor,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<ModelHud>(context).isLoding,
          child: Form(
            key: _globalKey,
            child: ListView(
              children: [
                Customelogo(),
                SizedBox(
                  height: height * .05,
                ),
                CustomeTextField(
                  hint: 'Enter your Name',
                  icon: Icons.perm_identity,
                ),
                SizedBox(
                  height: height * .01,
                ),
                CustomeTextField(
                  onClick: (value){
                    _email=value;
                  },
                  hint: 'Enter your email',
                  icon: Icons.email,
                ),
                SizedBox(
                  height: height * .01,
                ),
                CustomeTextField(
                    onClick: (value){
                      _password=value;
                    },
                    icon: Icons.lock,
                    hint: 'Enter your Password'),
                SizedBox(
                  height: height*.05,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 120),
                  child: Builder(
                    builder:(context)=> FlatButton(

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.black,
                        onPressed: () async
                        {
                          final modelHud= Provider.of<ModelHud>(context, listen: false);
                          modelHud.changeisLoading(true);
                          if(_globalKey.currentState.validate())
                          {
                            _globalKey.currentState.save();
                            try {
                              final authResult = await _auth.signUp(
                                  _email.trim(), _password.trim());
                              modelHud.changeisLoading(false);
                              Navigator.pushNamed(context, HomePage.id);
                            }
                            catch(e){
                              modelHud.changeisLoading(false);
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  e.message

                                )
                              ));
                            }
                          }
                          modelHud.changeisLoading(false);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                SizedBox(
                  height: height*.02,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do have an account ?',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
    );  }
}
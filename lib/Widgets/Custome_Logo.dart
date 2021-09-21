import 'package:flutter/material.dart';

class Customelogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Container(
        height: MediaQuery.of(context).size.height * .25,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage('images/icons/iconbuy.png'),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                'Buy It',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}

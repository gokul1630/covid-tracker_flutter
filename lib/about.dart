import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  Widget _getImage() {
    AssetImage assetImage = AssetImage('images/covid.jpg');
    Image image = Image(image: assetImage);
    return Center(child: image);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1920, // Optional
      width: 1080, // Optional
      allowFontScaling: true, // Optional
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: ListView(
        children: [
          _getImage(),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: TextResponsive(
              "This Application gives state-wise details "
              "about coronavirus cases in India,"
              "Data scraped from the homepage of "
              "Ministry of Health & Family Welfare.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: "Source: ",
                  style: TextStyle(color: Colors.black, fontSize: 25.0),
                  children: [
                    TextSpan(
                        text: "mohfw.gov.in",
                        style: TextStyle(
                          fontSize: 25.0,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            const url = 'https://www.mohfw.gov.in';
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                                forceSafariVC: false,
                              );
                            }
                          }),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: Text(
              EmojiParser()
                  .emojify("Made with :heart: in India by Gokulprasanth"),
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

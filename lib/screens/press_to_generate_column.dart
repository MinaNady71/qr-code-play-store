


import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class PressToGenerateQRColumn extends StatelessWidget {
  const PressToGenerateQRColumn({
    Key? key,
    required this.globalKey,
    required this.textValue,
    required this.onPress
  }) : super(key: key);

  final GlobalKey<State<StatefulWidget>> globalKey;
  final String? textValue;
  final onPress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: globalKey,
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: QrImage(
              data: "$textValue",
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TextButton(
                  style:ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)) ,
                  onPressed:onPress ,
                  child: Column(
                    children: [
                      Icon(Icons.save,
                        size: 35,
                        color: Theme.of(context).textTheme.subtitle1!.color,
                      ),
                      Text('Save',
                        style: TextStyle(
                          color:Theme.of(context).textTheme.subtitle1!.color,
                          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,),)
                    ],
                  )),
            ),
            Flexible(
              child: TextButton(
                  style:ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)) ,
                  onPressed: (){

                    Share.share('$textValue');
                  },
                  child: Column(
                    children: [
                      Icon(Icons.share,
                        size: 35,
                        color: Theme.of(context).textTheme.subtitle1!.color,
                      ),
                      Text('Share',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1!.color,
                          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                        ),)
                    ],
                  )),
            ),

          ],
        )
      ],
    );
  }
}
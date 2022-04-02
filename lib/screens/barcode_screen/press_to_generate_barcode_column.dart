


import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PressToGenerateBarcodeColumn extends StatelessWidget {
  const PressToGenerateBarcodeColumn({
    Key? key,
    required this.globalKey,
    required this.textValue,
    required this.onPress,
    required this.barcodeType,
    this.height,
    this.width
  }) : super(key: key);

  final GlobalKey<State<StatefulWidget>> globalKey;
  final String? textValue;
  final onPress;
  final barcodeType;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: globalKey,
          child: Container(
            height:200 ,
            width:width == null? 330:225,
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child:  BarcodeWidget(
              data: textValue.toString(),
              barcode:barcodeType,
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
                        style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color,fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,),)
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
                        style: TextStyle(color: Theme.of(context).textTheme.subtitle1!.color,fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,),)
                    ],
                  )),
            ),

          ],
        )
      ],
    );
  }
}
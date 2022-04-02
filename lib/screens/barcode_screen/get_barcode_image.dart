import 'dart:ui';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:share/share.dart';

class GetBarcodeImage extends StatelessWidget {
  GlobalKey globalKey = GlobalKey();
  String? copiedData;
  var barcodeType;
  final double? height;
  final double? width;

  GetBarcodeImage({this.copiedData, this.barcodeType, this.width, this.height}) ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Barcode View'),
        backgroundColor:Theme.of(context).bottomAppBarColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
              ),
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),

            child: Column(

            children: [
              Text(
                'Barcode',
                style: TextStyle(color: Color(0xff04A583),fontSize:Theme.of(context).textTheme.bodyText1!.fontSize,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height:225 ,
                  width:width == null? 375:260,
                  padding: EdgeInsets.all(20),
                  child:  BarcodeWidget(
                    data: copiedData.toString(),
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
                        onPressed: ()async{

                          await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );
                        },
                        child: Column(
                          children: [
                            Icon(Icons.save,
                              size: 40,
                              color: Color(0xff04A583),
                            ),
                            Text('Save',
                              style: TextStyle(color: Color(0xff04A583),fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,),)
                          ],
                        )),
                  ),
                  Flexible(
                    child: TextButton(
                        style:ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)) ,
                        onPressed: (){

                          Share.share('$copiedData');
                        },
                        child: Column(
                          children: [
                            Icon(Icons.share,
                              size: 40,
                              color: Color(0xff04A583),
                            ),
                            Text('Share',
                              style: TextStyle(color: Color(0xff04A583),fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,),)
                          ],
                        )),
                  ),

                ],
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BannerAdModel(adSizedRectangle: true,),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

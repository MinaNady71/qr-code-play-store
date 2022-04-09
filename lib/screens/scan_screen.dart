import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/ads_package/cubit/cubit.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/every_single_code_scannedHistory.dart';
import 'package:qr_code/shared/network/local/cache_helper.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';


class ScanScreen extends StatefulWidget {
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  Barcode? result;
  bool toggleFlash = false;
  IconData flashIcon = Icons.flash_off;
  double zoom =CacheHelper.getDoubleData('zoom')?? 40;
@override
 
  void reassemble() async{
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
    await ScanCodeCubit.get(context).checkForUpdate().then((value) {
      print('update checked');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      AdsCubit.get(context).loadInterstitialAd();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = ScanCodeCubit.get(context);
    var adsCubit = AdsCubit.get(context);
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
      listener: (context,state){

        if(state is ScanRefreshCameraStates){
          controller!.resumeCamera();
        }
      },
      builder: (context,state){

        var mq =MediaQuery.of(context).size.width * 0.5;
        return  Scaffold(

          floatingActionButton:SpeedDial(
            childrenButtonSize:  const Size(40,45),
            buttonSize: const Size(40,40),
            backgroundColor: Theme.of(context).bottomAppBarColor.withOpacity(0.5),
            renderOverlay: false,
            animatedIconTheme: IconThemeData(color: Colors.white,),
            animatedIcon:AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                labelStyle: TextStyle(fontSize:  Theme.of(context).textTheme.bodyText1!.fontSize),
                label: 'Flip camera',
                  labelBackgroundColor:Colors.transparent,
                  backgroundColor: Colors.transparent,
                  child:Icon(Icons.flip_camera_ios_outlined,color: Colors.white,size: 25) ,
                  onTap: (){
                    setState(() {
                      controller!.flipCamera();
                    });
                  }
              ),
              SpeedDialChild(
                  labelStyle: TextStyle(fontSize:  Theme.of(context).textTheme.bodyText1!.fontSize),
                  label: 'Flash',
                  labelBackgroundColor:Colors.transparent,
                  backgroundColor: Colors.transparent,
                  child:Icon(toggleFlash?Icons.flash_on:Icons.flash_off,color: Colors.white,size: 25,) ,
                  onTap: (){
                    setState(() {
                      controller!.toggleFlash();
                      toggleFlash = !toggleFlash;
                    });
                  }
              ),
              SpeedDialChild(
                  labelStyle: TextStyle(fontSize:  Theme.of(context).textTheme.bodyText1!.fontSize),
                  label: 'Scan image',
                  labelBackgroundColor:Colors.transparent,
                  backgroundColor: Colors.transparent,
                  child:Icon(Icons.image_sharp,color: Colors.white,size: 25,),
                  onTap: ()async{
                  await  adsCubit.loadInterstitialAd();
                    cubit.downLoadImage(context).then((value){
                     _launchImageURL();
                    });

                  }
              ),
            ],
          ),
          body:  SafeArea(
            child:Stack(
               alignment: Alignment.topCenter,
                children: [

                  Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              controller!.resumeCamera();
                            });
                          },

                          onScaleUpdate: (scale){
                              setState(() {

                                if(zoom <= 120 && zoom >= 0){
                                  if(scale.rotation.isNegative){
                                    zoom -- ;
                                  }else{
                                    zoom ++ ;
                                  }

                                }else if(zoom.toInt() >= 120){
                                  zoom = 119;
                                }else if(zoom.toInt() <= 0){
                                  zoom = 1;
                                }

                              print(zoom.toString());
                              });
                          },
                          onScaleEnd: (end){
                            setState(() {
                              CacheHelper.putDouble(key: 'zoom', value: zoom);
                            });
                          },
                          child: QRView(
                              overlay: QrScannerOverlayShape(
                                cutOutSize:MediaQuery.of(context).size.width <450? (mq +zoom):250 ,
                                borderRadius: 30,
                                borderLength: 20,
                                borderWidth: 15,
                                borderColor: Color(0xff04A583),
                              ),
                              onPermissionSet:  (ctrl, p) => _onPermissionSet(context, ctrl, p),
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
      }
    );
  }
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
  void _launchURL() async {
    if (await canLaunch(result!.code.toString())){
      if(ScanCodeCubit.get(context).vibrate == true){
        Vibrate.vibrate();
      }
      if(ScanCodeCubit.get(context).openURLAuto == true){
        await  launch(result!.code.toString());
      }
      if(ScanCodeCubit.get(context).playSound == true){
         FlutterBeep.beep(false);
      }


      var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
      var date = DateTime.now().toString().substring(0,11);
      ScanCodeCubit.get(context).insertDatabaseScanned(
          name: result!.code.toString(),
          dateTime: date  + time,
          isScanned: 'scanned'
      );
      Future.delayed(
          Duration(milliseconds: 500),(){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context)=>
                    ViewSingleCodeScannedHistory(index:null))).then((value) =>  controller!.resumeCamera());
      });
      await  AdsCubit.get(context).showInterstitialAd();
    }
    else{
      if(ScanCodeCubit.get(context).vibrate == true){
        Vibrate.vibrate();
      }
      var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
      var date = DateTime.now().toString().substring(0,11);
        ScanCodeCubit.get(context).insertDatabaseScanned(
            name: result!.code.toString(),
            dateTime: date  + time,
            isScanned: 'scanned'
        );
        Future.delayed(
            Duration(milliseconds: 500),(){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context)=>
                      ViewSingleCodeScannedHistory(index:null))).then((value) =>  controller!.resumeCamera());
        });
      await  AdsCubit.get(context).showInterstitialAd();
    } throw 'Could not launch ${result!.code.toString()}';

  }

  void _launchImageURL() async {
  if(ScanCodeCubit.get(context).scanResult != null){
  await  AdsCubit.get(context).showInterstitialAd();
  if (await canLaunch(ScanCodeCubit.get(context).scanResult.toString())){
    if(ScanCodeCubit.get(context).vibrate == true){
      Vibrate.vibrate();
    }
    if(ScanCodeCubit.get(context).openURLAuto == true){
      await  launch(ScanCodeCubit.get(context).scanResult.toString(),);
    }
    if(ScanCodeCubit.get(context).playSound == true){
       FlutterBeep.beep(false);
    }
    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
    var date = DateTime.now().toString().substring(0,11);
    ScanCodeCubit.get(context).insertDatabaseScanned(
        name: ScanCodeCubit.get(context).scanResult.toString(),
        dateTime: date  + time,
        isScanned: 'scanned'
    );
    Future.delayed(
        Duration(milliseconds: 500),(){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context)=>
                  ViewSingleCodeScannedHistory(index:null)));
    });

  }
  else{
    if(ScanCodeCubit.get(context).vibrate == true){
      Vibrate.vibrate();
    }
    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
    var date = DateTime.now().toString().substring(0,11);
    ScanCodeCubit.get(context).insertDatabaseScanned(
        name: ScanCodeCubit.get(context).scanResult.toString(),
        dateTime: date  + time,
        isScanned: 'scanned'
    );
    Future.delayed(
        Duration(milliseconds: 500),(){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context)=>
                  ViewSingleCodeScannedHistory(index:null)));
    });
  }
}else{
 defaultToastMessage(context: context,msg:'Broken link...', color: Color(0xff900e0e),gravity: ToastGravity.CENTER);
}
  ScanCodeCubit.get(context).scanResult = null;

  }

  void _onQRViewCreated(QRViewController controller){

    this.controller =  controller;
    controller.scannedDataStream.listen((scanData)async{
        setState(() async{
          if(scanData != null ){
            if( result != scanData ){
              setState(() {
                result = scanData;
                controller.pauseCamera();
                _launchURL();
              });
              await  AdsCubit.get(context).loadInterstitialAd();
            }
          }else {
           defaultToastMessage(context: context,msg:'Broken link...', color:Color(0xff900e0e),gravity: ToastGravity.CENTER);
          }
      });


      print('testtest' + result!.code.toString() + result!.format.toString() );

    });
  }
}

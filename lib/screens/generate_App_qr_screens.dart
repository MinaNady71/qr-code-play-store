import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/list_of_device_apps.dart';
import 'package:qr_code/screens/press_to_generate_column.dart';

import '../ads_package/cubit/cubit.dart';


class GenerateAppsScreen extends StatefulWidget {

  @override
  State<GenerateAppsScreen> createState() => _GenerateAppsScreenState();
}

class _GenerateAppsScreenState extends State<GenerateAppsScreen> {
  TextEditingController appsController = TextEditingController();
  String? textValue;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    var cubit = ScanCodeCubit.get(context);
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){
          if(state is ScanSaveImageStates){

           defaultToastMessage(context: context,msg: 'Photo saved to this device', color: Color(0xff323739));
          }

        },
        builder: (context,state){
          return Scaffold(
            appBar: AppBar(
              title: Text('Generate'),
              backgroundColor:Theme.of(context).bottomAppBarColor,
            ),
            body: Container(
              height:MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors:[
                      Theme.of(context).colorScheme.onPrimary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.secondaryContainer

                    ]
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      BannerAdModel(),
                      SizedBox(height: 20,),
                       defaultTextField(
                          context: context,
                          controller: appsController,
                          label: 'Enter Application URL Manually',
                          textInputType: TextInputType.text,
                          suffixIcon:TextButton(
                              onPressed: ()async{
                                cubit.getDeviceAppList(context).then((value){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context)=>
                                              ShowDeviceAppLists()
                                      )).then((value) {
                                        if(value != null)
                                   appsController.text = 'https://play.google.com/store/apps/details?id=${value.toString()}';
                                 });
                                });

                              },
                              child: Icon(Icons.add_circle_outline,color:Color(0xff045f4d),))
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 35,),
                        alignment: Alignment.bottomRight,
                        child: defaultElevatedButton(
                          context: context,
                            backgroundColor:Theme.of(context).bottomAppBarColor,
                            label: 'Generate',
                            onPressed: ()async{
                              await AdsCubit.get(context).showInterstitialAd();
                              setState(() {
                                var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                                var date = DateTime.now().toString().substring(0,11);
                                textValue = appsController.text.toString();

                                if(textValue != null && textValue!.isNotEmpty){
                                  cubit.insertDatabaseScanned(
                                      name: textValue.toString(),
                                      dateTime:  '$date  ' + time,
                                      isScanned: 'created'
                                  );
                                 defaultToastMessage(context: context,msg: 'App URL added successfully', color: Color(0xff04A583));
                                }else{

                                 defaultToastMessage(context: context,msg: 'Enter App URL', color: Colors.red);
                                }
                                FocusScope.of(context).unfocus();
                              });
                            }

                        ),
                      ),
                      SizedBox(height: 50,),
                      if(appsController.text.length > 0 && appsController.text != null )
                        PressToGenerateQRColumn(
                          globalKey: globalKey,
                          textValue: textValue,
                          onPress: ()async{
                            await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );//to create QR Image
                          },),
                      SizedBox(height: 50,),
                    ]
                ),
              ),
            ),
          );
        });
  }



}



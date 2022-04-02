import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/press_to_generate_column.dart';

import '../ads_package/cubit/cubit.dart';


class GenerateURLScreen extends StatefulWidget {

  @override
  State<GenerateURLScreen> createState() => _GenerateURLScreenState();
}

class _GenerateURLScreenState extends State<GenerateURLScreen> {
  TextEditingController controller = TextEditingController();
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
      body:  Container(
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
                 controller: controller,
                 label: 'Enter url',
                 textInputType: TextInputType.text
             ),
             Container(
            margin: EdgeInsets.only(right: 35,),
           alignment: Alignment.bottomRight,
            child: defaultElevatedButton(
                          context: context,
                 backgroundColor:  Theme.of(context).bottomAppBarColor,
                 label: 'Generate',
                onPressed: ()async{
                  await AdsCubit.get(context).showInterstitialAd();
                  setState(() {
                    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                    var date = DateTime.now().toString().substring(0,11);
                  //  https://
                    if(controller.text.contains('https://') || controller.text.contains('http://')){
                      textValue = controller.text.toString();
                    }else{
                      textValue = 'https://${controller.text.toString()}';
                    }

                    if(controller.text.toString() != null && controller.text.toString().isNotEmpty){
                      cubit.insertDatabaseScanned(
                          name: textValue.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );
                     defaultToastMessage(context: context,msg: 'URL added successfully', color: Color(0xff04A583));
                    }else{

                     defaultToastMessage(context: context,msg: 'Enter URL', color: Color(0xff900e0e));
                    }

                  });
                  FocusScope.of(context).unfocus();
                  }

               ),
             ),
             SizedBox(height: 50,),
             if(controller.text.length > 0 && controller.text != null )
               PressToGenerateQRColumn(
                 globalKey: globalKey,
                 textValue: textValue ,
                 onPress: ()async{
                   await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );
                 },),
               SizedBox(height: 50,),
           ]
          ),
        ),
      ),);
       });
  }



}

import 'dart:ui';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/press_to_generate_column.dart';

import '../ads_package/cubit/cubit.dart';


class GenerateSMSScreen extends StatefulWidget {

  @override
  State<GenerateSMSScreen> createState() => _GenerateSMSScreenState();
}

class _GenerateSMSScreenState extends State<GenerateSMSScreen> {
  TextEditingController numberController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String? smsValue;
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
                 padding: EdgeInsets.only(top:25,bottom: 5,right: 25,left: 25),
                 controller: numberController,
                 label: 'Enter phone number',
                 textInputType: TextInputType.phone,
                 suffixIcon:TextButton(
                     onPressed: ()async{
                       var status = await Permission.contacts.status;
                       if(status.isGranted) {
                         await ContactsService.openDeviceContactPicker().then((value){
                           numberController.text = value!.phones![0].value.toString();
                         });
                       }else{
                         await Permission.contacts.request();
                       }
                     },
                     child: Icon(Icons.add_circle_outline,color:Color(0xff045f4d),))
             ),


             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 0,bottom: 25,right: 25,left: 25),
                 controller: messageController,
                 label: 'Enter SMS Message',
                 textInputType: TextInputType.multiline,
                 maxLines: 5
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
                    smsValue = 'SMSTO:${numberController.text.toString()}:${messageController.text.toString()}' ;

                    if(numberController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Enter phone number', color: Color(0xff900e0e));
                    } else if(messageController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Enter SMS message', color: Color(0xff900e0e));
                    }else if(smsValue != null && numberController.text.isNotEmpty && messageController.text.isNotEmpty ){
                      cubit.insertDatabaseScanned(
                          name: smsValue.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );
                     defaultToastMessage(context: context,msg: 'SMS added successfully', color: Color(0xff04A583));
                    }
                    FocusScope.of(context).unfocus();
                  });
                  }

               ),
             ),
             SizedBox(height: 50,),
             if(messageController.text.isNotEmpty && messageController.text.isNotEmpty && numberController.text != null )
             PressToGenerateQRColumn(
               globalKey: globalKey,
               textValue: smsValue,
               onPress: ()async{
               await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );//to create QR Image
             },),
               SizedBox(height: 50,),
           ]
          ),
        ),
      ),);
       });
  }



}



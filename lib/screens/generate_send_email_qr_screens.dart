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
import 'package:qr_code/screens/press_to_generate_column.dart';

import '../ads_package/cubit/cubit.dart';


class GenerateSendEmailScreen extends StatefulWidget {

  @override
  State<GenerateSendEmailScreen> createState() => _GenerateSendEmailScreenState();
}

class _GenerateSendEmailScreenState extends State<GenerateSendEmailScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  GlobalKey globalKey = GlobalKey();

  String? email;

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
                 padding: EdgeInsets.only(top: 25.0,right: 25.0,left: 25.0),
                 controller:emailController,
                 label: 'Enter email',
                 textInputType: TextInputType.emailAddress,
             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 5,right: 25.0,left: 25.0),
                 controller:subjectController ,
                 label: 'Enter subject',
                 textInputType: TextInputType.text,

             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 5,bottom: 25,right: 25.0,left: 25.0),
               controller: bodyController,
               label: 'Enter text',
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
                    if(emailController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Email is empty', color: Color(0xff900e0e));
                    }else if(subjectController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'subject is empty', color: Color(0xff900e0e));
                    }else if(bodyController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'body is empty', color: Color(0xff900e0e));
                    }else{
                     email = 'mailto:${emailController.text}?subject=${subjectController.text}&body=${bodyController.text}';
                    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                    var date = DateTime.now().toString().substring(0,11);

                      cubit.insertDatabaseScanned(
                          name: email.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );

                    defaultToastMessage(context: context,msg: 'Email added successfully', color: Color(0xff04A583));
                      }
                    FocusScope.of(context).unfocus();
                  });
                  }

               ),
             ),
             SizedBox(height: 50,),
             if(emailController.text.isNotEmpty && bodyController.text.isNotEmpty && subjectController.text.isNotEmpty && subjectController.text.length != null )
             PressToGenerateQRColumn(
               globalKey: globalKey,
               textValue: email,
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


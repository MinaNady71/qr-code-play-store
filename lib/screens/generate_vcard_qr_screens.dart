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


class GenerateVcardScreen extends StatefulWidget {

  @override
  State<GenerateVcardScreen> createState() => _GenerateVcardScreenState();
}

class _GenerateVcardScreenState extends State<GenerateVcardScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey globalKey = GlobalKey();

  String? vCardDb;

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
                 controller: nameController,
                 label: 'Enter name',
                 textInputType: TextInputType.text,
                 suffixIcon:TextButton(
                     onPressed: ()async{
                       var status = await Permission.contacts.status;
                       if(status.isGranted) {
                         await ContactsService.openDeviceContactPicker().then((value){
                           nameController.text    = value!.displayName.toString();
                           phoneController.text   = value.phones![0].value.toString();
                           emailController.text   = value.emails![0].value.toString().toString();
                           addressController.text = value.postalAddresses![0].toString();
                         });
                       }else{
                         await Permission.contacts.request();
                       }
                     },
                     child: Icon(Icons.add_circle_outline,color:Color(0xff045f4d),))
             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 5,right: 25.0,left: 25.0),
                 controller: phoneController,
                 label: 'Enter phone number',
                 textInputType: TextInputType.phone,

             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(
                   top: 5,
                   bottom: 5,
                   right: 25.0,
                   left: 25.0
               ),
               controller: emailController,
               label: 'Enter email',
               textInputType: TextInputType.emailAddress,

             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(bottom: 30,right: 25.0,left: 25.0),
               controller: addressController,
               label: 'Enter address',
               textInputType: TextInputType.text,

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
                    if(nameController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Name is empty', color:Color(0xff900e0e));
                    }else if(phoneController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Phone is empty', color: Color(0xff900e0e));
                    }else if(emailController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Email is empty', color: Color(0xff900e0e));
                    }else if(addressController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Address is empty', color: Color(0xff900e0e));
                    }else{
                     vCardDb = ''
                    'BEGIN:VCARD'
                    '\nVERSION:3.0'
                    '\nN:${nameController.text.toString()}'
                    '\nTEL:${phoneController.text.toString()}'
                    '\nEMAIL:${emailController.text.toString()}'
                    '\nADR:${addressController.text.toString()}'
                    '\nEND:VCARD';
                    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                    var date = DateTime.now().toString().substring(0,11);

                      cubit.insertDatabaseScanned(
                          name: vCardDb.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );

                    defaultToastMessage(context: context,msg: 'Card added successfully', color: Color(0xff04A583));

                      }
                    FocusScope.of(context).unfocus();
                  });
                  }

               ),
             ),
             SizedBox(height: 50,),
             if(vCardDb.toString().isNotEmpty && vCardDb != null )
             PressToGenerateQRColumn(
               globalKey: globalKey,
               textValue: vCardDb,
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


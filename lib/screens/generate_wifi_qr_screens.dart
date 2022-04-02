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


class GenerateWIFIScreen extends StatefulWidget {

  @override
  State<GenerateWIFIScreen> createState() => _GenerateWIFIScreenState();
}

class _GenerateWIFIScreenState extends State<GenerateWIFIScreen> {
  TextEditingController wifiNameController = TextEditingController();
  TextEditingController wifiPassController = TextEditingController();
  TextEditingController wifiTypeController = TextEditingController();
  GlobalKey globalKey = GlobalKey();

  String? wifiValue;

  String dropdownValue = 'WPA/WPA2';

  @override
  Widget build(BuildContext context) {
    wifiTypeController.text = dropdownValue.toString();
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
               padding: EdgeInsets.only(top: 5,right: 25.0,left: 25.0),
                 controller: wifiNameController,
                 label: 'Enter Network Name',
                 textInputType: TextInputType.text,

             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 5,bottom: 5,right: 25.0,left: 25.0),
               readOnly: true,
               controller:wifiTypeController,
               label:'',
               textInputType: TextInputType.text,
               suffixIcon: Padding(
                 padding: const EdgeInsets.only(right: 15.0),
                 child: DropdownButton(
                   style: TextStyle(
                     color: Theme.of(context).textTheme.bodyText2!.color,
                     fontWeight: Theme.of(context).textTheme.bodyText1!.fontWeight
                   ),
                   //dropdownColor:  Theme.of(context).backgroundColor,
                   underline: SizedBox(),
                   iconSize: 35,
                   icon: Icon(Icons.arrow_drop_down_sharp),
                   onChanged: (String? newValue) {
                     setState(() {
                       dropdownValue = newValue!;
                       wifiTypeController.text = dropdownValue.toString();

                     });
                   },
                   items: <String>['WPA/WPA2', 'WEP', 'FREE']
                       .map<DropdownMenuItem<String>>((String value) {
                     return DropdownMenuItem<String>(
                       value: value,
                       child: Text(value),
                     );
                   }).toList(),
                 ),
               ),

             ),
             if(!(wifiTypeController.text == 'FREE'))
             defaultTextField(
               maxLength:dropdownValue == 'WPA/WPA2'?63:null ,
               context: context,
               padding: EdgeInsets.only(right: 25.0,left: 25.0),
               controller:wifiPassController,
               label: 'Enter Password',
               textInputType: TextInputType.text,

             ),


               Container(
                 margin: EdgeInsets.only(right: 35,top: 30),
                 alignment: Alignment.bottomRight,
                 child: defaultElevatedButton(
                          context: context,
                 backgroundColor:  Theme.of(context).bottomAppBarColor,
                 label: 'Generate',
                     onPressed: ()async{
                       await AdsCubit.get(context).showInterstitialAd();
                  setState(() {

                    if(wifiNameController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Name is empty', color: Color(0xff900e0e));
                    }else if(wifiPassController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Password is empty', color: Color(0xff900e0e));
                    }else if(wifiPassController.text.length < 8){
                      defaultToastMessage(context: context,msg: 'The password must contain at least 8 characters', color: Color(0xff900e0e));
                    }else if(wifiNameController.text.isNotEmpty && (wifiTypeController.text == 'FREE') ){
                     wifiValue = 'WIFI:S:${wifiNameController.text.toString()};;';
                    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                    var date = DateTime.now().toString().substring(0,11);

                      cubit.insertDatabaseScanned(
                          name: wifiValue.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );

                    defaultToastMessage(context: context,msg: 'WIFI added successfully', color: Color(0xff04A583));


                      }else if(wifiPassController.text.isNotEmpty && (wifiTypeController.text == 'WPA/WPA2') && wifiNameController.text.isNotEmpty){
                      wifiValue = 'WIFI:T:WPA;S:${ wifiNameController.text.toString()};P:${wifiPassController.text.toString()};;';
                      var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                      var date = DateTime.now().toString().substring(0,11);

                      cubit.insertDatabaseScanned(
                          name: wifiValue.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );
                     defaultToastMessage(context: context,msg: 'WIFI added successfully', color: Color(0xff04A583));

                    }else if(wifiPassController.text.isNotEmpty && (wifiTypeController.text == 'WEP') && wifiNameController.text.isNotEmpty){
                      wifiValue = 'WIFI:T:WEP;S:${ wifiNameController.text.toString()};P:${wifiPassController.text.toString()};;';
                      var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                      var date = DateTime.now().toString().substring(0,11);

                      cubit.insertDatabaseScanned(
                          name: wifiValue.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );

                     defaultToastMessage(context: context,msg: 'WIFI added successfully', color: Color(0xff04A583));

                    }
                    FocusScope.of(context).unfocus();
                  });
                  }

               ),
             ),
             SizedBox(height: 50,),
             if(wifiValue.toString().isNotEmpty && wifiValue != null )
             PressToGenerateQRColumn(
               globalKey: globalKey,
               textValue: wifiValue,
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


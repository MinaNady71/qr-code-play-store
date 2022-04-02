import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
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
import 'package:qr_code/global_variables.dart';
import 'package:qr_code/screens/barcode_screen/press_to_generate_barcode_column.dart';

import '../../ads_package/cubit/cubit.dart';



class GenerateBarcodeCode93Screen extends StatefulWidget {

  @override
  State<GenerateBarcodeCode93Screen> createState() => _GenerateBarcodeCode93ScreenState();
}

class _GenerateBarcodeCode93ScreenState extends State<GenerateBarcodeCode93Screen> {
  TextEditingController controller = TextEditingController();
  String? textValue;
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

   var cubit = ScanCodeCubit.get(context);
   return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
       listener: (context,state){},
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
                 label: 'text in uppercase without special characters',
                 textInputType: TextInputType.text,
                 inputFormatters: <TextInputFormatter>[
                   FilteringTextInputFormatter.allow(RegExp(includeRegExpForCode93)),
                 ],
               textCapitalization: TextCapitalization.characters

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
                    if(controller.text.contains(RegExp(includeRegExpForCode93)) && controller.text != null && controller.text.length > 0){
                      var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                      var date = DateTime.now().toString().substring(0,11);
                      textValue = controller.text.toString();
                      if(textValue != null && textValue!.isNotEmpty){
                        cubit.insertDatabaseScanned(
                            name: textValue.toString(),
                            dateTime:  '$date  ' + time,
                            isScanned: 'created'
                        );
                       defaultToastMessage(context: context,msg: 'Barcode added successfully', color: Color(0xff323739));
                      }
                    }else{
                     defaultToastMessage(context: context,msg: 'The given text is not valid for the format "Code 93"', color: Color(0xff900e0e));
                    }

                  });
                  FocusScope.of(context).unfocus();
                  }
               ),
             ),
             SizedBox(height: 50,),
             if(controller.text.contains(RegExp(includeRegExpForCode93)) && controller.text != null && controller.text.length > 0)
               PressToGenerateBarcodeColumn(
               globalKey: globalKey,
               textValue: textValue.toString(),
                barcodeType:Barcode.code93() ,
               onPress: ()async{

               await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );
             },),

           ]
          ),
           ),),
    );
       });
  }



}



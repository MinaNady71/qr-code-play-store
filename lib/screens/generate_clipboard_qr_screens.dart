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


class GenerateClipboardScreen extends StatefulWidget {
  dynamic copiedData;

   GenerateClipboardScreen({this.copiedData}) ;


  @override
  State<GenerateClipboardScreen> createState() => _GenerateClipboardScreenState();
}

class _GenerateClipboardScreenState extends State<GenerateClipboardScreen> {
  TextEditingController controller = TextEditingController();

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
         if(widget.copiedData != null ){
           controller.text = widget.copiedData;
         }
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
               readOnly: true,
                 controller: controller,
                 label: 'Enter text',
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
                    widget.copiedData = controller.text.toString();

                    if(widget.copiedData != null && widget.copiedData!.isNotEmpty){
                      cubit.insertDatabaseScanned(
                          name: widget.copiedData.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );
                     defaultToastMessage(context: context,msg: 'Text added successfully', color: Color(0xff04A583));
                    }else{
                     defaultToastMessage(context: context,msg: 'Text field is empty', color: Color(0xff900e0e));
                    }
                    FocusScope.of(context).unfocus();
                  });
                  }

               ),
             ),
             SizedBox(height: 50,),
             if(controller.text.isNotEmpty && controller.text != null )
               PressToGenerateQRColumn(
                 globalKey: globalKey,
                 textValue: "${widget.copiedData}" ,
                 onPress: ()async{
                   await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );
                 },),
               SizedBox(height: 50,),
           ]
          ),
        ),),
    );
       });
  }



}

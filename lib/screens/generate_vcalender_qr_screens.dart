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


class GenerateCalendarEventScreen extends StatefulWidget {

  @override
  State<GenerateCalendarEventScreen> createState() => _GenerateCalendarEventScreenState();
}

class _GenerateCalendarEventScreenState extends State<GenerateCalendarEventScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  GlobalKey globalKey = GlobalKey();

  String? startdatetimefordb;

  String? enddatetimefordb;
  DateTime valuedate = DateTime.now();

  String? calenderValues;

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
                 controller: titleController,
                 label: 'Enter Event Title',
                 textInputType: TextInputType.text,
             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 5,right: 25.0,left: 25.0),
                 controller: locationController,
                 label: 'Enter Event Location',
                 textInputType: TextInputType.text,

             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 5,right: 25.0,left: 25.0),
               controller: descriptionController,
               label: 'Enter Event Description',
               textInputType: TextInputType.text,

             ),
             defaultTextField(
               context: context,
               readOnly: true,
               padding: EdgeInsets.only(top: 5,bottom: 5,right: 25.0,left: 25.0),
               controller: startDateController,
               label: 'Select Start Date/Time',
               textInputType: TextInputType.text,
                 suffixIcon:TextButton(
                     onPressed: ()async{
                       setState((){
                         showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime.now(),
                             lastDate: DateTime( DateTime.now().year +15)
                         ).then((date)async {
                           TimeOfDay? time = await  showTimePicker(
                               context: context,
                               initialTime: TimeOfDay.now());
                           startDateController.text = date.toString().substring(0,11) +' '+ time!.format(context).toString();
                           var  dateDbFormat =   DateFormat("yyyyMMdd").format(date!);
                           var  timeDbFormat =   'T${time.hour.toString()}${time.minute.toString()}00';
                           startdatetimefordb ='${dateDbFormat.toString()}$timeDbFormat';
                           print(startdatetimefordb);

                         });
                       });

                     },
                     child: Icon(Icons.add_circle_outline,color:Color(0xff045f4d),))
             ),
             defaultTextField(
               context: context,readOnly: true,
               padding: EdgeInsets.only(top: 0,bottom: 30,right: 25.0,left: 25.0),
               controller: endDateController,
               label: 'Select End Date/Time',
               textInputType: TextInputType.text,
                 suffixIcon:TextButton(
                     onPressed: ()async{
                       setState(() {
                         showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime.now(),
                             lastDate: DateTime( DateTime.now().year +15)
                         ).then((date)async {
                       TimeOfDay? time = await  showTimePicker(context: context,
                           initialTime: TimeOfDay.now());
                       endDateController.text = date.toString().substring(0,11) +' '+ time!.format(context).toString();
                       var  dateDbFormat =   DateFormat("yyyyMMdd").format(date!);
                       var  timeDbFormat =   'T${time.hour.toString()}${time.minute.toString()}00';
                       enddatetimefordb ='${dateDbFormat.toString()}$timeDbFormat';
                       print(enddatetimefordb);

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
                 backgroundColor:  Theme.of(context).bottomAppBarColor,
                 label: 'Generate',
                onPressed: ()async{
                  await AdsCubit.get(context).showInterstitialAd();
                  setState(() {
                  if(titleController.text.isEmpty){
                   defaultToastMessage(context: context,msg: 'Enter event title', color: Color(0xff900e0e));
                  }else if(locationController.text.isEmpty){
                   defaultToastMessage(context: context,msg: 'Enter event location', color:Color(0xff900e0e));
                  }else if(descriptionController.text.isEmpty){
                   defaultToastMessage(context: context,msg: 'Enter event description', color:Color(0xff900e0e));
                  }else if(startDateController.text.isEmpty){
                   defaultToastMessage(context: context,msg: 'Select event start date', color:Color(0xff900e0e));
                  }else if(endDateController.text.isEmpty){
                   defaultToastMessage(context: context,msg: 'Select event end date', color:Color(0xff900e0e));
                  }else{
                    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                    var date = DateTime.now().toString().substring(0,11);
                     calenderValues = 'VERSION:2.0'
                        '\nBEGIN:VEVENT'
                        '\nSUMMARY:${titleController.text.toString()}'
                        '\nLOCATION:${locationController.text.toString()}'
                        '\nDESCRIPTION:${descriptionController.text.toString()}'
                        '\nDTSTART:${startdatetimefordb}'
                        '\nDTEND:${enddatetimefordb}'
                        '\nEND:VEVENT'
                        '\nEND:VCALENDAR';
                    cubit.insertDatabaseScanned(
                        name: calenderValues.toString(),
                        dateTime:  '$date  ' + time,
                        isScanned: 'created'
                    );


                   defaultToastMessage(context: context,msg: 'Event added successfully', color: Color(0xff04A583));
                  }

                  FocusScope.of(context).unfocus();
                  });
                  }

               ),
             ),
             SizedBox(height: 50,),
             if( calenderValues.toString().isNotEmpty && calenderValues != null )
             PressToGenerateQRColumn(
               globalKey: globalKey,
               textValue: calenderValues,
               onPress: ()async{
               await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );//to create QR Image
             },
             ),
               SizedBox(height: 50,),
           ]
          ),
        ),
      ),);
       });
  }



}



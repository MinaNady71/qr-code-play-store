import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/press_to_generate_column.dart';

import '../ads_package/cubit/cubit.dart';


class GenerateGeoLocationScreen extends StatefulWidget {

  @override
  State<GenerateGeoLocationScreen> createState() => _GenerateGeoLocationScreenState();
}

class _GenerateGeoLocationScreenState extends State<GenerateGeoLocationScreen> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  GlobalKey globalKey = GlobalKey();

  Set<Marker> _marker={};


  Completer<GoogleMapController> _controller = Completer();
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
      String latLong = 'GEO:${latitudeController.text.toString()},${longitudeController.text.toString()}';
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
                 controller:latitudeController,
                 label: 'Enter Latitude Manually',
                 textInputType: TextInputType.number,
             ),
             defaultTextField(
               context: context,
               padding: EdgeInsets.only(top: 5,bottom: 15,right: 25.0,left: 25.0),
                 controller:longitudeController ,
                 label: 'Enter longitude Manually',
                 textInputType: TextInputType.number,

             ),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 25),
           child: Container(
               decoration:BoxDecoration(
                 border:Border.all(
                     color:Theme.of(context).bottomAppBarColor,
                     width: 7
                 )
               ) ,
               height: MediaQuery.of(context).size.height/4,
               width: 370,
               child: Stack(
                 children: [
                   GoogleMap(
                     mapType: MapType.normal,
                     initialCameraPosition: cubit.cameraPosition,
                     onMapCreated: (GoogleMapController controller) {
                       setState(() {
                         _controller.complete(controller);
                         cubit.mapController =controller;
                       });
                     },
                     gestureRecognizers:<Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer(),),
                     } ,
                     myLocationButtonEnabled: true,
                     myLocationEnabled: true,
                     markers:_marker,
                     zoomControlsEnabled: true,
                     onTap: (LatLng latLng){
                       setState(() {
                         _marker = {};
                         _marker.add(
                             Marker(
                               markerId: MarkerId(latLng.toString()),
                               position: latLng,
                               infoWindow: InfoWindow(title: 'I am a marker',),
                               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                             ));
                        setState(() {
                          latitudeController.text = latLng.latitude.toString();
                          longitudeController.text = latLng.longitude.toString();
                        });

                       });},

                   ),
                   Container(
                     margin: EdgeInsets.only(right: 8,top: 5),
                     alignment: Alignment.topRight,
                     child:  defaultElevatedButton(
                            context: context,
                         backgroundColor: Theme.of(context).bottomAppBarColor,
                         label: 'My Location',
                         onPressed: ()async{
                           await  cubit.getCurrentLocation();
                          setState(() {
                            latitudeController.text = cubit.currentLocation!.latitude.toString();
                            longitudeController.text = cubit.currentLocation!.longitude.toString();
                          });
                         }),
                   )

                 ],
               )
           ),
         ),
            SizedBox(height: 20,),
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
                    if(latitudeController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'Latitude is empty', color: Color(0xff900e0e));
                    }else if(longitudeController.text.isEmpty){
                     defaultToastMessage(context: context,msg: 'longitude is empty', color: Color(0xff900e0e));
                    }else{
                    var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
                    var date = DateTime.now().toString().substring(0,11);

                      cubit.insertDatabaseScanned(
                          name: latLong.toString(),
                          dateTime:  '$date  ' + time,
                          isScanned: 'created'
                      );
                    defaultToastMessage(context: context,msg: 'Location added successfully', color: Color(0xff04A583));

                      }
                    FocusScope.of(context).unfocus();
                  });
                  }

               ),
             ),
             const SizedBox(height: 50,),
             if( longitudeController.text.isNotEmpty && latitudeController.text.isNotEmpty && latitudeController.text.length != null )
             PressToGenerateQRColumn(
               globalKey: globalKey,
               textValue: latLong,
               onPress: ()async{
               await ScanCodeCubit.get(context).captureAndSharePng(globalKey: globalKey,context:context );//to create QR Image
             },),
               const SizedBox(height: 50,),
           ]
          ),
        ),

      ),);
       });
  }



}


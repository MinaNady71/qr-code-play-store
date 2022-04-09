
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){},
    builder: (context,state){
          var cubit = ScanCodeCubit.get(context);
    return Container(
      height:MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).backgroundColor,

      child:Stack(
        children: [

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('General Settings',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.dark_mode,),
                            const SizedBox(width:10,),
                            Expanded(
                              child: Text('Dark mode',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              //  inactiveThumbColor:Colors.grey[300],
                                activeColor:const Color(0xff04A583),
                                value: cubit.mode, onChanged: (s){
                              cubit.switchThemeMode();
                            }),
                          ],
                        ),

                      ],
                    ),

                  ),
                  const SizedBox(height: 20,),
                  const Text('Scan Control',),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [

                        Row(
                          children: [
                            const Icon(Icons.vibration_outlined),
                            const SizedBox(width:10,),
                            Expanded(
                              child: Text('Vibrate',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                                activeColor:const Color(0xff04A583),
                                value: cubit.vibrate, onChanged: (s)async{
                              if( cubit.vibrate == false){
                                Vibrate.vibrate();
                              }
                              cubit.switchVibrate();
                            }),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.open_in_browser,),
                            const SizedBox(width:10,),
                            Expanded(
                              child: Text('Open URL automatically',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                                activeColor:const Color(0xff04A583),
                                value: cubit.openURLAuto, onChanged: (s){
                              cubit.openURLAutomatically();
                            }),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(Icons.volume_up_sharp,),
                            const SizedBox(width:10,),
                            Expanded(
                              child: Text('Play sound',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                                activeColor:const Color(0xff04A583),
                                value: cubit.playSound, onChanged: (s){
                              if( cubit.playSound == false){
                                 FlutterBeep.beep(false);
                              }
                              cubit.switchPlaySound();
                            }),
                          ],
                        ),
                        const SizedBox(height: 90,),
                        BannerAdModel(adSizedRectangle: true,)
                      ],
                    ),

                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.bottomRight,
            child: const Text('v1.0.0+4'),
          ),
        ],
      ),
    );}
    );
  }

}
//Scan Control
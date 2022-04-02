import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code/ads_package/cubit/cubit.dart';
import 'package:qr_code/bloc_observer.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/main_screen.dart';
import 'package:qr_code/shared/network/local/cache_helper.dart';
import 'package:qr_code/shared/styles/theme.dart';
import 'ads_package/ad_helper/ads_helper.dart';


void main() async{
 WidgetsFlutterBinding.ensureInitialized();
 await AdsHelper.init();
 await CacheHelper.init();
 await CacheHelper.getBoolData('mode');
 await CacheHelper.getBoolData('vibrate');
 await CacheHelper.getBoolData('openURL');
 await CacheHelper.getBoolData('playSound');
 BlocOverrides.runZoned(
       () {
         runApp(const MyApp());
   },
   blocObserver: MyBlocObserver(),
 );



}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context)=> ScanCodeCubit()),
        BlocProvider(create:(context)=> AdsCubit()..loadInterstitialAd()),
      ],
      child:BlocConsumer<ScanCodeCubit,ScanCodeStates>(
          listener: (context,state){},
      builder: (context,state){
        var cubit = ScanCodeCubit.get(context);
        if(cubit.mode == true){

          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor:Color(0xff323739),
            ),
          );
        }else{
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: Color(0xff04A583),
            ),
          );
        }

      return MaterialApp(
        theme: cubit.mode?darkTheme: lightTheme,
        debugShowCheckedModeBanner: false,
            color: Colors.grey,
            home: SafeArea(

                child: MainScreen()),

      );}
        ),
    );
  }
}

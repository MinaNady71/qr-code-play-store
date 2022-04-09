import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHelper{
static late InitializationStatus initialization;

static int interstitialIndex = 0;

static void randomIndexForInterstitialAd(){
  Random random =Random();
  interstitialIndex =  random.nextInt(interstitialAdUnitIdList.length);
 print('randomIndexForInterstitialAd');
}

  static init()async{
   //  RequestConfiguration configuration = RequestConfiguration(
   //    testDeviceIds:<String>["18FFD8AA74F0DCE7101E042A0083EB3A"],);
   // await MobileAds.instance.updateRequestConfiguration(configuration); // for test real ads
    initialization = await MobileAds.instance.initialize();// for Real ads

    randomIndexForInterstitialAd();
  }



  static bool testMode = false;

 static List<String> interstitialAdUnitIdList =
 [
    'ca-app-pub-2098302662593825/2100794396',
    'ca-app-pub-2098302662593825/4410390828',
    'ca-app-pub-2098302662593825/9471145810',
    'ca-app-pub-2098302662593825/9279574127',
    'ca-app-pub-2098302662593825/3134674469',
    'ca-app-pub-2098302662593825/8195429451',
  ];

 static String get bannerAdUnitId {
   if(testMode){
    return BannerAd.testAdUnitId;

   }else{
     return 'ca-app-pub-2098302662593825/2100794396';
   }
 }

static String get interstitialAdUnitId {
  if(testMode){
    return InterstitialAd.testAdUnitId;

  }else{
    return interstitialAdUnitIdList[interstitialIndex];
  }
}


}
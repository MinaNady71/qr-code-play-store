
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_code/ads_package/ad_helper/ads_helper.dart';
import 'package:qr_code/ads_package/cubit/states.dart';

class AdsCubit extends Cubit<AdsStates> {
  AdsCubit() : super(InitialStatesAdsState());

  static AdsCubit get(context)=> BlocProvider.of(context);

  InterstitialAd? interstitialAd;

  bool isReady = false;

  Future<void> loadInterstitialAd()async{
   await InterstitialAd.load(
        adUnitId: AdsHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad){
              interstitialAd = ad;
              isReady = true;
              emit(InterstitialAdLoadState());
            },
            onAdFailedToLoad: (error){}
        )
    );
    emit(InterstitialAdLoadState());

  }

  Future<void> showInterstitialAd()async{
    if(isReady == true) {
    await  interstitialAd!.show();
    emit(InterstitialAdLoadState());
    }
  }

}
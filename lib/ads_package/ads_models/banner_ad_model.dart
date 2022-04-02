import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_code/ads_package/ad_helper/ads_helper.dart';

class BannerAdModel extends StatefulWidget {
   BannerAdModel({Key? key,this.adSizedRectangle = false}) : super(key: key);
bool adSizedRectangle;
  @override
  State<BannerAdModel> createState() => _BannerAdModelState();
}
class _BannerAdModelState extends State<BannerAdModel> {

  BannerAd? bannerAd;
 final AdSize _adBannerSize = AdSize.banner;
  final AdSize _adMediumRectangle = AdSize.mediumRectangle;
  bool _isAdReady = false;
  int numOfAdFailed = 0;

  void _createBannerAd(){
    bannerAd = BannerAd(
        size:widget.adSizedRectangle == false ? _adBannerSize:_adMediumRectangle,
        adUnitId: AdsHelper.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad){
            setState(() {
              _isAdReady = true;
            });
          },
          onAdFailedToLoad: (ad,error){
            if(numOfAdFailed < 4){
              _createBannerAd();
              numOfAdFailed++;
            }
            log('ad failed to load:${error.message}');
          }
        ),
        request: AdRequest()
    );
    bannerAd!.load();

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createBannerAd();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bannerAd!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(_isAdReady == true) {
      return Container(
        height:widget.adSizedRectangle == false ? _adBannerSize.height.toDouble():_adMediumRectangle.height.toDouble(),
        width:widget.adSizedRectangle == false ? _adBannerSize.width.toDouble():_adMediumRectangle.width.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: bannerAd!),
      );
    }else{
      return SizedBox(height: 5,);
    }
    }
  }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code/ads_package/cubit/cubit.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_PDF417__screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_aztec__screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_codabar__screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_code_128__screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_code_39__screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_code_93__screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_datamatrix_screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_ean13_screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_ean8_screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_itf-14__screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_upc_a_screens.dart';
import 'package:qr_code/screens/barcode_screen/generate_barcode_upc_e_screens.dart';

class GenerateScreenForBarcode extends StatefulWidget {
  const GenerateScreenForBarcode({Key? key}) : super(key: key);

  @override
  State<GenerateScreenForBarcode> createState() => _GenerateScreenForBarcodeState();
}

class _GenerateScreenForBarcodeState extends State<GenerateScreenForBarcode> {
  void initState() {
    // TODO: implement initState
    super.initState();
    AdsCubit.get(context).loadInterstitialAd();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AdsCubit.get(context).interstitialAd!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){},
        builder: (context,state){
          var adCubit = AdsCubit.get(context);
        return Scaffold(
          appBar:AppBar(
            title: Text('Barcodes'),
            backgroundColor:  Theme.of(context).bottomAppBarColor,
          ),
          body:SingleChildScrollView(
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                 defaultGenerateBarcodeWitImageListView(
                   context: context,
                     image:'datamatrix.png',
                     size:40,
                     label:'Data Matrix',
                     caption:'text without special characters',
                     onTap:(){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeDataMatrixScreen());
                       });

                     }
                 ),
                 defaultGenerateBarcodeWitImageListView(
                          context: context,
                     image: 'PDF417.png',
                     size: 40,
                     label: 'PDF 417',
                     caption:'text',
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodePDF417Screen());
                         });

                     }
                 ),
                 defaultGenerateBarcodeWitImageListView(
                          context: context,
                     image: 'aztec.png',
                     size: 40,
                     label: 'Aztec',
                     caption:'text without special characters',
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeAztecScreen());
                         });

                     }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                   icon: FontAwesomeIcons.barcode,
                   size: 40,
                   label: 'EAN 13',
                   caption:'12 digits + 1 checksum digit' ,
                   onTap: (){
                       adCubit.showInterstitialAd().then((value) {
                         defaultNavigateTo(context, GenerateBarcodeEan13Screen());
                       });

                   }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label:'EAN 8',
                     caption:'8 digit',
                     onTap:(){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeEan8Screen());
                         });

                     }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label: 'UPC E',
                     caption:'7 digits + 1 checksum digit' ,
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeUPC_E_Screen());
                         });


                     }
                 ),

                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label: 'UPC A',
                     caption:'11 digits + 1 checksum digit' ,
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeUPC_A_Screen());
                         });

                     }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label: 'Code 128',
                     caption:'text without special characters' ,
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeCode128Screen());
                         });

                     }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label: 'Code 93',
                     caption:'text in uppercase without special characters' ,
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeCode93Screen());
                         });

                     }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label: 'Code 39',
                     caption:'text in uppercase without special characters' ,
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeCode39Screen());
                         });

                     }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label: 'Codabar',
                     caption:'digits' ,
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeCodabarScreen());
                         });

                     }
                 ),
                  defaultGenerateBarcodeWithIconListView(
                      context: context,
                     icon: FontAwesomeIcons.barcode,
                     size: 40,
                     label: 'ITF-14',
                     caption:'13 + check digit' ,
                     onTap: (){
                         adCubit.showInterstitialAd().then((value) {
                           defaultNavigateTo(context, GenerateBarcodeITF14Screen());
                         });

                     }
                 ),
                ],
              ),
            ),
          ),
        );
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code/ads_package/cubit/cubit.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/barcode_screen/generate_screen_for_barcode.dart';
import 'package:qr_code/screens/generate_App_qr_screens.dart';
import 'package:qr_code/screens/generate_geo_location_qr_screens.dart';
import 'package:qr_code/screens/generate_clipboard_qr_screens.dart';
import 'package:qr_code/screens/generate_phone_qr_screens.dart';
import 'package:qr_code/screens/generate_send_email_qr_screens.dart';
import 'package:qr_code/screens/generate_sms_qr_screens.dart';
import 'package:qr_code/screens/generate_text_qr_screens.dart';
import 'package:qr_code/screens/generate_url_qr_screens.dart';
import 'package:qr_code/screens/generate_vcalender_qr_screens.dart';
import 'package:qr_code/screens/generate_vcard_qr_screens.dart';
import 'package:qr_code/screens/generate_wifi_qr_screens.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({Key? key}) : super(key: key);

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){},
        builder: (context,state){
          var adCubit = AdsCubit.get(context);
        return Scaffold(
          body: Container(
            color:Theme.of(context).backgroundColor,
            child: Column(
              children: [
               Expanded(
                 child:LayoutBuilder(
                       builder: (builder,constrains){
                         return GridView.count(
                         childAspectRatio: 12/7.82,
                         controller:  ScrollController(keepScrollOffset: false),
                         shrinkWrap: true,
                         physics: BouncingScrollPhysics(),
                         crossAxisCount: constrains.maxWidth >600?4:constrains.maxWidth <600 &&constrains.maxWidth >300 ?2:1,
                         padding: EdgeInsets.symmetric(
                             horizontal: 10, vertical: 15),
                         children: [

                           defaultGenerateListView(
                             context: context,
                               icon: Icons.text_snippet,
                               label: 'Text',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(context,GenerateTextScreen());
                                 });

                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.copy,
                               label: 'Clipboard',
                               onTap: () async {

                                 var copiedData = await Clipboard.getData(Clipboard.kTextPlain);
                                 if(copiedData != null){

                                   adCubit.loadInterstitialAd().then((value){
                                       defaultNavigateTo(context, GenerateClipboardScreen(
                                         copiedData: copiedData.text,));
                                   });
                                 }else{
                                  defaultToastMessage(context: context,msg: 'Clipboard is empty', color: Color(0xff900e0e));
                                 }

                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.add_link,
                               label: 'URL',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(context, GenerateURLScreen());
                                 });
                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.phone,
                               label: 'Phone',
                               onTap: () async {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(
                                         context, GeneratePhoneScreen());
                                 });

                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.contact_mail,
                               label: 'Contact/Vcard',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(
                                         context, GenerateVcardScreen());
                                 });

                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.email,
                               label: 'SMS',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(context, GenerateSMSScreen());
                                 });

                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.alternate_email,
                               label: 'Email',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(
                                         context, GenerateSendEmailScreen());
                                 });
                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: FontAwesomeIcons.barcode,
                               label: 'Barcodes',
                               onTap: () {
                                     defaultNavigateTo(
                                         context, const GenerateScreenForBarcode());
                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.location_on,
                               label: 'Location',
                               onTap: () {

                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(
                                         context, GenerateGeoLocationScreen());
                                 });

                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.apps,
                               label: 'Application',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(context, GenerateAppsScreen());
                                 });
                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.wifi,
                               label: 'Wi-Fi',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(context, GenerateWIFIScreen());
                                 });

                               }
                           ),
                           defaultGenerateListView(
                              context: context,
                               icon: Icons.event,
                               label: 'Event',
                               onTap: () {
                                 adCubit.loadInterstitialAd().then((value){
                                     defaultNavigateTo(
                                         context, GenerateCalendarEventScreen());
                                 });

                               }
                           ),
                         ],

                       );}
                 )
               ),
              ],
            ),
          ),
        );
        }
    );
  }
}

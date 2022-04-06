
import 'package:barcode_widget/barcode_widget.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/screens/barcode_screen/get_barcode_image.dart';
import 'package:qr_code/screens/get_qrcode_image.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'ads_package/ads_models/banner_ad_model.dart';

// var time = DateFormat('hh:mm a').format(DateTime.now()).toString();
// var date = DateTime.now().toString().substring(0,11);

Permission? askPermission;

Widget defaultTextField({
  required  textInputType,
  required String label,
  errorText,
  int? maxLength,
  inputFormatters,
  bool obscureText = false,
  controller,
  bool readOnly = false,
  suffixIcon,
  textCapitalization = TextCapitalization.none,
  padding = const EdgeInsets.all(25.0),
  contentPadding =const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
 int? maxLines,
 required context
})=>  Padding(
  padding: padding,
  child:   TextField(
    textCapitalization:textCapitalization ,
    inputFormatters: inputFormatters,
    maxLength:maxLength ,
    maxLines: maxLines,
    readOnly: readOnly,
    controller: controller,

    obscureText: obscureText,

    keyboardType: textInputType,

    decoration: InputDecoration(
      errorText:errorText ,
      contentPadding:contentPadding,
      suffixIcon:suffixIcon ,
      fillColor: Theme.of(context).textTheme.bodyText1!.color,
      focusColor: Colors.white,

      labelText: label,

      labelStyle: TextStyle(
        color:Colors.grey[600],
        fontSize: Theme.of(context).textTheme.bodyText1!.fontSize

      ),

    floatingLabelBehavior: FloatingLabelBehavior.never,

      border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(7)

      ),

      focusedBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(7),

        borderSide: BorderSide(

            color: Theme.of(context).bottomAppBarColor,

            width: 7

        ),

      ),

      enabledBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(7),

        borderSide: BorderSide(

            color: Theme.of(context).bottomAppBarColor,

            width: 7

        ),

      ),

    ),
    style: TextStyle(

        color: Theme.of(context).textTheme.bodyText1!.color,
        fontWeight: FontWeight.w900,
        fontSize: Theme.of(context).textTheme.bodyText1!.fontSize),

  ),
);



Widget defaultElevatedButton({
  required backgroundColor ,
  required String label,
  required  onPressed,
  context
})=> ElevatedButton(
  onPressed: onPressed,
  style: ButtonStyle(
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10,vertical: 0)),
    shape:MaterialStateProperty.all(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)
        )
    ) ,
    backgroundColor: MaterialStateProperty.all(backgroundColor),
  ),
  child: Text(
    label.toUpperCase(),
    style: TextStyle(
      color: Colors.white,
      fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
      fontWeight: FontWeight.bold,
    ),),


);


Widget defaultTextButton({
  required String label,
  required  onPressed,
    color ,
})=>TextButton(
    onPressed: onPressed,
    child: Text(label,
      style:TextStyle(
          color:color
      ) ,
    ));



 defaultGenerateListView({
     required String label,
     required IconData icon,
     required onTap,
    required context
}) {
 return  Padding(
     padding: const EdgeInsets.all(3.0),
     child: TextButton(

       style: ButtonStyle(

           overlayColor: MaterialStateProperty.all(Color(0xff04A583)),

           padding: MaterialStateProperty.all(EdgeInsets.all(5))

       ),

       onPressed: onTap,

       child: Container(

         height: MediaQuery
             .of(context)
             .size
             .height,

         width: MediaQuery
             .of(context)
             .size
             .width,

         decoration: BoxDecoration(


             color: Theme
                 .of(context)
                 .primaryColor,

             borderRadius: BorderRadius.circular(15)


         ),

         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,

           children: [

             Flexible(
                 child: Icon(icon, color: Color(0xff04A583), size: 50,)),
             SizedBox(height: 10,),
             Flexible(
               child: Text(label,

                 style: TextStyle(
                     color: Color(0xff04A583),

                     fontSize: Theme
                         .of(context)
                         .textTheme
                         .bodyText1!
                         .fontSize,

                     fontWeight: FontWeight.bold

                 ),
                 textAlign: TextAlign.center,
                 overflow: TextOverflow.ellipsis,
               ),
             ),

           ],


         ),


       ),

     ),
   );
 }

   defaultGenerateBarcodeWithIconListView({
     required context,
     required String label,
     required String caption,
     required IconData icon,
     required onTap,
     double size = 40,
   })=> TextButton(
     style: ButtonStyle(
         overlayColor: MaterialStateProperty.all(Color(0xff04A583)),
         padding:MaterialStateProperty.all(EdgeInsets.all(2))
     ),
     onPressed: onTap,
     child:   Container(
       padding: EdgeInsets.only(left: 15),
       width: double.infinity,
       height: 80,
       decoration: BoxDecoration(

           color: Theme.of(context).primaryColor,

           borderRadius: BorderRadius.circular(8)

       ),

       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.start,

         children: [
           Icon(icon,color:Color(0xff04A583),size: size,),
           SizedBox(width:  10,),

           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   label,

                   style: TextStyle(color:Color(0xff04A583),

                       fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,

                       fontWeight: FontWeight.bold

                   ),
                 ),
                 SizedBox(height:  5,),

                 Text(
                   caption,

                   style: TextStyle(color:Color(0xff04A583),

                       fontSize: Theme.of(context).textTheme.caption!.fontSize,

                       fontWeight: FontWeight.bold

                   ),),
               ],
             ),
           )
         ],

       ),

     ),
   );



   defaultGenerateBarcodeWitImageListView({
     required String label,
     required String caption,
     required String image,
     required onTap,
     context,
     double size = 60,
   })=> TextButton(
     style: ButtonStyle(
         overlayColor: MaterialStateProperty.all(Color(0xff04A583)),
         padding:MaterialStateProperty.all(EdgeInsets.all(2))
     ),
     onPressed: onTap,
     child:   Container(
       padding: EdgeInsets.only(left: 15),
       width: double.infinity,
       height: 80,
       decoration: BoxDecoration(

           color: Theme.of(context).primaryColor,

           borderRadius: BorderRadius.circular(8)

       ),

       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.start,

         children: [
           Image(image: AssetImage('images/$image'),
             fit: BoxFit.fill,
             width: 40,
             height:40,
             color: Color(0xff04A583),),
           SizedBox(width:  10,),

           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(
                   label,

                   style: TextStyle(color:Color(0xff04A583),

                       fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,

                       fontWeight: FontWeight.bold

                   ),
                 ),
                 SizedBox(height:  5,),

                 Text(
                   caption,

                   style: TextStyle(color:Color(0xff04A583),

                       fontSize: Theme.of(context).textTheme.caption!.fontSize,

                       fontWeight: FontWeight.bold

                   ),),
               ],
             ),
           )
         ],

       ),

     ),
   );




   defaultShowDialog({
     required context,
     required String text,

   })=>showDialog(
     barrierDismissible: false,
     context: context,
     builder: (context)=> Dialog(
       child: Container(
         width: 0,
         color: Theme.of(context).primaryColor,
         padding: EdgeInsets.symmetric(vertical: 15,horizontal: 35),
         child: Row(
           children: [
             CircularProgressIndicator(
               color: Color(0xff04A583),
             ),
             SizedBox(width: 25,),
             Expanded(
               child: Text(text,
                 style: TextStyle(
                   fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                   fontWeight: FontWeight.bold,
                   color: Color(0xff04A583),
                 ),
               ),
             ),
           ],),
       ),
     ) ,

   );



   defaultDeviceAppShowDialog({
     required context,
     required String text,

   })=>showDialog(
       barrierDismissible: false,
       context: context,
       builder: (context){
         return Dialog(
           child: Container(
             padding: EdgeInsets.symmetric(vertical: 15,horizontal: 35),
             child: Row(
               children: [
                 CircularProgressIndicator(
                   color: Colors.yellow[800],
                 ),
                 SizedBox(width: 25,),
                 Text(text,
                   style: TextStyle(
                     fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                     fontWeight: FontWeight.bold,
                     color: Colors.yellow[800],
                   ),
                 ),
               ],),
           ),
         );}

   );

   defaultAlertShowDialog({
     required context,
     required String text,
     String greenButton = 'Cancel',
     String redButton = 'Delete',
     onPress
   })=>showDialog(
     barrierDismissible: true,
     context: context,
     builder: (context)=> Dialog(
       child: Padding(
         padding: EdgeInsets.only(bottom: 0,left:15,right: 15,top: 15),
         child: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(
               text,
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                 fontWeight: FontWeight.bold,
                 color: Color(0xff04A583),
               ),
             ),

             Expanded(
               flex: 0,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   Flexible(
                     child: TextButton(
                         style: ButtonStyle(

                             padding: MaterialStateProperty.all(EdgeInsets.zero)
                         ),
                         onPressed: (){
                           Navigator.pop(context);
                         }, child: Text(greenButton,
                       textAlign: TextAlign.center,
                       style: TextStyle(
                           color: Color(0xff04A583),
                           fontSize:  Theme.of(context).textTheme.bodyText1!.fontSize
                       ),)),
                   ),
                   SizedBox(width: 5,),
                   Flexible(
                     child: TextButton(
                         style: ButtonStyle(
                             padding: MaterialStateProperty.all(EdgeInsets.zero)
                         ),
                         onPressed: onPress,
                         child: Text(
                           redButton,
                           style: TextStyle(
                               color: Colors.redAccent,
                               fontSize:  Theme.of(context).textTheme.bodyText1!.fontSize
                           ),
                         )),
                   ),
                 ]
                 ,),
             ),
           ],),
       ),
     ) ,

   );

   navigatePopByTimer({required context, int seconds = 1}){

     Future.delayed(
         Duration(seconds:seconds ),(){
       Navigator.pop(context);
     });
   }

   doSomethingByTimerSec({required context, int seconds = 1,required function}){

     Future.delayed(
         Duration(seconds:seconds ),function);
   }

   doSomethingByTimerMill({required context, int milliseconds = 500,required function}){

     Future.delayed(
         Duration(milliseconds:milliseconds ),function);
   }

   Widget defaultDivider()=>Divider(
     height: 1,
     color: Colors.grey[300],
     thickness: .7,
   );

   navigateTo({
     required route,
     required  context})
   =>  Navigator.push(
       context,
       MaterialPageRoute(
           builder: (context)=>
           route));

   navigateToAndGetData({
     required route,
     required  context,
     required index

   })
   =>  Navigator.push(
       context,
       MaterialPageRoute(
           builder: (context)=>
           route)).then((value) {
     index;
   });

   defaultRedShowDialog({
     required context,
     required String text,

   })=>showDialog(
     barrierDismissible: false,
     context: context,
     builder: (context) =>
         Dialog(
           child: Container(
             decoration: BoxDecoration(
               color: Colors.grey[300],
             ),
             padding: EdgeInsets.symmetric(vertical: 15,horizontal: 35),
             child: Row(crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 CircularProgressIndicator(
                   color: Colors.red,
                 ),
                 SizedBox(width: 25,),
                 Text(text,
                   style: TextStyle(
                     fontSize:  Theme.of(context).textTheme.bodyText1!.fontSize,
                     fontWeight: FontWeight.w900,
                     color: Colors.red,
                   ),
                 ),
               ],),
           ),
         ) ,

   );


   Widget myDivider()=> Padding(
     padding: const EdgeInsetsDirectional.only(start: 25),
     child: Container(
       color: Colors.grey[350], height: 1.0,
     ),
   );

//snapshot successfully saved
   defaultToastMessage({
     required msg ,
     required color,
     required context,
     int timeInSecForIosWeb =2,
     gravity = ToastGravity.BOTTOM
   }){
     Fluttertoast.showToast(msg: msg,
         backgroundColor: color,
         fontSize:  Theme.of(context).textTheme.bodyText1!.fontSize,
         timeInSecForIosWeb: timeInSecForIosWeb,
         gravity: gravity
     );

   }



   defaultNavigateTo(context,route)=> Navigator.push(context,
       MaterialPageRoute(builder:(context)=>
       route));


   defaultWhereToLaunchButton({
     required context,
     required onPress,
     required IconData icon,
     required String text

   })=>TextButton(
     onPressed: onPress,
     style:ButtonStyle(
         padding: MaterialStateProperty.all(
           EdgeInsets.symmetric(vertical: 5,horizontal: 0),
         ) ,
         overlayColor: MaterialStateProperty.all(
             Colors.grey.shade700
         )
     ) ,

     child: Container(
       width: double.infinity,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(10),
         color:Theme.of(context).primaryColor,
       ),
       padding: EdgeInsets.all(15),

       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [

           Icon(icon,color: Color(0xff04A583),size: 40,),
           SizedBox(width: 20,),
           Expanded(
             child: Text(text.toUpperCase(),
               style: TextStyle(color:Color(0xff04A583),
                 fontSize: Theme.of(context).textTheme.bodyText1!.fontSize, ),

             ),
           ),
         ],
       ),


     ),
   );



   defaultShowBarcodeButton({
     required onPress,
     required IconData icon,
     required String text,
     required  context
   })=>TextButton(
     onPressed: onPress,
     style:ButtonStyle(
         padding: MaterialStateProperty.all(
           EdgeInsets.symmetric(vertical: 5,horizontal: 0),
         ) ,
         overlayColor: MaterialStateProperty.all(
             Colors.grey.shade700
         )
     ) ,

     child: Container(
       width: double.infinity,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(10),
         color: Theme.of(context).primaryColor,
       ),
       padding: EdgeInsets.all(15),

       child: Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [

           Container(child: Icon(icon,color: Color(0xff04A583),size: 40,)),
           SizedBox(width: 20,),
           Expanded(
             child: Text(text.toUpperCase(),
               style: TextStyle(color:Color(0xff04A583),
                 fontSize: Theme.of(context).textTheme.bodyText1!.fontSize, ),

             ),
           ),
           Spacer(),
           Icon(ScanCodeCubit.get(context).showBarcodeList == false?
           Icons.keyboard_arrow_down_sharp:
           Icons.keyboard_arrow_up_sharp,
             color: Color(0xff04A583),
           )
         ],
       ),


     ),
   );

   buildCodeDetailsForScannedCreatedFavourites(BuildContext context, String textValue, ScanCodeCubit cubit)  {
     return SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(

           children: [
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Theme.of(context).primaryColor,
               ),
               padding: EdgeInsets.all(15),

               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   //if textValue == email
                   if(textValue.startsWith('MATMSG:')|| textValue.startsWith('MATMSG:TO:')) //if textValue == email
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.alternate_email,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('${textValue
                                   .replaceAll('MATMSG:TO:', 'TO:')
                                   .replaceAll('SUB:', 'SUB:')
                                   .replaceAll(';', '\n')
                                   .replaceAll('BODY:', 'BODY:')
                               }',
                                 style: TextStyle(
                                   color:Color(0xff04A583),
                                   fontSize: 16,),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),//test
                   //if textValue == Wifi
                   if(textValue.startsWith('WIFI:T')||textValue.startsWith('WIFI:S')) //if textValue == Wifi
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.wifi,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('${textValue
                                   .replaceAll('WIFI:T:',"")
                                   .replaceAll('WIFI:S:',"")
                                   .replaceAll(';T:', '\n')
                                   .replaceAll(';S:', '\n')
                                   .replaceAll(';P:', '\n')
                                   .replaceAll(';;', '')
                               }',
                                 style: TextStyle(
                                   color:Color(0xff04A583),
                                   fontSize: 16,  ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),//test

                   if(textValue.contains('END:VCALENDAR') || textValue.contains('BEGIN:VCALENDAR') || textValue.contains('BEGIN:VEVENT')) //if textValue == BEGIN:VCALENDAR

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.event,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                   fontSize: 16, ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                   if(textValue.contains('BEGIN:VCARD') || textValue.contains('END:VCARD')) //if textValue == BEGIN:VCARD

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.contact_mail,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                   fontSize: 16,  ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                   if(textValue.contains('mailto:')||
                       textValue.contains('MAILTO:')) //if textValue ==  mailto
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.alternate_email,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                   fontSize: 16,  ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                   if(textValue.startsWith('GEO:')||textValue.startsWith('geo:')||textValue.contains('maps.app.goo.gl')||
                       textValue.contains('maps.google.com')||textValue.contains('MAPS.GOOGLE.COM')) //if textValue ==  mailto
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.location_on_sharp,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                   fontSize: 16, ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                   if(textValue.startsWith('SMSTO:')||textValue.startsWith('smsto'))
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.textsms,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                     fontSize:16 ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                   if(textValue.startsWith('tel:')||textValue.startsWith('TEL:'))
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.phone,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                     fontSize:16 ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   if(textValue.contains('PLAY.GOOGLE.COM')||textValue.contains('play.google.com'))
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.apps_outlined,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                     fontSize:16 ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                   if(int.tryParse(textValue.toString()) != null)
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(FontAwesomeIcons.barcode,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                     fontSize:16 ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                   if((textValue.startsWith('http://')||
                       textValue.startsWith('HTTP://')||
                       textValue.startsWith('https://')||
                       textValue.startsWith('HTTPS://')||
                       textValue.startsWith('WWW.')||
                       textValue.startsWith('www.'))&&
                       !(textValue.contains('maps.google.com')||
                           textValue.contains('maps.app.goo.gl')||
                           textValue.contains('MAPS.GOOGLE.COM')||
                           textValue.contains('PLAY.GOOGLE.COM')||
                           textValue.contains('play.google.com'))
                   )
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.language_outlined,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                     fontSize:16 ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),



                   if(!(textValue.contains('mailto:')||
                       textValue.contains('MAILTO:')||
                       textValue.contains('BEGIN:VCARD') ||
                       textValue.contains('END:VCARD')||textValue.contains('END:VCALENDAR')
                       || textValue.contains('BEGIN:VCALENDAR') || textValue.contains('BEGIN:VEVENT')||
                       textValue.startsWith('WIFI:T')||textValue.startsWith('WIFI:S')||
                       textValue.startsWith('MATMSG:')|| textValue.startsWith('MATMSG:TO:')||
                       textValue.startsWith('GEO:')||textValue.startsWith('geo:')||
                       textValue.contains('maps.app.goo.gl')||
                       textValue.contains('MAPS.GOOGLE.COM')||textValue.contains('maps.google.com')||
                       textValue.contains('PLAY.GOOGLE.COM')&&textValue.contains('play.google.com')||
                       textValue.startsWith('SMSTO:')||textValue.startsWith('smsto:')||
                       textValue.startsWith('tel:')||textValue.contains('TEL:')||
                       textValue.contains('PLAY.GOOGLE.COM')||textValue.contains('play.google.com')||
                       textValue.startsWith('http://')||
                       textValue.startsWith('HTTP://')||
                       textValue.startsWith('https://')||
                       textValue.startsWith('HTTPS://')||
                       textValue.startsWith('WWW.')||
                       textValue.startsWith('www.')||
                       int.tryParse(textValue.toString()) != null

                   ))
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Icon(Icons.text_snippet,color: Color(0xff04A583),size: 25,),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                             Expanded(
                               child: Text('$textValue',

                                 style: TextStyle(color:Color(0xff04A583),

                                     fontSize:16 ),

                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   SizedBox(height: 15,),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       Flexible(
                         child: TextButton(
                             style:ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)) ,
                             onPressed: ()async{
                               Clipboard.setData((ClipboardData(text: textValue)));
                               defaultToastMessage(context: context,msg: 'Copied ', color: Theme.of(context).bottomAppBarColor,);
                             },
                             child: Column(
                               children: [
                                 Icon(Icons.copy,
                                   size: 25,
                                   color: Color(0xff04A583),
                                 ),
                                 Text('Copy',
                                   style: TextStyle(color: Color(0xff04A583),fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,),)
                               ],
                             )),
                       ),
                       Flexible(
                         child: TextButton(
                             style:ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)) ,
                             onPressed: (){

                               Share.share('$textValue');
                             },
                             child: Column(
                               children: [
                                 Icon(Icons.share,
                                   size: 25,
                                   color: Color(0xff04A583),
                                 ),
                                 Text('Share',
                                   style: TextStyle(color: Color(0xff04A583),fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,),)
                               ],
                             )),
                       ),

                     ],
                   )

                 ],
               ),


             ),
             SizedBox(height: 5,),


             defaultWhereToLaunchButton(
                 context: context,
                 text:'View QR Code' ,
                 icon: Icons.qr_code_scanner_rounded,
                 onPress:(){
                   defaultNavigateTo(context, GetQrCodeImage(textValue) );
                 }
             ),

             defaultShowBarcodeButton(
                 context: context,
                 text:'View Barcode' ,
                 icon: FontAwesomeIcons.barcode,
                 onPress:(){
                   cubit.toggleToShowBarcodeList();
                 }
             ),
             if(cubit.showBarcodeList == true)
               Column(
                 children: [
                   if(textValue.isNotEmpty && textValue != null )
                     defaultGenerateBarcodeWitImageListView(
                         context: context,
                         image: 'datamatrix.png',
                         size: 40,
                         label: 'Data Matrix',
                         caption:'text without special characters',
                         onTap: (){
                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.dataMatrix(),
                                     height: 260,
                                     width: 260,

                                   )
                               ));
                         }
                     ),
                   defaultGenerateBarcodeWitImageListView(
                       context: context,
                       image: 'PDF417.png',
                       size: 40,
                       label: 'PDF 417',
                       caption:'text',
                       onTap: (){
                         Navigator.push(context,
                             MaterialPageRoute(
                                 builder:(context)=>
                                     GetBarcodeImage(
                                       copiedData: textValue,
                                       barcodeType: Barcode.pdf417(),

                                     )
                             ));
                       }
                   ),
                   if( textValue != null && textValue.length > 0)
                     defaultGenerateBarcodeWitImageListView(
                         context: context,
                         image: 'aztec.png',
                         size: 40,
                         label: 'Aztec',
                         caption:'text without special characters',
                         onTap: (){
                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.aztec(),
                                     height: 260,
                                     width: 260,

                                   )));
                         }
                     ),
                   if(textValue.length == 12 && int.tryParse(textValue) is int )
                     defaultGenerateBarcodeWithIconListView(
                         context: context,
                         icon: FontAwesomeIcons.barcode,
                         size: 40,
                         label: 'EAN 13',
                         caption:'12 digits + 1 checksum digit' ,
                         onTap: (){

                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.ean13(),
                                   )));
                         }
                     ),
                   if(textValue.length == 7 && int.tryParse(textValue) is int )
                     defaultGenerateBarcodeWithIconListView(
                         context: context,
                         icon: FontAwesomeIcons.barcode,
                         size: 40,
                         label: 'EAN 8',
                         caption:'8 digit' ,
                         onTap: (){

                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.ean8(),
                                   )));
                         }
                     ),
                   if(textValue.length == 7 && (textValue.startsWith('0') || textValue.startsWith('1') ) && int.tryParse(textValue) is int )
                     defaultGenerateBarcodeWithIconListView(
                         context: context,
                         icon: FontAwesomeIcons.barcode,
                         size: 40,
                         label: 'UPC E',
                         caption:'7 digits + 1 checksum digit' ,
                         onTap: (){

                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.upcE(),
                                   )));
                         }
                     ),
                   if(textValue.length == 11 && int.tryParse(textValue) is int )
                     defaultGenerateBarcodeWithIconListView(
                         context: context,
                         icon: FontAwesomeIcons.barcode,
                         size: 40,
                         label: 'UPC A',
                         caption:'11 digits + 1 checksum digit' ,
                         onTap: (){

                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.upcA(),
                                   )));
                         }
                     ),

                   if(int.tryParse(textValue) is int && textValue != null && textValue.length > 0)
                     defaultGenerateBarcodeWithIconListView(
                         context: context,
                         icon: FontAwesomeIcons.barcode,
                         size: 40,
                         label: 'Codabar',
                         caption:'digits' ,
                         onTap: (){

                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.codabar(),
                                   )));
                         }
                     ),
                   if(textValue.length == 13 && int.tryParse(textValue) is int )
                     defaultGenerateBarcodeWithIconListView(
                         context: context,
                         icon: FontAwesomeIcons.barcode,
                         size: 40,
                         label: 'ITF-14',
                         caption:'13 + check digit' ,
                         onTap: (){

                           Navigator.push(context,
                               MaterialPageRoute(builder:(context)=>
                                   GetBarcodeImage(
                                     copiedData: textValue,
                                     barcodeType: Barcode.itf14(),
                                   )));
                         }
                     ),
                 ],
               ),


             //for ical and vcal
             if(textValue.contains('END:VCALENDAR') || textValue.contains('BEGIN:VCALENDAR') || textValue.contains('BEGIN:VEVENT') || textValue.contains('BEGIN:VEVENT')) //if textValue == BEGIN:VCALENDAR
               Column(
                 children: [

                   defaultWhereToLaunchButton(
                       context: context,
                       text:'Add event' ,
                       icon: Icons.event_available_outlined,
                       onPress:()async{
                         print(cubit.calendarToMap.strDate);
                         var status = await Permission.calendar.status;
                         if(status.isGranted) {
                           cubit.parseICalender(textValue).then((value){
                             launch('https://www.google.com/calendar/render?action=TEMPLATE&text=${cubit.calendarToMap.title}&dates=${cubit.calendarToMap.strDate}/${cubit.calendarToMap.endDate}&details=${cubit.calendarToMap.description}&location=${cubit.calendarToMap.location}&sf=true&output=xml',);

                           }).catchError((r){
                             print('error' +r.toString());
                           });
                         }else{
                           await Permission.calendar.request();
                         }

                       }
                   ),

                 ],
               ),



             if(textValue.contains('BEGIN:VCARD') || textValue.contains('END:VCARD')) //if textValue == BEGIN:VCARD
               Column(
                 children: [
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'Call' ,
                       icon: Icons.call,
                       onPress:()async{
                         var status = await Permission.contacts.status;
                         if(status.isGranted) {
                           cubit.parseVcard(textValue).then((value)async{
                             if(cubit.vcardToMap.phoneNumber != null || cubit.vcardToMap.phoneNumber != ''){
                               await launch("tel:${cubit.vcardToMap.phoneNumber}");
                             }else{
                               await launch("tel:${cubit.vcardToMap.phoneWork}");
                             };

                           });
                         }else{
                           await   Permission.contacts.request();
                         }

                       }
                   ),
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'Add Contact' ,
                       icon: Icons.person_add_sharp,
                       onPress:()async{
                         var status = await Permission.contacts.status;
                         if(status.isGranted) {
                           cubit.parseVcard(textValue).then((value)async{
                             var contact =  Contact(
                               familyName:cubit.vcardToMap.name ,
                               phones:[Item(label: "mobile", value: cubit.vcardToMap.phoneNumber),Item(label: "work", value: cubit.vcardToMap.phoneWork)],
                               emails:[Item(label: "emails", value: cubit.vcardToMap.email)] ,
                               postalAddresses:[PostalAddress(city: cubit.vcardToMap.address,)],

                             );
                             ContactsService.addContact(contact).then((value) async{
                               defaultToastMessage(context: context,msg: 'Contact added successfully', color: Color(0xff04A583),timeInSecForIosWeb: 3);
                             });
                           });
                         }else{
                           await   Permission.contacts.request();
                         }
                       }
                   ),

                   defaultWhereToLaunchButton(
                       context: context,
                       text:'send email' ,
                       icon: Icons.alternate_email_sharp,
                       onPress:()async{
                         cubit.parseVcard(textValue).then((value)async {
                           if (await canLaunch('mailto:${cubit.vcardToMap.email}?subject=subject&body=body')) {
                             launch('mailto:${cubit.vcardToMap.email}?',);
                           } else {
                             launch('https://google.com/search?q=${cubit.vcardToMap.email}',);
                           }
                         });
                       }
                   ),

                   defaultWhereToLaunchButton(
                       context: context,
                       text:'Browse URL' ,
                       icon: Icons.link_sharp,
                       onPress:()async{
                         cubit.parseVcard(textValue).then((value)async {
                           if (await canLaunch('${cubit.vcardToMap.url}')) {
                             launch('${cubit.vcardToMap.url}',);
                           } else {
                             launch('https://google.com/search?q=${cubit.vcardToMap.url}',);
                           }
                         });
                       }
                   ),
                 ],
               ),

             if(textValue.contains('MATMSG:TO') || textValue.contains('MATMSG:')) //if textValue ==  MATMSG:TO
               Column(
                 children: [
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'send email' ,
                       icon: Icons.alternate_email_sharp,
                       onPress:()async{
                         cubit.parseEmail(textValue).then((value)async {
                           if (await canLaunch('mailto:${cubit.emailToMap.to}?subject=${cubit.emailToMap.sub}&body=${cubit.emailToMap.body}')) {
                             launch('mailto:${cubit.emailToMap.to}?subject=${cubit.emailToMap.sub}&body=${cubit.emailToMap.body}');
                           } else {
                             launch('https://google.com/search?q=${cubit.emailToMap.to}',);
                           }
                         });
                       }
                   ),

                 ],
               ),
             if(textValue.contains('mailto:')) //if textValue ==  MATMSG:TO
               Column(
                 children: [
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'send email' ,
                       icon: Icons.alternate_email_sharp,
                       onPress:()async{
                         cubit.parseEmail(textValue).then((value)async {
                           if (await canLaunch('$textValue')) {
                             launch('$textValue');
                           } else {
                             launch('https://google.com/search?q=${cubit.emailToMap.to}',);
                           }
                         });
                       }
                   ),

                 ],
               ),


             if(textValue.contains('SMSTO:') || textValue.contains('smsto:')) //if textValue ==  MATMSG:TO
               Column(
                 children: [
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'send sms' ,
                       icon: Icons.message_outlined,
                       onPress:()async{
                         cubit.parseSMS(textValue).then((value) async {
                           if (await canLaunch('sms:${cubit.smsToMap.phoneNumber}?body=${cubit.smsToMap.body}')) {
                             launch('sms:${cubit.smsToMap
                                 .phoneNumber}?body=${cubit.smsToMap.body}');
                           }
                         });
                       }
                   ),

                 ],
               ),


             if(textValue.contains('geo:') || textValue.contains('GEO:')) //if textValue ==  Geo:Location
               Column(
                 children: [
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'OPEN LOCATION' ,
                       icon: Icons.location_on_sharp,
                       onPress:()async{
                         cubit.parseGeoMap(textValue).then((value)async {
                           if (await canLaunch('https://www.google.com/maps/search/${cubit.geoMapToMap.lat},${cubit.geoMapToMap.long}')) {
                             launch('https://www.google.com/maps/search/${cubit.geoMapToMap.lat},${cubit.geoMapToMap.long}');
                           } else {
                             launch('https://google.com/search?q=$textValue',);
                           }
                         });
                       }
                   ),
                 ],
               ),

             if(textValue.contains('WIFI:T')||textValue.contains('WIFI:S')) //if textValue == Wifi
               Column(
                 children: [
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'Connect WIFI' ,
                       icon: Icons.wifi,
                       onPress:()async {
                         cubit.parseWifi(textValue).then((value)async {

                           if(await WiFiForIoTPlugin.isEnabled()){

                             await   WiFiForIoTPlugin.connect(
                               '${cubit.wifiParseToMap.name.toString()}',
                               security:
                               cubit.wifiParseToMap.type == 'WPA'? NetworkSecurity.WPA:
                               cubit.wifiParseToMap.type == 'WEP'? NetworkSecurity.WEP:
                               cubit.wifiParseToMap.type == 'WPA2'? NetworkSecurity.WPA:
                               cubit.wifiParseToMap.type == 'null'? NetworkSecurity.NONE:
                               cubit.wifiParseToMap.type == ''? NetworkSecurity.NONE:NetworkSecurity.NONE,
                               password:cubit.wifiParseToMap.pass != 'null'? cubit.wifiParseToMap.pass:
                               cubit.wifiParseToMap.pass != ''?cubit.wifiParseToMap.pass:null,
                             ).catchError((e){
                               defaultToastMessage(context: context,msg: 'Can\'t open', color: Color(0xff323739));
                             });
                           }else{
                             defaultToastMessage(context: context,msg: 'WIFI disabled', color: Color(0xff323739));
                           }
                         });
                       }
                   ),

                 ],
               ),
             if(textValue.startsWith('TEL:') || textValue.startsWith('tel:')) //if textValue == BEGIN:VCARD
               Column(
                   children: [
                     defaultWhereToLaunchButton(
                         context: context,
                         text:'Call' ,
                         icon: Icons.call,
                         onPress:()async{
                           var status = await Permission.contacts.status;
                           if(status.isGranted) {
                             cubit.parseVcard(textValue).then((value)async{
                               if(cubit.vcardToMap.phoneNumber != null || cubit.vcardToMap.phoneNumber != ''){
                                 await launch("tel:${cubit.vcardToMap.phoneNumber}");
                               }else{
                                 await launch("tel:${cubit.vcardToMap.phoneWork}");
                               };

                             });
                           }else{
                             await   Permission.contacts.request();
                           }

                         }
                     ),
                   ]),
             if(!(textValue.contains('MECARD:') || textValue.contains('MECARD;')||textValue.contains('mecard:')|| textValue.contains('BEGIN:VCARD') || textValue.contains('END:VCARD'))) //if textValue ==  Geo:Location
               Column(
                 children: [
                   defaultWhereToLaunchButton(
                       context: context,
                       text:'Browse URL' ,
                       icon: Icons.link,
                       onPress:()async{
                         if (await canLaunch('$textValue}')) {
                           launch('$textValue');
                         } else {
                           launch('https://google.com/search?q=$textValue',);
                         }
                       }
                   ),

                 ],
               ),
             BannerAdModel(adSizedRectangle: true,),
           ],
         ),

       ),
     );
   }

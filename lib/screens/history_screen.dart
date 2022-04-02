import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code/ads_package/ad_helper/ads_helper.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/screens/every_single_code_createdHistory.dart';

import 'every_single_code_scannedHistory.dart';



class HistoryScreen extends StatelessWidget {
  TabController? tabController;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){},
    builder: (context,state){

        var  cubit = ScanCodeCubit.get(context);
    return DefaultTabController(
      length: 2,
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd){
          final metrics = scrollEnd.metrics;
          if (metrics.atEdge) {
            bool isTop = metrics.pixels == 0;
            if (isTop) {
              cubit.listScrollToggleFalse();
              print('At the top');
            } else {
              cubit.listScrollToggleTrue();
              print('At the bottom');
            }
          }else{
            cubit.listScrollToggleFalse();
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).bottomAppBarColor,
            toolbarHeight: 0,
            bottom: TabBar(
              controller: tabController,
                onTap:(index){

                cubit.currentHistoryIndex(index);
                if( index == 1)
                  doSomethingByTimerMill(context: context, function: (){ cubit.listScrollToggleFalse();});

                } ,
                labelColor:Theme.of(context).textSelectionTheme.selectionColor ,
                unselectedLabelColor: Colors.grey[600],
                tabs:[

                  Tab(child: Text('Scanned history',style: TextStyle(fontSize:Theme.of(context).textTheme.bodyText1!.fontSize),)),
                  Tab(child: Text('Created history',style: TextStyle(fontSize:Theme.of(context).textTheme.bodyText1!.fontSize)),),

            ]),
          ),

          floatingActionButton: !cubit.isListScrollDown ?FloatingActionButton(
              mini: true,
              backgroundColor: Theme.of(context).bottomAppBarColor,
              child: Icon(Icons.delete_forever,color: Colors.white,size: 20,),
              onPressed: (){
                if(cubit.historyIndex == 0 ){
                  if(cubit.scannedList.isNotEmpty){
                    defaultAlertShowDialog(
                        context: context,
                        text: 'Are you sure you want to delete All Scanned items?',
                        onPress: (){
                          cubit.deleteALLScanned();
                          Navigator.pop(context);
                         defaultToastMessage(context: context,msg: 'Done', color:Theme.of(context).bottomAppBarColor,);
                        });

                  }else{
                   defaultToastMessage(context: context,msg: 'Scanned is Empty', color: Color(0xff323739));
                   AdsHelper.randomIndexForInterstitialAd();
                  }
                }else if(cubit.historyIndex == 1){
                  if(cubit.createList.isNotEmpty){
                    defaultAlertShowDialog(
                        context: context,
                        text: 'Are you sure you want to delete All Created items?',
                        onPress: (){
                          cubit.deleteALLCreated();
                          Navigator.pop(context);
                         defaultToastMessage(context: context,msg: 'Done', color:Theme.of(context).bottomAppBarColor,);
                        });

                  }else{
                   defaultToastMessage(context: context,msg: 'Created is Empty', color: Color(0xff323739));
                  }
                }
              }
          ):null,
          body: Container(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: tabController,
                  children: [

                    Container(

                      padding: EdgeInsets.all(5),
                      color: Theme.of(context).backgroundColor,
                      child: ConditionalBuilder(
                        condition:cubit.scannedList.length > 0 && cubit.scannedList != null,
                        builder: (context)=> ListView.separated(
                            controller:scrollController ,
                          itemBuilder: (context,index)=>Column(
                            children: [
                              if(index == 0)
                                BannerAdModel(),
                              SizedBox(height: 2,),
                              scannedWidget(context,cubit.scannedList[index],index),
                            ],
                          ),
                          separatorBuilder:  (context,index)=>(index % 8 == 7 && index != 0)? BannerAdModel(): SizedBox(height: 5,),
                          itemCount:cubit.scannedList.length),
                        fallback:(context)=> Container(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history,size: 75,color: Colors.grey,),
                                  Text('No History',
                                    style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),),

                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                              child: BannerAdModel()),
                            ],
                          ),
                        ),
                      ) ,
                    ),
                    Container(

                      padding: EdgeInsets.all(5),
                      color:Theme.of(context).backgroundColor,
                      child: ConditionalBuilder(
                        condition:cubit.createList.length > 0 && cubit.createList != null,
                        builder: (context)=> ListView.separated(
                           controller: scrollController ,
                            itemBuilder: (context,index)=>Column(
                              children: [
                                if(index == 0)
                                BannerAdModel(),
                                SizedBox(height: 2,),
                                createdWidget(context,cubit.createList[index],index),
                              ],
                            ),
                            separatorBuilder:  (context,index)=>(index % 8 == 7 && index != 0)? BannerAdModel(): SizedBox(height: 5,),
                            itemCount:cubit.createList.length),
                        fallback:(context)=> Container(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.history,size: 75,color: Colors.grey,),
                                  Text('No History',
                                    style: TextStyle(
                                        fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),),

                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: BannerAdModel()),
                            ],
                          ),
                        ),
                      ) ,
                    ),
                  ]

            ),
          ),
        ),
      ),
    );}
    );
  }

  Widget scannedWidget(context,Map scannedList,index) {
   var cubit = ScanCodeCubit.get(context);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).primaryColor,
    ),
    padding: EdgeInsets.only(top: 15,bottom:15,left: 10,right: 5),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
         child: InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=> ViewSingleCodeScannedHistory(index: index))
              ).then((value) => cubit.falseToShowBarcodeList());

            },
             child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 if(scannedList['name'].startsWith('mailto:')||
                     scannedList['name'].startsWith('MATMSG:') ||
                     scannedList['name'].startsWith('MATMSG:TO:'))
                   cubit.historyIcons['email']!,

                 if(scannedList['name'].contains('BEGIN:VCARD') ||
                     scannedList['name'].contains('END:VCARD') ||
                     scannedList['name'].contains('END:VCALENDAR') ||
                     scannedList['name'].contains('BEGIN:VCALENDAR') ||
                     scannedList['name'].contains('BEGIN:VEVENT'))
                   cubit.historyIcons['event']!,

                 if( scannedList['name'].startsWith('WIFI:T') ||
                     scannedList['name'].startsWith('WIFI:S'))
                   cubit.historyIcons['wifi']!,

                 if(scannedList['name'].contains('GEO:') ||
                     scannedList['name'].contains('geo:')||
                     scannedList['name'].contains('maps.google.com')||
                     scannedList['name'].contains('maps.app.goo.gl')||
                     scannedList['name'].contains('MAPS.GOOGLE.COM'))
                   cubit.historyIcons['location']!,
                 if(scannedList['name'].contains('PLAY.GOOGLE.COM')||
                     scannedList['name'].contains('play.google.com'))
                   cubit.historyIcons['app']!,
                 if(scannedList['name'].startsWith('SMSTO:')||
                     scannedList['name'].startsWith('smsto:'))
                   cubit.historyIcons['sms']!,
                 if(scannedList['name'].startsWith('tel:')||
                     scannedList['name'].startsWith('TEL:'))
                   cubit.historyIcons['phone']!,

                 if(int.tryParse(scannedList['name'].toString()) != null)
                   cubit.historyIcons['barcode']!,


                 if((scannedList['name'].startsWith('http://')||
                     scannedList['name'].startsWith('HTTP://')||
                     scannedList['name'].startsWith('https://')||
                     scannedList['name'].startsWith('HTTPS://')||
                     scannedList['name'].startsWith('WWW.')||
                     scannedList['name'].startsWith('www.'))&&
                     !(scannedList['name'].contains('maps.google.com')||
                         scannedList['name'].contains('maps.app.goo.gl')||
                         scannedList['name'].contains('MAPS.GOOGLE.COM')||
                         scannedList['name'].contains('PLAY.GOOGLE.COM')||
                         scannedList['name'].contains('play.google.com'))
                 )
                   cubit.historyIcons['lang']!,

                 if(!(
                         scannedList['name'].startsWith('mailto:')||
                         scannedList['name'].startsWith('MATMSG:') ||
                         scannedList['name'].startsWith('MATMSG:TO:')||
                         scannedList['name'].contains('BEGIN:VCARD') ||
                         scannedList['name'].contains('END:VCARD') ||
                         scannedList['name'].contains('END:VCALENDAR') ||
                         scannedList['name'].contains('BEGIN:VCALENDAR') ||
                         scannedList['name'].contains('BEGIN:VEVENT')||
                         scannedList['name'].startsWith('WIFI:T') ||
                         scannedList['name'].startsWith('WIFI:S')||
                         scannedList['name'].startsWith('GEO:') ||
                         scannedList['name'].startsWith('geo:')||
                         scannedList['name'].contains('maps.google.com')||
                         scannedList['name'].contains('MAPS.GOOGLE.COM')||
                         scannedList['name'].contains('PLAY.GOOGLE.COM')||
                         scannedList['name'].contains('play.google.com')||
                         scannedList['name'].startsWith('SMSTO:')||
                         scannedList['name'].startsWith('smsto:')||
                         scannedList['name'].startsWith('tel:')||
                         scannedList['name'].startsWith('TEL:')||
                         scannedList['name'].startsWith('http://')||
                         scannedList['name'].startsWith('HTTP://')||
                         scannedList['name'].startsWith('https://')||
                         scannedList['name'].startsWith('HTTPS://')||
                         scannedList['name'].startsWith('WWW.')||
                         scannedList['name'].startsWith('www.')||
                         scannedList['name'].contains('maps.app.goo.gl')||
                         int.tryParse(scannedList['name'].toString()) != null

                 ))
                   cubit.historyIcons['text']!,
                 SizedBox(width: 10,),
                 Flexible(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('${scannedList['name']}',
                         style: TextStyle(color:Color(0xff04A583),
                             fontSize:16 ),
                         overflow: TextOverflow.ellipsis,
                         maxLines: 1,
                       ),

                       SizedBox(height:8,),

                      Text('${scannedList['dateTime']}',
                        style: TextStyle(
                          color:Theme.of(context).textTheme.caption!.color,
                          fontSize: Theme.of(context).textTheme.caption!.fontSize, ),),
                     ],
                   ),
                 ),
               ],
             ),
           ),

       ),
       Expanded(
         child: Row(
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
             Flexible(
               child: IconButton(
                 icon: Icon(
                     scannedList['status'] == 'false'? Icons.favorite_outline:Icons.favorite,
                     color: scannedList['status'] == 'false'? Colors.grey:Colors.red ),
                 onPressed: (){
                   if(scannedList['status'] == 'false') {
                     cubit.updateStatusDatabase(
                       id: scannedList['id'] ,
                       status: "true"
                     );
                     print('mina1  ${index.toString()}');
                     print(scannedList['status'].toString());
                   }else if(scannedList['status'] == 'true'){
                     cubit.updateStatusDatabase(
                         id: scannedList['id'] ,
                         status: "false"
                     );
                     print('mina2  ${index.toString()}');
                     print(scannedList['status'].toString());
                     print('id ' +scannedList['id'].toString());
                   }

                 },
               ),
             ),
             Flexible(
               child: IconButton(
                 icon: Icon(
                   Icons.delete_forever,
                   color: Colors.grey,),
                 onPressed: (){
                   defaultAlertShowDialog(
                     context: context,
                     text: 'Are you sure you want to delete this item?',
                     onPress: (){
                       cubit.deleteData(id: scannedList['id']);
                       Navigator.pop(context);
                     }
                   );
                 },
               ),
             ),
         ],),
       ),
      ],
    ),
  );
}
  Widget createdWidget(context,Map createdList,index) {
    var cubit = ScanCodeCubit.get(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:Theme.of(context).primaryColor,
      ),
      padding: EdgeInsets.only(top: 15,bottom:15,left: 10,right: 5),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              focusColor: Color(0xff04A583),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=> ViewSingleCodeCreatedHistory(index: index))
                ).then((value) => cubit.falseToShowBarcodeList());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  if(createdList['name'].startsWith('mailto:')||
                      createdList['name'].startsWith('MATMSG:') ||
                      createdList['name'].startsWith('MATMSG:TO:'))
                    cubit.historyIcons['email']!,

                  if(createdList['name'].contains('BEGIN:VCARD') ||
                      createdList['name'].contains('END:VCARD') ||
                      createdList['name'].contains('END:VCALENDAR') ||
                      createdList['name'].contains('BEGIN:VCALENDAR') ||
                      createdList['name'].contains('BEGIN:VEVENT'))
                    cubit.historyIcons['event']!,

                  if( createdList['name'].startsWith('WIFI:T') ||
                      createdList['name'].startsWith('WIFI:S'))
                    cubit.historyIcons['wifi']!,

                  if(createdList['name'].contains('GEO:') ||
                      createdList['name'].contains('geo:')||
                      createdList['name'].contains('maps.google.com')||
                      createdList['name'].contains('maps.app.goo.gl')||
                      createdList['name'].contains('MAPS.GOOGLE.COM'))
                    cubit.historyIcons['location']!,
                  if( createdList['name'].contains('PLAY.GOOGLE.COM')||
                      createdList['name'].contains('play.google.com'))
                    cubit.historyIcons['app']!,
                  if(createdList['name'].startsWith('SMSTO:')||
                      createdList['name'].startsWith('smsto:'))
                    cubit.historyIcons['sms']!,
                  if(createdList['name'].startsWith('tel:')||
                      createdList['name'].startsWith('TEL:'))
                    cubit.historyIcons['phone']!,


                  if(int.tryParse(createdList['name'].toString()) != null)
                    cubit.historyIcons['barcode']!,


                  if((createdList['name'].startsWith('http://')||
                      createdList['name'].startsWith('HTTP://')||
                      createdList['name'].startsWith('https://')||
                      createdList['name'].startsWith('HTTPS://')||
                      createdList['name'].startsWith('WWW.')||
                      createdList['name'].startsWith('www.'))&&
                      !(createdList['name'].contains('maps.google.com')||
                          createdList['name'].contains('maps.app.goo.gl')||
                          createdList['name'].contains('MAPS.GOOGLE.COM')||
                          createdList['name'].contains('PLAY.GOOGLE.COM')||
                          createdList['name'].contains('play.google.com'))
                  )
                    cubit.historyIcons['lang']!,

                  if(!(
                      createdList['name'].startsWith('mailto:')||
                          createdList['name'].startsWith('MATMSG:') ||
                          createdList['name'].startsWith('MATMSG:TO:')||
                          createdList['name'].contains('BEGIN:VCARD') ||
                          createdList['name'].contains('END:VCARD') ||
                          createdList['name'].contains('END:VCALENDAR') ||
                          createdList['name'].contains('BEGIN:VCALENDAR') ||
                          createdList['name'].contains('BEGIN:VEVENT')||
                          createdList['name'].startsWith('WIFI:T') ||
                          createdList['name'].startsWith('WIFI:S')||
                          createdList['name'].startsWith('GEO:') ||
                          createdList['name'].startsWith('geo:')||
                          createdList['name'].contains('maps.google.com')||
                          createdList['name'].contains('MAPS.GOOGLE.COM')||
                          createdList['name'].contains('PLAY.GOOGLE.COM')||
                          createdList['name'].contains('play.google.com')||
                          createdList['name'].startsWith('SMSTO:')||
                          createdList['name'].startsWith('smsto:')||
                          createdList['name'].startsWith('tel:')||
                          createdList['name'].startsWith('TEL:')||
                          createdList['name'].startsWith('http://')||
                          createdList['name'].startsWith('HTTP://')||
                          createdList['name'].startsWith('https://')||
                          createdList['name'].startsWith('HTTPS://')||
                          createdList['name'].startsWith('WWW.')||
                          createdList['name'].startsWith('www.')||
                          createdList['name'].contains('maps.app.goo.gl')||
                          int.tryParse(createdList['name'].toString()) != null

                  ))
                    cubit.historyIcons['text']!,

                  SizedBox(width: 10,),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${createdList['name']}',
                          style: TextStyle(color:Color(0xff04A583),
                              fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,

                          maxLines: 1,
                        ),
                        SizedBox(height:8,),
                        Text('${createdList['dateTime']}',
                          style: TextStyle(
                            color:Theme.of(context).textTheme.caption!.color,
                            fontSize: Theme.of(context).textTheme.caption!.fontSize, ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ),

          Expanded(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: IconButton(
                    icon: Icon(
                        createdList['status'] == 'false'? Icons.favorite_outline:Icons.favorite,
                        color: createdList['status'] == 'false'? Colors.grey:Colors.red),
                    onPressed: (){


                      if(createdList['status'] == 'false') {
                        cubit.updateStatusDatabase(
                            id: createdList['id'] ,
                            status: "true"
                        );
                        print('mina1  ${index.toString()}');
                        print(createdList['status'].toString());
                      }else if(createdList['status'] == 'true'){
                        cubit.updateStatusDatabase(
                            id: createdList['id'] ,
                            status: "false"
                        );
                        print('mina2  ${index.toString()}');
                        print(createdList['status'].toString());
                        print('id ' +createdList['id'].toString());
                      }

                    },
                  ),
                ),
                Flexible(
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.grey,),
                    onPressed: (){
                      defaultAlertShowDialog(
                          context: context,
                          text: 'Are you sure you want to delete this item?',
                          onPress: (){
                            cubit.deleteData(id: createdList['id']);
                            Navigator.pop(context);
                          }
                      );
                    },
                  ),
                ),
              ],),
          ),
        ],
      ),
    );
  }


}

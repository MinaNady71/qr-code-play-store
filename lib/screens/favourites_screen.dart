import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code/ads_package/ads_models/banner_ad_model.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';

import 'every_single_code_favouritesHistory.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){},
        builder: (context,state){
          var  cubit = ScanCodeCubit.get(context);
          return  NotificationListener<ScrollEndNotification>(
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
              floatingActionButton:!cubit.isListScrollDown ?FloatingActionButton(
                mini: true,
                  backgroundColor: Color(0xff7f0808),
                  child: Icon(FontAwesomeIcons.heartBroken,color: Colors.white,size: 20,),
                  onPressed: (){

                      if(cubit.favouriteList.isNotEmpty){
                        defaultAlertShowDialog(
                            context: context,
                            text: 'Are you sure you want to clear the favourites list?',
                            onPress: (){
                              cubit.updateAllStatus(status: 'false');
                              Navigator.pop(context);
                             defaultToastMessage(context: context,msg: 'Done', color:Theme.of(context).bottomAppBarColor,);
                            },
                          greenButton:'No',
                          redButton: 'Yes'
                            );

                      }else{
                       defaultToastMessage(context: context,msg: 'No favourites', color:Theme.of(context).bottomAppBarColor);
                    }
                  }
              ):null,
              body: Container(
                padding: EdgeInsets.only(top: 10),
                width: double.infinity,
                color:Theme.of(context).backgroundColor,
                child: ConditionalBuilder(
                  condition:cubit.favouriteList.length > 0,
                  builder: (context)=> ListView.separated(
                      itemBuilder: (context,index)=> favouriteWidget(context,cubit.favouriteList[index],index),
                      separatorBuilder:  (context,index)=>(index % 8 == 7 && index != 0)? BannerAdModel(): SizedBox(height: 5,),
                      itemCount:cubit.favouriteList.length),
                  fallback:(context)=> Container(
                    child: Stack(
                      alignment:Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_outlined,size: 75,color: Colors.grey,),
                            Text('Add Favourite',
                              style: TextStyle(fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,fontWeight: FontWeight.bold,color: Colors.grey),)
                          ],
                        ),
                        Align(
                            alignment:Alignment.bottomCenter,
                            child: BannerAdModel()),
                      ],


                    ),
                  ),
                ) ,

              ),
            ),
          );}
    );
  }

  Widget favouriteWidget(context,Map favouriteList,index) {
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
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=> ViewSingleCodeFavouritesHistory(index: index))
                ).then((value) => cubit.falseToShowBarcodeList());

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(favouriteList['name'].startsWith('mailto:')||
                      favouriteList['name'].startsWith('MATMSG:') ||
                      favouriteList['name'].startsWith('MATMSG:TO:'))
                    cubit.historyIcons['email']!,

                  if(favouriteList['name'].contains('BEGIN:VCARD') ||
                      favouriteList['name'].contains('END:VCARD') ||
                      favouriteList['name'].contains('END:VCALENDAR') ||
                      favouriteList['name'].contains('BEGIN:VCALENDAR') ||
                      favouriteList['name'].contains('BEGIN:VEVENT'))
                    cubit.historyIcons['event']!,

                  if( favouriteList['name'].startsWith('WIFI:T') ||
                      favouriteList['name'].startsWith('WIFI:S'))
                    cubit.historyIcons['wifi']!,

                  if(favouriteList['name'].contains('GEO:') ||
                      favouriteList['name'].contains('geo:')||
                      favouriteList['name'].contains('maps.google.com')||
                      favouriteList['name'].contains('maps.app.goo.gl')||
                      favouriteList['name'].contains('MAPS.GOOGLE.COM'))
                    cubit.historyIcons['location']!,
                  if( favouriteList['name'].contains('PLAY.GOOGLE.COM')||
                      favouriteList['name'].contains('play.google.com'))
                    cubit.historyIcons['app']!,
                  if(favouriteList['name'].startsWith('SMSTO:')||
                      favouriteList['name'].startsWith('smsto:'))
                    cubit.historyIcons['sms']!,
                  if(favouriteList['name'].startsWith('tel:')||
                      favouriteList['name'].startsWith('TEL:'))
                    cubit.historyIcons['phone']!,
                  if(int.tryParse(favouriteList['name'].toString()) != null)
                    cubit.historyIcons['barcode']!,

                  if((favouriteList['name'].startsWith('http://')||
                      favouriteList['name'].startsWith('HTTP://')||
                      favouriteList['name'].startsWith('https://')||
                      favouriteList['name'].startsWith('HTTPS://')||
                      favouriteList['name'].startsWith('WWW.')||
                      favouriteList['name'].startsWith('www.'))&&
                      !(favouriteList['name'].contains('maps.google.com')||
                          favouriteList['name'].contains('maps.app.goo.gl')||
                          favouriteList['name'].contains('MAPS.GOOGLE.COM')||
                          favouriteList['name'].contains('PLAY.GOOGLE.COM')||
                          favouriteList['name'].contains('play.google.com'))
                  )
                    cubit.historyIcons['lang']!,

                  if(!(
                      favouriteList['name'].startsWith('mailto:')||
                          favouriteList['name'].startsWith('MATMSG:') ||
                          favouriteList['name'].startsWith('MATMSG:TO:')||
                          favouriteList['name'].contains('BEGIN:VCARD') ||
                          favouriteList['name'].contains('END:VCARD') ||
                          favouriteList['name'].contains('END:VCALENDAR') ||
                          favouriteList['name'].contains('BEGIN:VCALENDAR') ||
                          favouriteList['name'].contains('BEGIN:VEVENT')||
                          favouriteList['name'].startsWith('WIFI:T') ||
                          favouriteList['name'].startsWith('WIFI:S')||
                          favouriteList['name'].startsWith('GEO:') ||
                          favouriteList['name'].startsWith('geo:')||
                          favouriteList['name'].contains('maps.google.com')||
                          favouriteList['name'].contains('MAPS.GOOGLE.COM')||
                          favouriteList['name'].contains('PLAY.GOOGLE.COM')||
                          favouriteList['name'].contains('play.google.com')||
                          favouriteList['name'].startsWith('SMSTO:')||
                          favouriteList['name'].startsWith('smsto:')||
                          favouriteList['name'].startsWith('tel:')||
                          favouriteList['name'].startsWith('TEL:')||
                          favouriteList['name'].startsWith('http://')||
                          favouriteList['name'].startsWith('HTTP://')||
                          favouriteList['name'].startsWith('https://')||
                          favouriteList['name'].startsWith('HTTPS://')||
                          favouriteList['name'].startsWith('WWW.')||
                          favouriteList['name'].startsWith('www.')||
                          favouriteList['name'].contains('maps.app.goo.gl')||
                          int.tryParse(favouriteList['name'].toString()) != null

                  ))
                    cubit.historyIcons['text']!,
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${favouriteList['name']}',
                          style: TextStyle(color:Color(0xff04A583),
                              fontSize:16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                        SizedBox(height:8,),

                        Text('${favouriteList['dateTime']}',
                          style: TextStyle(color:Theme.of(context).textTheme.caption!.color,
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
                        favouriteList['status'] == 'false'? Icons.favorite_outline:Icons.favorite,
                        color: favouriteList['status'] == 'false'? Colors.grey:Colors.red ),
                    onPressed: (){
                      if(favouriteList['status'] == 'false') {
                        cubit.updateStatusDatabase(
                            id: favouriteList['id'] ,
                            status: "true"
                        );
                        print('mina1  ${index.toString()}');
                        print(favouriteList['status'].toString());
                      }else if(favouriteList['status'] == 'true'){
                        cubit.updateStatusDatabase(
                            id: favouriteList['id'] ,
                            status: "false"
                        );
                        print('mina2  ${index.toString()}');
                        print(favouriteList['status'].toString());
                        print('id ' +favouriteList['id'].toString());
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
                            cubit.deleteData(id: favouriteList['id']);
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

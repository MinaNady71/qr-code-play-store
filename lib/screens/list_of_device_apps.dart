import 'dart:ui';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';



class ShowDeviceAppLists extends StatelessWidget {
  TabController? tabController;

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){},
        builder: (context,state){

          var  cubit = ScanCodeCubit.get(context);
          return Scaffold(
          appBar: AppBar(title:Text('Select App') ,
            backgroundColor: Theme.of(context).bottomAppBarColor,
          ),
            body: Container(

              padding: EdgeInsets.all(5),
              color: Theme.of(context).backgroundColor,
              child: ConditionalBuilder(
                condition:cubit.deviceApps.length > 0 && cubit.deviceApps != null,
                builder: (context)=> ListView.separated(
                    controller:scrollController ,
                    itemBuilder: (context,index)=>deviceAppWidget(context,cubit.deviceApps[index],index),
                    separatorBuilder:  (context,index)=> SizedBox(height: 5,),
                    itemCount:cubit.deviceApps.length),
                fallback:(context)=> Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.apps,size: 100,color: Colors.grey,),
                      Text('No Apps',
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.grey),)
                    ],
                  ),
                ),
              ) ,
            ),
          );
        }
    );
  }

  Widget deviceAppWidget(context,ApplicationWithIcon app,index) {
    var cubit = ScanCodeCubit.get(context);
    return InkWell(
      onTap: (){
          Navigator.pop(context,app.packageName.toString());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.only(top: 15,bottom:15,left: 10,right: 5),

        child:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.memory(app.icon,width: 50,height: 50,),
            SizedBox(width: 10,),
            Flexible(
              child: Text('${app.appName.toString()}',
                style: TextStyle(color:Color(0xff04A583),
                    fontSize:Theme.of(context).textTheme.bodyText1!.fontSize ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

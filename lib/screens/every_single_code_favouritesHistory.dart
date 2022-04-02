
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/cubit.dart';
import 'package:qr_code/cubit/states.dart';



class ViewSingleCodeFavouritesHistory extends StatelessWidget {

   ViewSingleCodeFavouritesHistory({ this.index,Key? key}) ;
late int? index ;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCodeCubit,ScanCodeStates>(
        listener: (context,state){},
       builder: (context,state){
          var cubit = ScanCodeCubit.get(context);
    String textValue =index != null ? cubit.favouriteList[index!]['name']:cubit.favouriteList.first['name'];
         return Scaffold(
           backgroundColor:Theme.of(context).backgroundColor,
        appBar: AppBar(
               title: Text('QR CODE'),
          backgroundColor:Theme.of(context).bottomAppBarColor,
        ),
        body:buildCodeDetailsForScannedCreatedFavourites(context, textValue, cubit),
    );
    }
    );

  }
}


import 'package:flutter/material.dart';
import 'package:qr_code/cubit/cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ScanCodeCubit.get(context).createLocalDatabase();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = ScanCodeCubit.get(context);
    return Scaffold(
      body:ScanCodeCubit.get(context).screens[ScanCodeCubit.get(context).index],
      bottomNavigationBar: BottomNavigationBar(
                currentIndex:cubit.index ,
                onTap: (index){
              cubit.currentIndex(index);
            },
            items:[
              BottomNavigationBarItem(
                  icon: Icon(Icons.edit),
                  label: 'Generate'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(tooltip: 'Scan',
                  icon: Icon(Icons.qr_code_scanner_rounded,), label: 'Scan'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline_rounded), label: 'Favourites'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined), label: 'Setting'),
            ]
        ),
   
    );
  }
}





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



// bottomNavigationBar: ConvexAppBar(
//         activeColor:Color(0xff04A583) ,
//         backgroundColor: Color(0xff323739),
//         color: Color(0xff04A583),
//         style: TabStyle.reactCircle,
//         initialActiveIndex: cubit.index ,
//           height: 55,
//           curveSize: 100,
//           onTap: (index){
//             cubit.currentIndex(index);
//           },
//           items: [
//             // selectedItemColor: Color(0xff04A583),
// //     unselectedItemColor: Colors.white,
// //     type: BottomNavigationBarType.fixed,
// //     showSelectedLabels: true,
// //     showUnselectedLabels: true,
// //     currentIndex:cubit.index ,
// //     selectedFontSize: 15,
// //     iconSize: 25,
// //
//              TabItem(
//
//                   icon: Icon(Icons.edit,color: Colors.white,),
//                   title: 'Generate'),
//               TabItem(
//                   icon: Icon(Icons.history,color: Colors.white), title: 'History'),
//               TabItem(
//                   icon: Icon(Icons.qr_code,color: Colors.white),),
//               TabItem(
//                   icon: Icon(Icons.favorite_border_outlined,color: Colors.white), title: 'Favourites'),
//               TabItem(
//                   icon: Icon(Icons.settings_outlined,color: Colors.white), title: 'Setting'),
//
//          ],
//
//       ),
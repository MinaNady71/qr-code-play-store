import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code/component.dart';
import 'package:qr_code/cubit/states.dart';
import 'package:qr_code/models/calendar_model.dart';
import 'package:qr_code/models/email_model.dart';
import 'package:qr_code/models/map_model.dart';
import 'package:qr_code/models/mecard_model.dart';
import 'package:qr_code/models/smsto_model.dart';
import 'package:qr_code/models/vcard_model.dart';
import 'package:qr_code/models/wifi_parse_model.dart';
import 'package:qr_code/screens/favourites_screen.dart';
import 'package:qr_code/screens/generate_screen.dart';
import 'package:qr_code/screens/history_screen.dart';
import 'package:qr_code/screens/scan_screen.dart';
import 'package:qr_code/screens/settings_screen.dart';
import 'package:qr_code/shared/network/local/cache_helper.dart';
import 'package:scan/scan.dart';
import 'package:sqflite/sqflite.dart';

class ScanCodeCubit extends Cubit<ScanCodeStates>{
  ScanCodeCubit() : super(ScanInitialStates());

  static ScanCodeCubit get(context) => BlocProvider.of(context);

  bool isListScrollDown = false;

  void listScrollToggleFalse(){
    isListScrollDown = false;
    emit(ScanListScrollDownStates());
  }
  void listScrollToggleTrue(){
    isListScrollDown = true;
    emit(ScanListScrollDownStates());
  }


 int index = 2;
    void currentIndex(index){
      this.index = index;
      emit(ScanCurrentIndexStates());
      if(index == 2) {
        emit(ScanRefreshCameraStates());
      }
    }

  int historyIndex = 0;
  void currentHistoryIndex(index){
    historyIndex = index;
    emit(ScanHistoryCurrentIndexStates());
  }

    List<Widget> screens = [
      GenerateScreen(),
      HistoryScreen(),
      ScanScreen(),
      FavouritesScreen(),
      SettingScreen(),

    ];

    File? image;
  dynamic scanResult;
    Future<void> downLoadImage(context)async{
      final ImagePicker _picker = ImagePicker();
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if(pickedFile != null){
        image = File(pickedFile.path);
        scanResult  = await Scan.parse(pickedFile.path);
        emit(ScanSelectImageStates());

      }

    }

bool showBarcodeList = false;
    void toggleToShowBarcodeList(){
      showBarcodeList = !showBarcodeList;
      emit(ScanToggleToShowBarcodeListStates());
    }
  void falseToShowBarcodeList(){
    showBarcodeList = false;
    emit(ScanToggleToShowBarcodeListStates());
  }

Map<String,Widget> historyIcons={
  'url' : Icon(Icons.link,color:Color(0xff04A583),size: 40,),
  'text' : Icon(Icons.text_snippet,color:Color(0xff04A583),size: 40,),
  'vcard' : Icon(Icons.quick_contacts_mail,color:Color(0xff04A583),size: 40,),
  'email' : Icon(Icons.alternate_email,color:Color(0xff04A583),size: 40,),
  'location' : Icon(Icons.location_on_sharp,color:Color(0xff04A583),size: 40,),
  'wifi' : Icon(Icons.wifi,color:Color(0xff04A583),size: 40,),
  'phone' : Icon(Icons.phone,color:Color(0xff04A583),size: 40,),
  'sms' : Icon(Icons.textsms,color:Color(0xff04A583),size: 40,),
  'app' : Icon(Icons.apps,color:Color(0xff04A583),size: 40,),
  'event' : Icon(Icons.event_outlined,color:Color(0xff04A583),size: 40,),
  'lang' : Icon(Icons.language_outlined,color:Color(0xff04A583),size: 40,),
  'barcode' : Icon(FontAwesomeIcons.barcode,color:Color(0xff04A583),size: 40,),

};


  late Database database;

    void createLocalDatabase()async{
       database = await openDatabase(
        'qrcode.db',
       version: 1,
        onCreate: (db,version){
          //id
          //typeGen which generate
          //text1
          //text2
          //text3
          //text4
          //text5
          //dateTime
          //status
          //isScanned
                print('databaseCreated');
           db.execute('CREATE TABLE history ('
               'id INTEGER PRIMARY KEY ,'
               ' name TEXT'
               ',dateTime TEXT ,'
               'status TEXT,'
               'isScanned TEXT'
               ')')
               .then((value) {
                 print('database execute ');
           }).catchError((error){
             print('error $error');
           });

        },
      onOpen:(database){
          print('database open');
          getDatabase(database);
      }

      );
    }

    void insertDatabaseScanned({
          required String name,
          required String dateTime,
          required String isScanned,
       }) {

      //scanned
      //created
      database.transaction((txn)=>
          txn.rawInsert(
            'INSERT INTO history(name,dateTime,status,isScanned) VALUES("$name" ,"$dateTime","false","$isScanned")'))
          .then((value) {
            print('insert succ $value');
            getDatabase(database);
            emit(ScanInsertDatabaseStates());

      }).catchError((error){
        print('error   $error');
      });
    }



  List<Map> scannedList = [];
  List<Map> createList = [];
  List<Map> favouriteList = [];
  List<Map> favouriteListTest = [
    {'name':'mina'},
    {'name':'mina'},
    {'name':'mina'},
    {'name':'miiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiina'},
    {'name':'mina'},
    {'name':'mina'},
    {'name':'mina'},
    {'name':'mina'},
    {'name':'mina'},
    {'name':'mina'},
    {'name':'mina'},



  ];

    void getDatabase(Database database){
       database.rawQuery('SELECT * FROM history  ORDER BY id DESC ').then((value){
         emit(ScanGetDatabaseStates());
         scannedList = [];
         createList = [];
         favouriteList = [];
         emit(ScanGetDatabaseStates());
          value.forEach((element){
            if(element['isScanned'] == 'scanned'){
              scannedList.add(element);
              if(element['status'] == 'true') {
                favouriteList.add(element);
              }
            }else if(element['isScanned'] == 'created'){
              createList.add(element);
              if(element['status'] == 'true') {
                favouriteList.add(element);
              }
            }else if(element['status'] == 'true'){
              favouriteList.add(element);
            }
            emit(ScanGetDatabaseStates());

          });

       }).catchError((error){
         print(error.toString());
       });
    }

    void updateStatusDatabase({
        required int id,
        required String status
})async{
      try {
        await database.rawUpdate(
            'UPDATE history SET status = ? WHERE id = ?', [status, id]);

        getDatabase(database);
        emit(ScanUpdateDatabaseStates());
      }catch(e){
        print('minaaaaaa  $e');
      }

    }
  void updateAllStatus({
  required String status
})async{

    await database.rawDelete('UPDATE history SET status = ? WHERE status = ?', [status,'true']);
    getDatabase(database);
    emit(ScanUpdateAllStatusDatabaseStates());

  }

    void deleteData({
        required int id
})async{

      await database.rawDelete('DELETE FROM history  WHERE id = ?',[id]);
      getDatabase(database);
      emit(ScanDeleteDatabaseStates());

    }

  void deleteALLScanned()async{

    await database.rawDelete('DELETE FROM history WHERE isScanned =?', ['scanned']);
    getDatabase(database);
    emit(ScanDeleteScannedDatabaseStates());

  }
  void deleteALLCreated()async{

    await database.rawDelete('DELETE FROM history WHERE isScanned = ?', ['created']);
    getDatabase(database);
    emit(ScanDeleteCreatedDatabaseStates());

  }

  List? favourite;
   void toggleFavourite( index){
     favourite![index] =! favourite![index];
     emit(ScanToggleFavouriteStates());

   }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/demoTextFile.png'; // 3

    return filePath;
  }

  void saveFile() async {
    File file = File(await getFilePath()); // 1
    file.writeAsString("This is my demo text that will be saved to : demoTextFile.p"); // 2

  }
  void readFile() async {
    File file = File(await getFilePath()); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<void> captureAndSharePng({required globalKey,required context}) async {
    var rn =  Random();
    dynamic randomNum = rn.nextInt(5000);
     if(Platform.isAndroid){
    var status = await Permission.storage.status;
    if (status.isGranted) {
      try {
        final directory = await getApplicationDocumentsDirectory();

        RenderRepaintBoundary boundary =
        await globalKey.currentContext.findRenderObject();
        var image = await boundary.toImage();

        ByteData? byteData = await image.toByteData(
            format: ImageByteFormat.png);

        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final file =
        await File('/storage/emulated/0/Android/data/dev.singlecodebase71.qr_code/files/QrPictures/${randomNum.toString()}qrimage.png').create(
            recursive: true);

        await file.writeAsBytes(pngBytes);
        emit(ScanSaveImageStates());
       defaultToastMessage(context: context,msg: 'Photo saved to this device', color: Color(0xff323739));
        print('mina successs ' + directory.path.toString());
      } catch (e) {
        print('mina ' + e.toString());
      }
    }else{

     await Permission.storage.request();
    }

    }

// You can can also directly ask the permission about its status.

  }


  CalendarToMap calendarToMap = CalendarToMap();
  Future parseICalender(textValue)async {
    calendarToMap.endDate ='';
    calendarToMap.description ='';
    calendarToMap.location ='';
    calendarToMap.strDate ='';
    calendarToMap.title ='';
//  BEGIN:VCALENDAR
//  VERSION:2.0
//  BEGIN:VEVENT
//  SUMMARY:event
//  LOCATION:jsdjeheh
//  DESCRIPTION:bdhdj
//  DTSTART:20220117T055000Z
//  DTEND:20220103T055000Z
//  END:VEVENT
//  END:VCALENDARXX
    if(textValue != null){
      LineSplitter line = LineSplitter();
      var test = line.convert(textValue);
      test.forEach((element) {
        if(element.contains('SUMMARY')) {
          var title = element.split(':');
          calendarToMap.title = title[1].toString();
        }
        if(element.contains('LOCATION')) {
          var location = element.split(':');
          calendarToMap.location = location[1].toString();
        }
        if(element.contains('DESCRIPTION')) {
          var description = element.split(':');
          calendarToMap.description = description[1].toString();
        }
        if(element.contains('DTSTART')) {
          var strDate = element.split(':');
          calendarToMap.strDate = strDate[1].toString();
        }
        if(element.contains('DTEND')) {
          var endDate = element.split(':');
          calendarToMap.endDate = endDate[1].toString();

        }
      });

      emit(ScanParseICalenderStates());
    }

  }


  VcardToMap vcardToMap = VcardToMap();
  Future parseVcard(String textValue)async {
    vcardToMap.name ='';
    vcardToMap.phoneNumber ='';
    vcardToMap.phoneWork ='';
    vcardToMap.email ='';
    vcardToMap.address ='';
    vcardToMap.url ='';
//  BEGIN:VCARD
//  VERSION:3.0
//  N:Melvin Vivas
//  ORG:Freelance
//  TITLE:Senior Software Engineer
//  TEL:+1234567
//  URL:https://www.melvinvivas.com
//  EMAIL:melvindave@gmail.com
//  ADR:Singapore
//  END:VCARD
    if(textValue != null){
      LineSplitter line = LineSplitter();
      var test = line.convert(textValue);
      test.forEach((element) {
        if(element.contains('N:')||element.startsWith('N;')) {
          var title = element.split(':');
          vcardToMap.name = title[1].toString();
        }
        if(element.startsWith('TEL;') || element.contains('TEL:') || element.contains('tel:')  || element.contains('TEL;CELL:')) {
          var location = element.split(':');
          vcardToMap.phoneNumber = location[1].toString();
        }
        if(element.contains('TEL;TYPE=work:')||element.contains('TYPE=work:')||element.contains('WORK;')) {
          var location = element.split(':');
          vcardToMap.phoneWork = location[1].toString();
        }
        if(element.contains('ADR:')||element.startsWith('ADR;')) {
          var description = element.split(':');
          vcardToMap.address = description[1].toString();
        }
        if(element.startsWith('EMAIL;') || element.contains('EMAIL:')) {
          var strDate = element.split(':');
          vcardToMap.email = strDate[1].toString();
        }
        if(element.contains('URL:')|| element.startsWith('URL;') ) {
          //  var endDate = element.split(':');
          vcardToMap.url = element.replaceAll('URL:','').toString();

        }else if(element.startsWith('URL;') ) {
            var endDate = element.split(':');
          vcardToMap.url = endDate[1].toString();

        }
      });

      emit(ScanParseVcardStates());
    }

  }

  MeCardToMap meCardToMap =MeCardToMap();
  Future parseMEcard(String textValue)async {
    meCardToMap.name ='';
    meCardToMap.phoneNumber ='';
    meCardToMap.phoneWork ='';
    meCardToMap.email ='';
    meCardToMap.address ='';
    meCardToMap.url ='';
    if(textValue != null){
      var splitValue = textValue.replaceAll(';','\n');
      LineSplitter line = LineSplitter();
      var test = line.convert(splitValue);
      test.forEach((element) {
        if(element.contains('N:')||element.startsWith('N;')) {
          var title = element.split(':');
          meCardToMap.name = title[2].toString();
        }
        if( element.contains('TEL:') || element.contains('tel:')  || element.contains('TEL;CELL:')) {
          var location = element.split(':');
          meCardToMap.phoneNumber = location[1].toString();
        }
        if(element.contains('TEL;TYPE=work:')||element.contains('TYPE=work:')||element.contains('WORK;')) {
          var location = element.split(':');
          meCardToMap.phoneWork = location[1].toString();
        }
        if(element.contains('ADR:')||element.startsWith('ADR;')) {
          var description = element.split(':');
          meCardToMap.address = description[1].toString();
        }
        if(element.startsWith('EMAIL;') || element.contains('EMAIL:')) {
          var strDate = element.split(':');
          meCardToMap.email = strDate[1].toString();
        }
        if(element.contains('URL:')|| element.startsWith('URL;') ) {
          //  var endDate = element.split(':');
          meCardToMap.url = element.replaceAll('URL:','').toString();

        }else if(element.startsWith('URL;') ) {
          var endDate = element.split(':');
          meCardToMap.url = endDate[1].toString();

        }
      });

      emit(ScanParseVcardStates());
    }

  }


EmailToMap emailToMap = EmailToMap();
  Future parseEmail(textValue)async {
    emailToMap.to ='';
    emailToMap.sub ='';
    emailToMap.body ='';
//"MATMSG:TO:ffjjk;SUB:ggjkl;BODY:vhlolkk;;";
    if(textValue != null){
      String modifyTextValue1 = textValue.replaceAll('\n',' ');
      String modifyTextValue2 = modifyTextValue1.replaceAll(';','\n');
      LineSplitter line = LineSplitter();
      var test = line.convert(modifyTextValue2);
      print(test.toString());
      test.forEach((element) {
        if(element.contains('MATMSG:TO:')) {
          var to = element.split(':');
          if(to.length >= 3){
            emailToMap.to = to[2].toString();
          }
        }else if(element.contains('TO:')){
          var to = element.split(':');
          if(to.length >= 2){
            emailToMap.to = to[1].toString();
          }
        }
        if(element.contains('SUB:')) {
          var sub = element.split(':');
          emailToMap.sub = sub[1].toString();
        }
        if(element.contains('BODY:')) {
          var body = element.split(':');
          emailToMap.body = body[1].toString();
        }
      });

      emit(ScanParseEmailStates());
    }

  }



  SMSToMap smsToMap = SMSToMap();
  Future parseSMS(textValue)async {
    smsToMap.phoneNumber ='';
    smsToMap.body ='';

    if(textValue != null){

        if(textValue.contains('SMSTO:') || textValue.contains('smsto:')) {
          var phone = textValue.split(':');
          smsToMap.phoneNumber = phone[1].toString();
        }
        if(textValue.contains('SMSTO:') || textValue.contains('smsto:')) {
          List body = textValue.split(':');
          if(body.length >= 3){
           smsToMap.body =  body[2].toString();
          }

        }
      emit(ScanParseSMSTOStates());
    }

  }



  WifiParseToMap wifiParseToMap = WifiParseToMap();
  Future parseWifi(textValue)async {
    wifiParseToMap.name ='';
    wifiParseToMap.pass ='';
    wifiParseToMap.type ='';

    if(textValue != null){
      String rep = textValue.toString().replaceAll(';;', '').replaceAll('WIFI:', '').replaceAll(';', '\n');
      LineSplitter splitter = LineSplitter();
      var split = splitter.convert(rep);
      print(split.toString());
        split.forEach((element) {
          if(element.contains('T:')) {
            var type = element.split(':');
            wifiParseToMap.type = type[1].toString();
          }
          if(element.contains('S:')) {
            var name = element.split(':');
            wifiParseToMap.name = name[1].toString();
          }
          if(element.contains('P:')) {
            var pass = element.split(':');
            wifiParseToMap.pass = pass[1].toString();

          }
          emit(ScanParseWIFIStates());
        });

    }

  }



  GeoMapToMap geoMapToMap = GeoMapToMap();
  Future parseGeoMap(textValue)async {
    geoMapToMap.lat ='';
    geoMapToMap.long ='';

    if(textValue != null){

      if(textValue.contains('GEO:')) {
        String removeGeo =  textValue.toString().replaceAll('GEO:','');
        var latLong = removeGeo.split(',');
        geoMapToMap.lat = latLong[0].toString();
        geoMapToMap.long = latLong[1].toString();

      }else if(textValue.contains('geo:')) {

        String removeGeo =  textValue.toString().replaceAll('geo:','');
        var latLong = removeGeo.split(',');
        geoMapToMap.lat = latLong[0].toString();
        geoMapToMap.long = latLong[1].toString();
      }

      emit(ScanParseGeoMapTOStates());
    }

  }

  //google map





GoogleMapController? mapController;
Position? currentLocation;
  Future getCurrentLocation()async{
    var status = await Permission.locationWhenInUse.status;
    if(status.isGranted) {
      Position position = await Geolocator
          .getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentLocation = position;
      LatLng latLng = LatLng(position.latitude, position.longitude);
      emit(ScanCurrentLocationStates());
       if(mapController != null )
      await mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng , 14));
      print('mina' + position.latitude.toString() +
          position.longitude.toString());
      emit(ScanCurrentLocationStates());
    }else{
      Permission.locationWhenInUse.request();
      emit(ScanCurrentLocationStates());

    }
    emit(ScanCurrentLocationStates());
  }



CameraPosition cameraPosition = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 0
);




  List deviceApps = [];

  Future getDeviceAppList(context)async{
    deviceApps = [];
   defaultShowDialog(context: context, text: 'Loading...');
    deviceApps =  await DeviceApps.getInstalledApplications( includeAppIcons: true, );
    Navigator.pop(context);
    emit(ScanGetDeviceAppStates());


  }
  bool mode = CacheHelper.getBoolData('mode')!= null? CacheHelper.getBoolData('mode'): false;

  void switchThemeMode()async{
    dynamic modeFormShared = await CacheHelper.getBoolData('mode');
    if(modeFormShared != null){
      if(modeFormShared == true){
        await  CacheHelper.putBoolean(key: 'mode', value: false);
        mode = !mode;
        emit(ScanSwitchThemeModeStates());
      }else if(modeFormShared == false){
      await  CacheHelper.putBoolean(key: 'mode', value: true);
      mode = !mode;
        emit(ScanSwitchThemeModeStates());
      }
    }else{
      mode = !mode;
      await  CacheHelper.putBoolean(key: 'mode', value: mode);
      emit(ScanSwitchThemeModeStates());
    }
  }



  bool vibrate = CacheHelper.getBoolData('vibrate')!= null? CacheHelper.getBoolData('vibrate'): true;

  void switchVibrate()async{
    dynamic modeFormShared = await CacheHelper.getBoolData('vibrate');
    if(modeFormShared != null){
      if(modeFormShared == true){
        await  CacheHelper.putBoolean(key: 'vibrate', value: false);
        vibrate = !vibrate;
        emit(ScanSwitchVibrateStates());
      }else if(modeFormShared == false){
        await  CacheHelper.putBoolean(key: 'vibrate', value: true);
        vibrate = !vibrate;
        emit(ScanSwitchVibrateStates());
      }
    }else{
      vibrate = !vibrate;
      await  CacheHelper.putBoolean(key: 'vibrate', value:vibrate);
      emit(ScanSwitchVibrateStates());
    }
  }

  bool openURLAuto = CacheHelper.getBoolData('openURL')!= null? CacheHelper.getBoolData('openURL'): true;

  void openURLAutomatically()async{
    dynamic modeFormShared = await CacheHelper.getBoolData('openURL');
    if(modeFormShared != null){
      if(modeFormShared == true){
        await  CacheHelper.putBoolean(key: 'openURL', value: false);
        openURLAuto = !openURLAuto;
        emit(ScanOpenURLAutomaticallyStates());
      }else if(modeFormShared == false){
        await  CacheHelper.putBoolean(key: 'openURL', value: true);
        openURLAuto = !openURLAuto;
        emit(ScanOpenURLAutomaticallyStates());
      }
    }else{
      openURLAuto = !openURLAuto;
      await  CacheHelper.putBoolean(key: 'openURL', value:openURLAuto);
      emit(ScanOpenURLAutomaticallyStates());
    }
  }

  bool playSound = CacheHelper.getBoolData('playSound')!= null? CacheHelper.getBoolData('playSound'): false;

  void switchPlaySound()async{
    dynamic modeFormShared = await CacheHelper.getBoolData('playSound');
    if(modeFormShared != null){
      if(modeFormShared == true){
        await  CacheHelper.putBoolean(key: 'playSound', value: false);
        playSound = !playSound;
        emit(ScanSwitchPlaySoundStates());
      }else if(modeFormShared == false){
        await  CacheHelper.putBoolean(key: 'playSound', value: true);
        playSound = !playSound;
        emit(ScanSwitchPlaySoundStates());
      }
    }else{
      playSound = !playSound;
      await  CacheHelper.putBoolean(key: 'playSound', value:openURLAuto);
      emit(ScanSwitchPlaySoundStates());
    }
  }




  Future<void> checkForUpdate()async {
    AppUpdateInfo? _updateInfo;
   await InAppUpdate.checkForUpdate().then((info)async{
     _updateInfo =info;
     emit(ScanCheckForUpdateStates());
     if(_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable ){
     await  InAppUpdate.startFlexibleUpdate();
     emit(ScanCheckForUpdateStates());
     }

    }).catchError(onError);
    emit(ScanCheckForUpdateStates());
  }



}

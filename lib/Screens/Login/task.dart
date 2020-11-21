import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutterser/Screens/Login/components/Data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CheckList.dart';
import 'NewNote.dart';
import 'newtask.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class task extends StatefulWidget {
  @override
  _taskState createState() => _taskState();
}

class _taskState extends State<task> {
Timer timer;
  DatabaseReference reference;
 // final now = new DateTime.now();
  String formatter = DateFormat('yyyy - MM - dd').format(DateTime.now());// 28/03/2020

  SharedPreferences logindata;
  String user;
  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Data> list=List();
  String filterType = "Bügün";
  DateTime today = new DateTime.now();
  String taskPop = "close";
  var monthNames = [
    "OCAK",
    "ŞUBAT",
    "MART",
    "NİSAN",
    "MAYIS",
    "HAZİRAN",
    "TEMMUZ",
    "AĞUSTOS",
    "EYLÜL",
    "EKİM",
    "KASIM",
    "ARALIK"
  ];
  CalendarController ctrlr = new CalendarController();


  void startServiceInPlatform() async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel("com.retroportalstudio.messages");
      String data = await methodChannel.invokeMethod("startService");
      debugPrint(data);
    }
  }
void get()async{


logindata=await SharedPreferences.getInstance();
setState(() {

  user=logindata.getString('username');
 // print(logindata.getString('username'));


});

final databaseReference = FirebaseDatabase.instance.reference().child('information').child(user);
databaseReference.once().then((DataSnapshot snapshot){
  var data=snapshot.value;
  list.clear();
  data.forEach((
      key,value
      ){
    //print(value['date'].toString());


    Data data=new Data(

      date:value['date'],
      expla:value['expla'],
      information: value['information'],
      time: value['time'],



    );
    list.add(data);
   // print(list.length);



  });

  setState(() {

  });



});






}

void querynotifacation()async{

  logindata=await SharedPreferences.getInstance();
  setState(() {

    user=logindata.getString('username');
    print(logindata.getString('username'));


  });
//print("date today");
 // print(formatter);

  final databaseReference = FirebaseDatabase.instance.reference().child('information').child(user);
  databaseReference.once().then((DataSnapshot snapshot){
    var data=snapshot.value;
    list.clear();
    data.forEach((
        key,value
        ){

     print("database");
     print(value['date']);
     print("date");
     print(formatter);

if(value['date'].toString()==formatter.toString()){


sendnotifacation(value['expla'].toString(),value['information'].toString());



}
else{

  print("none");

}




    });

    setState(() {

    });



  });




}


void sendnotifacation(String a,String b)async{
  var androidDetails = new AndroidNotificationDetails(
      "Channel ID", "Desi programmer", "This is my channel",
      importance: Importance.Max);
  var iSODetails = new IOSNotificationDetails();
  var generalNotificationDetails =
  new NotificationDetails(androidDetails, iSODetails);
  await flutterLocalNotificationsPlugin.show(  0, "Zamanı geldi bügün :", a+" "+b+"sakın unutma :))", generalNotificationDetails, payload: "Task");




}


  void rehber1() async {
   // timer = Timer.periodic(Duration(seconds:30), (Timer t) {

      //querynotifacation();

   // });
  }




  @override
  void initState() {
    get();
    querynotifacation();
    startServiceInPlatform();
    super.initState();
get();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);


  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) =>
      new AlertDialog(
        title: new Text('Yeni taziye'),
        content: new Text('$payload'),
      ),
    );
  }


  void getData(){
    //databaseReference.once().then((DataSnapshot snapshot) {
    //  print('Data : ${snapshot.value}');
   // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Color(0xFF6F35A5),
                elevation: 0,
                title: Text("Görevlerim", style: TextStyle(
                    fontSize: 30
                ),),
                actions: [
                  IconButton(
                    icon: Icon(Icons.short_text,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
              Container(
                height: 70,
                color: Color(0xFF6F35A5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){changeFilter("bugün");},
                          child: Text("Bugün", style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 4,
                          width: 120,
                          color: (filterType== "bugün")?Colors.white:Colors.transparent,
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){changeFilter("ay");},
                          child: Text("Ay", style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height: 4,
                          width: 120,
                          color: (filterType == "ay")?Colors.white:Colors.transparent,
                        )
                      ],
                    )
                  ],
                ),
              ),
              (filterType == "ay")?TableCalendar(
                calendarController: ctrlr,
                startingDayOfWeek: StartingDayOfWeek.monday,
                initialCalendarFormat: CalendarFormat.week,
              ):Container(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bugün ${monthNames[today.month-1]}, ${today.day}/${today.year}", style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey
                            ), )
                          ],
                        ),
                      ),

                    //  dataList.length==0 ? Center(child:Text('no avaible',style: TextStyle(fontSize: 30),))


                      for ( var i =0;i<list.length;i++ )


                      taskWidget(Colors.purple,list[i].time+" "+list[i].expla , list[i].date+" "+list[i].information,
                     /// taskWidget(Colors.blue, "Toplantı " , "9:00 AM"),
                     // taskWidget(Colors.green, "Hastaneye gitcem" , "9:00 AM"),

                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 110,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xFF6F35A5),
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Column(
                                children: [


                                ],
                              ),
                            ),

                            Container(width: 80,),

                            Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 25,
                      left: 0,
                      right: 0,
                      child: InkWell(
                        onTap: openNewTask,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xFF6F35A5), Colors.purple],
                              ),
                              shape: BoxShape.circle
                          ),
                          child: Center(
                            child: Text("+", style: TextStyle(
                                fontSize: 40,
                                color: Colors.white
                            ),),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            child: (taskPop == "open") ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: InkWell(
                  onTap: closeTaskPop,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white
                    ),
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 1,),
                        InkWell(
                          onTap: openNewTask,
                          child: Container(
                            child: Text("Add Task", style: TextStyle(
                                fontSize: 18
                            ),),
                          ),
                        ),
                        Container(
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        InkWell(
                          onTap: openNewNote,
                          child: Container(
                            child: Text("Add Quick Note", style: TextStyle(
                                fontSize: 18
                            ),),
                          ),
                        ),
                        Container(
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          color: Colors.black.withOpacity(0.2),
                        ),
                        InkWell(
                          onTap: openNewCheckList,
                          child: Container(
                            child: Text("Add Checklist", style: TextStyle(
                                fontSize: 18
                            ),),
                          ),
                        ),
                        SizedBox(height: 1,)
                      ],
                    ),
                  ),
                ),
              ),
            ):Container(),
          )
        ],
      ),
    );
  }
  openTaskPop()
  {
    taskPop = "open";
    setState(() {

    });
  }
  closeTaskPop()
  {
    taskPop = "close";
    setState(() {

    });
  }
  changeFilter(String filter)
  {
    filterType = filter;
    setState(() {

    });
  }
  Slidable taskWidget(Color color, String title, String time)
  {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.03),
                offset: Offset(0,9),
                blurRadius: 20,
                spreadRadius: 1
            )]
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color,
                      width: 4)
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                ),),
                Text(time, style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18
                ),)
              ],
            ),
            Expanded(child: Container(),),
            Container(
              height: 50,
              width: 5,
              color: color,
            )
          ],
        ),
      ),



    );
  }
  openNewTask()
  {
    print("aaa");
   Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTask()));
  }
  openNewNote()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>NewNote()));
  }
  openNewCheckList()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckList()));
  }}

  show(){

  return Center(


    child: Text('mevcut görev yok'),

  );



  }




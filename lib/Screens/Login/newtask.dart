import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'date_time_picker_widget2.dart';
import 'task.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';



//'.', '#', '$', '[', or ']'
class NewTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'avenir'
      ),
      home: newTask(),
    );
  }
}
class newTask extends StatefulWidget {
  @override
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<newTask> {
  String a;

  String _date = "Tarih seç";
  String _time = "Saat seç";
  String _selectedDate = 'Tap to select date';

  TextEditingController konu,acklama;
  DatabaseReference ref;

  String time;
  String date;
  SharedPreferences logindata;




  final databaseReference = FirebaseDatabase.instance.reference();



  _ShowCupertinoAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Lütfen boşlukları eksiksiz"),
            content: Text("bir şekilde doldurun "),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Tamam"),
                isDestructiveAction: true,
                onPressed: () {

                 Fluttertoast.showToast(
                     msg: "Tamam", toastLength: Toast.LENGTH_SHORT);
                 Navigator.of(context).pop();
                },
              ),

            ],
          );
        });
  }







  _ShowCupertinoAlertDialogsucces(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Göreviniz başarılı"),
            content: Text("bir şekilde eklendi "),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Tamam"),
                isDestructiveAction: true,
                onPressed: () {
                     Fluttertoast.showToast(
                     msg: "Tamam", toastLength: Toast.LENGTH_SHORT);
                   Navigator.of(context).pop();
                },
              ),

            ],
          );
        });
  }






  void saved()async{
    logindata=await SharedPreferences.getInstance();
    setState(() {

      a=logindata.getString('username');


    });



  String name=konu.text;
  String topic=acklama.text;
  String date=_date.toString();
  String time=_time.toString();


  if(name.isEmpty || topic.isEmpty||date.isEmpty||time.isEmpty||date=="Tarih seç"||time=="Saat seç"){

_ShowCupertinoAlertDialog(context);


  }else{

print(a);
    ref=FirebaseDatabase.instance.reference().child('information').child(a);
    Map<String,String>  information= {

      'expla':topic,

      'information':name,
      'date':date,
      'time':time


    };

    ref.push().set(information);



  }

  _ShowCupertinoAlertDialogsucces(context);



}


void notifacation(){

 // Fluttertoast.showToast(
   //   msg: "Kayıt Başarılı", toastLength: Toast.LENGTH_SHORT);



}


  @override
  void initState(){
    emptycontrol();

    super.initState();
    konu=TextEditingController();
    acklama=TextEditingController();




 // ref=FirebaseDatabase.instance.reference().child('information').child(logindata.getString('username'));
    ref=FirebaseDatabase.instance.reference();



    print("memory");
    print(a);

  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2020),
    );
    if (d != null)
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);

        date=_selectedDate.toString();

      });
  }




  emptycontrol()async{

    logindata=await SharedPreferences.getInstance();

    setState(() {
      a=logindata.getString('username');

    });


print(a);




  }


  

  void createRecord(){
    databaseReference.child("1").set({
      'title': 'Mastering EJB',
      'description': 'Programming Guide for J2EE'
    });
    databaseReference.child("2").set({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6F35A5),
        elevation: 0,
        title: Text("Yeni görev", style: TextStyle(
            fontSize: 25
        ),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>task()));},
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Color(0xFF6F35A5),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.purple,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.85,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        InkWell(
                          child: Text(
                       "",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF000000))
                          ),
                          onTap: (){
                            _selectDate(context);
                          },
                        ),


                        SizedBox(width: 20,),

                      ],
                    ),
                    SizedBox(height: 25,),
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.grey.withOpacity(0.2),
                      child: TextField(
                        controller: konu,
                        decoration: InputDecoration(
                            hintText: "Görev",
                            border: InputBorder.none
                        ),
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                    SizedBox(height: 25,),
                    Container(

                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Konu", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(height: 20,),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)
                                )
                            ),
                            child: TextField(
                              controller: acklama,
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Görevini buraya yazınız",
                              ),
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file, color:  Colors.grey,),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          Container(

                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[

                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  elevation: 4.0,
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                        ),
                                        showTitleActions: true,
                                        minTime: DateTime(2000, 1, 1),
                                        maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                                          print('confirm $date');
                                          _date = '${date.year} - ${date.month} - ${date.day}';
                                          setState(() {




                                          });
                                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50.0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.date_range,
                                                    size: 18.0,
                                                    color: Colors.purple,
                                                  ),
                                                  Text(
                                                    " $_date",
                                                    style: TextStyle(
                                                        color: Colors.purple,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.0),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "Değiştir",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  color: Colors.white,
                                ),



                                SizedBox(
height: 20.0,


                                ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      DatePicker.showTimePicker(context,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');
                            _time = '${time.hour} : ${time.minute} : ${time.second}';
                            setState(() {});
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                      setState(() {




                      });
                    },

                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,

                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: <Widget>[
  Row(
    children: <Widget>[
      Container(



        child: Row(

          children: <Widget>[
            Icon(
              Icons.access_time,
              size: 18.0,
              color: Colors.purple,
            ),

            Text(
              " $_time",
              style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),




          ],




        ),



      ),






    ],







  ),


  Text(

    " Değiştir",
    style: TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.bold,
        fontSize: 18.0


    ),


  )







],


                      ),

color: Colors.white,


                    ),



),
                              ],



                            )



                          ),
                          SizedBox(
                            height: 20,
                          ),


                          SizedBox(height: 30,),
                          InkWell(
                            onTap:saved,

                            child:   Container(

                              padding: EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  color: Color(0xffff96060)
                              ),
                              child: Center(
                                child: Text("Görev Ekle", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                ),),
                              ),
                            ),






                          )

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
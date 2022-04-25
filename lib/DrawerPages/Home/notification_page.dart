import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:badges/badges.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qcabs_driver/Components/custom_button.dart';
import 'package:qcabs_driver/Locale/strings_enum.dart';
import 'package:qcabs_driver/Routes/page_routes.dart';
import 'package:qcabs_driver/Locale/locale.dart';
import '../../Assets/assets.dart';


class NotificationPage extends StatefulWidget {


  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {


  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width= MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: FadedSlideAnimation(
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Notifications",
                  style: theme.textTheme.headline5,
                ),
              ),
              SizedBox(height: 10,),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  width:double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20),bottomLeft:Radius.circular(20),topRight:Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.notifications,size: 30,color: Colors.black45,),
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nouveau transport disponible",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text("Récus le : 02/05/2022",style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  width:double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20),bottomLeft:Radius.circular(20),topRight:Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.notifications,size: 30,color: Colors.black45,),
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nouvelle étinaire disponible pour le client Thomas meunier",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text("Récus le : 12/02/2022",style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
        //Init Floating Action Bubble
    );
  }

  Widget BuildHomeCard() {

    return InkWell(
      onTap: () async {
      },
      child: Container(
        width:double.infinity,
        margin: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20),bottomLeft:Radius.circular(20),topRight:Radius.circular(20)),
          color: Colors.grey,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.notifications,size: 30,color: Colors.black45,),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nouvelle étinaire disponible pour le client Thomas meunier",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("Récus le : 12/02/2022",style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }



}

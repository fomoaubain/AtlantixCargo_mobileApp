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


class HistoriquePage extends StatefulWidget {


  @override
  _HistoriquePage createState() => _HistoriquePage();
}

class _HistoriquePage extends State<HistoriquePage> with SingleTickerProviderStateMixin  {

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState(){
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
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
               "Historique des transports",
                style: theme.textTheme.headline5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                "Liste des transports déjà complétés ou annulés ",
                style: theme.textTheme.bodyText2!.copyWith(color: theme.hintColor),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, PageRoutes.detailsPage),
                // Navigator.pushNamed(context, PageRoutes.rideInfoPage),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: theme.backgroundColor,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(Assets.Client),
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Boudreau lambert',
                                style: theme.textTheme.bodyText2,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '12/03/2022 à 12:15',
                                style: theme.textTheme.caption,
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Badge(
                                toAnimate: false,
                                elevation: 1,
                                badgeColor: Colors.green.shade500,
                                shape: BadgeShape.square,
                                borderRadius: BorderRadius.circular(5),
                                position: BadgePosition.topEnd(top: 0, end: -55),
                                padding: EdgeInsets.all(3),
                                badgeContent: Text(
                                  "Complété",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_on,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      title: Text('Départ : 975, boulevard Roméo-Vachon Nord'),
                      tileColor: theme.cardColor,
                      trailing: Badge(
                        toAnimate: false,
                        elevation: 0,
                        shape: BadgeShape.square,
                        badgeColor: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                        position: BadgePosition.topEnd(top: 0, end: 0),
                        padding: EdgeInsets.all(4),
                        badgeContent: Text(
                          " 12:30",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.navigation,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      title: Text('Arrivé : 800, place Leigh-Capreol'),
                      dense: true,
                      tileColor: theme.cardColor,
                      trailing: Badge(
                        toAnimate: false,
                        elevation: 0,
                        shape: BadgeShape.square,
                        badgeColor: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                        position: BadgePosition.topEnd(top: 0, end: 0),
                        padding: EdgeInsets.all(4),
                        badgeContent: Text(
                          " 18:40",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),



                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, PageRoutes.detailsPage),
                // Navigator.pushNamed(context, PageRoutes.rideInfoPage),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      padding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      color: theme.backgroundColor,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(Assets.Client),
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Boudreau lambert',
                                style: theme.textTheme.bodyText2,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '12/03/2022 à 12:15',
                                style: theme.textTheme.caption,
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Badge(
                                toAnimate: false,
                                elevation: 1,
                                badgeColor: Colors.red.shade500,
                                shape: BadgeShape.square,
                                borderRadius: BorderRadius.circular(5),
                                position: BadgePosition.topEnd(top: 0, end: -55),
                                padding: EdgeInsets.all(3),
                                badgeContent: Text(
                                  "Annulé",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_on,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      title: Text('Départ : 975, boulevard Roméo-Vachon Nord'),
                      tileColor: theme.cardColor,
                      trailing: Badge(
                        toAnimate: false,
                        elevation: 0,
                        shape: BadgeShape.square,
                        badgeColor: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                        position: BadgePosition.topEnd(top: 0, end: 0),
                        padding: EdgeInsets.all(4),
                        badgeContent: Text(
                          " 12:30",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.navigation,
                        color: theme.primaryColor,
                        size: 20,
                      ),
                      title: Text('Arrivé : 800, place Leigh-Capreol'),
                      dense: true,
                      tileColor: theme.cardColor,
                      trailing: Badge(
                        toAnimate: false,
                        elevation: 0,
                        shape: BadgeShape.square,
                        badgeColor: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(3),
                        position: BadgePosition.topEnd(top: 0, end: 0),
                        padding: EdgeInsets.all(4),
                        badgeContent: Text(
                          " 18:40",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),



                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            )
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[

            // Floating action menu item
            Bubble(
              title:"Rechercher",
              iconColor :Colors.white,
              bubbleColor : Colors.blue,
              icon:Icons.search,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
                showBarModalBottomSheet(
                  context: context,
                  expand: false,
                  builder: (context) => SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    child: modalBody(),
                  ),
                );
              },
            ),
            // Floating action menu item
            Bubble(
              title:"Exporter",
              iconColor :Colors.white,
              bubbleColor : Colors.blue,
              icon:Icons.save_alt,
              titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
              onPress: () {
                _animationController.reverse();
                showBarModalBottomSheet(
                  context: context,
                  expand: false,
                  builder: (context) => SingleChildScrollView(
                    controller: ModalScrollController.of(context),
                    child: modalBody2(),
                  ),
                );
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: () => _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward(),

          // Floating Action button Icon color
          iconColor: Colors.white,

          // Flaoting Action button Icon
          iconData: Icons.add,
          backGroundColor: Colors.blue.shade800,
        )
    );
  }

  Widget modalBody() {

    final List<String> genderItems = [
      'Complétés',
      'Annulés',
    ];
    String? selectedValue;
    double width= MediaQuery.of(context).size.width;
    double heightScreen= MediaQuery.of(context).size.height;
    return  Container(
      height: (heightScreen/3)+150,
      padding: EdgeInsets.all(20),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                child:Column(
                  children: [
                    Center(
                      child: Text("Filtrer " ,
                        style: Theme.of(context).textTheme.headline6,
                      ),

                    ),
                    SizedBox(height: 20,),
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                        //Add isDense true and zero Padding.
                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //Add more decoration as you want here
                        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Choisir',
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: genderItems
                          .map((item) =>
                          DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select gender.';
                        }
                      },
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                      },
                    ),
                    SizedBox(height: 10,),
                    DateTimePicker(
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date début',
                      onChanged: (val) => print(val),
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                    SizedBox(height: 10,),
                    DateTimePicker(
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'Date fin',
                      onChanged: (val) => print(val),
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    )
                  ],
                ) ,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: width,
              child: CustomButton(
                icon: Icons.search,
                onTap: () {
                },
                text: "Rechercher",
              ),
            ),
          ],
        ),


    );
  }

  Widget modalBody2() {
    final List<String> genderItems = [
      'Complétés',
      'Annulés',
    ];
    String? selectedValue;
    double width= MediaQuery.of(context).size.width;
    double heightScreen= MediaQuery.of(context).size.height;
    return  Container(
      height: (heightScreen/3)+150,
      padding: EdgeInsets.all(20),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              child:Column(
                children: [
                  Center(
                    child: Text("Filtrer"  ,
                      style: Theme.of(context).textTheme.headline6,
                    ),

                  ),
                  SizedBox(height: 20,),
                  DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    hint: const Text(
                      'Choisir',
                      style: TextStyle(fontSize: 14),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    buttonHeight: 60,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: genderItems
                        .map((item) =>
                        DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                    },
                    onChanged: (value) {
                      //Do something when changing the item if you want.
                    },
                    onSaved: (value) {
                      selectedValue = value.toString();
                    },
                  ),
                  SizedBox(height: 10,),
                  DateTimePicker(
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date début',
                    onChanged: (val) => print(val),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                  SizedBox(height: 10,),
                  DateTimePicker(
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    dateLabelText: 'Date fin',
                    onChanged: (val) => print(val),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  )
                ],
              ) ,
            ),
          ),


          SizedBox(height: 20,),
          Container(
            width: width,
            child: CustomButton(
              icon: Icons.save_alt,
              onTap: () {
              },
              text: "Exporter",
            ),
          ),
        ],
      ),


    );
  }


}

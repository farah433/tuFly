import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tufly/components/buttons.dart';
import '../components/other_components.dart';
import '../details/flights.dart';
import '../components/other_components.dart';
import '../details/county.dart';
import '../details/flights.dart';
import '../const.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddFlightsScreen extends StatefulWidget {
  static String id = 'addFlightsScreen';

  @override
  State<AddFlightsScreen> createState() => _AddFlightsScreenState();
}

class _AddFlightsScreenState extends State<AddFlightsScreen> {

  //Time
  TimeOfDay? selectedTime;

  //Controllers for each field
  final flightNumberController = TextEditingController();
  final timeController = TextEditingController();
  final priceController = TextEditingController();
  final seatController = TextEditingController();

  //Starting value of the dropdownMenu
  String selectedcountyFrom = countiesListFrom[0];
  String selectedcountyTo = countiesListTo[0];
  String selectedcompany = flightCompany[0];

  //Resetting the values FROM & TO if similar
  void similarCounties (){
    if(selectedcountyFrom == selectedcountyTo){
      selectedcountyTo = countiesListTo[0];
    }else if(selectedcountyTo == selectedcountyFrom){
      selectedcountyFrom = countiesListFrom[0];
    }
  }

  //Creating dropdownItem for the FROM Field
  List <DropdownMenuItem> getDropdownMenuItemFrom (){
    List <DropdownMenuItem> dropDownItemsFrom = [];
    for(int i=0; i<countiesListFrom.length; i++){
      String county = countiesListFrom[i];
      var newItem = DropdownMenuItem(child: Text(county, style: kLabelTextStyle.copyWith(color: Colors.black),), value: county,);
      dropDownItemsFrom.add(newItem);
    }
    
    similarCounties();
    return dropDownItemsFrom;
  }


  //Creating dropdownItem for the TO Fields
  List <DropdownMenuItem> getDropdownMenuItemTo (){
    List <DropdownMenuItem> dropDownItemsTo = [];
    for(int i=0; i<countiesListTo.length; i++){
      String county = countiesListTo[i];
      var newItem = DropdownMenuItem(child: Text(county, style: kLabelTextStyle.copyWith(color: Colors.black),), value: county,);
      dropDownItemsTo.add(newItem);
    }
    similarCounties();
    return dropDownItemsTo;
  }

  //Creating dropdownItem for the Company Fields
  List <DropdownMenuItem> getDropdownMenuItemCompany (){
    List <DropdownMenuItem> dropDownItemsCompany = [];
    for(int i=0; i<flightCompany.length; i++){
      String company = flightCompany[i];
      var newItem = DropdownMenuItem(child: Text(company, style: kLabelTextStyle.copyWith(color: Colors.black),), value: company,);
      dropDownItemsCompany.add(newItem);
    }
    return dropDownItemsCompany;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Container(
                height: 150,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(height: 20,),
              FlightDetails(400, 'Airline Company ', Icon(Icons.flight_rounded), DropdownButton(items: getDropdownMenuItemCompany(), value: selectedcompany,onChanged: (value){setState(() {
                            selectedcompany = value;
                          });})),
              SizedBox(height: 10,),
              FlightDetails(400, 'FROM ', Icon(Icons.flight_takeoff_rounded), DropdownButton(items: getDropdownMenuItemFrom(), value: selectedcountyFrom,onChanged: (value){setState(() {
                            selectedcountyFrom = value;
                          });})),
              SizedBox(height: 10,),
              FlightDetails(400, 'TO ', Icon(Icons.flight_land_rounded), DropdownButton(items: getDropdownMenuItemTo(), value: selectedcountyTo,onChanged: (value){setState(() {
                            selectedcountyTo = value;
                          });})),            
              SizedBox(height: 10,),
              FlightDetails(150, 'TIME ', Icon(Icons.calendar_month,size: 20,),
                          TextButton(onPressed: (){
                            showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now(),
                            ).then((time) {setState(() {
                              selectedTime = time;
                            });});
                          },
                          child: Text(selectedTime == null ? 'Select Time' : '${selectedTime!.hour}:${selectedTime!.minute}',style: kLabelTextStyle.copyWith(color: kBorange),)),),
              SizedBox(height: 10,),
              AddFlightTextField('FLIGHT NO.', 'Enter Flight No.', false, flightNumberController,
               (value) => value != null && value.length < 4
                ? 'Enter flight number min. 6 characters': null,),
              SizedBox(height: 10,),
              PriceTextField('PRICE (ksh)', 'Enter ticket fee', false, priceController,
              (value) => value == null
                ? 'This field cannot be empty': null,),
              PriceTextField('SEATS', 'Enter number of seats', false, seatController,
            (value) => value == null
              ? 'This field cannot be empty': null,),
              BottomButton('ADD', kPorange, (){addFlight();}),
            ],
          ),
        ),
        ),
    );
  }
  //Function to Addflight to DB
  Future addFlight() async {
      if(
        selectedcountyFrom != countiesListFrom[0] &&
        selectedcountyTo != countiesListTo[0] &&
        selectedTime != null &&
        flightNumberController != null  &&
        priceController != null &&
        seatController != ''
        ){
        final _firestore = await FirebaseFirestore.instance.collection('Flights').add({
        'company' : selectedcompany,
        'flight_no' : flightNumberController.text.trim(),
        'from' : selectedcountyFrom,
        'price' : priceController.text.trim(),
        'time' : selectedTime.toString(),
        'to' : selectedcountyTo,
        'seats' : seatController.text.trim(),
      });
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'The Flight has been successfully added.', gravity: ToastGravity.TOP);
      }else {
        Fluttertoast.showToast(msg: 'One of the fields is Empty.', gravity: ToastGravity.TOP);
      }

  }
}
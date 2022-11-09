import 'package:flutter/material.dart';
import '../const.dart';
import '../components/buttons.dart';
import'../components/seats_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import'../screens/mpesa_number.dart';

class ChooseSeat extends StatefulWidget {
  static String id = 'choose_seat';

  @override
  State<ChooseSeat> createState() => _ChooseSeatState();
}

class _ChooseSeatState extends State<ChooseSeat> {

  var seatObject ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }













  //The Change selected to Booked on press
  setSelectedToBooked(){
    // listSeatLeft.forEach((seat) {
    //   if(seat["isSelected"]){
    //     setState(() {
    //       seat["isBooked"] = true;
    //     });
    //   }
    // });
    // listSeatRight.forEach((seat) {
    //   if(seat["isSelected"]){
    //     setState(() {
    //       seat["isBooked"] = true;
    //     });
    //   }
    // });
  }


  @override
  Widget build(BuildContext context) {

    //Passing data from previous screen 
    final routeData = ModalRoute.of(context)!.settings.arguments as Map;
    final newCompanyName = routeData['companyName'];
    final newToWhere = routeData['toWhere'];
    final newFromWhere = routeData['fromWhere'];
    final newDepTime = routeData['depTime'];
    final newPrice = routeData['price'];
    final newFlightNum = routeData['flightNum'];
    final newNewDate = routeData['newDate'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Seats'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                children: [
                  Container(
                    width: 270,
                    height: 700,
                    decoration: BoxDecoration(
                      color: kLastFlightorange.withBlue(100),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                        Text(newNewDate, style: kfightName.copyWith(fontSize: 16)),
                        Text(newDepTime, style: kfightName.copyWith(fontSize: 16)),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: SeatDeignStream(),),
                            Expanded(child: SeatDeignStream(),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(radius: 8, backgroundColor: Colors.white,),
                            Text(' Empty', style: kBodyTextStyle.copyWith(fontSize: 14),),
                            SizedBox(width: 8,),
                            CircleAvatar(radius: 8, backgroundColor: kDorange,),
                            Text(' Selected', style: kBodyTextStyle.copyWith(fontSize: 14),),
                            SizedBox(width: 8,),
                            CircleAvatar(radius: 8, backgroundColor: kReservedSeat,),
                            Text(' Reserved', style: kBodyTextStyle.copyWith(fontSize: 14),),
                          ],
                        ),
                        ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: kPorange.withAlpha(100),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image.asset('images/$newCompanyName.png'),
                          ),
                        ),
                        Text(newCompanyName, style: kfightNameB),
                        SizedBox(height: 20),
                        Text(newFlightNum, style: kfightNameB.copyWith(fontWeight: FontWeight.w300),),
                        Text('Flight no.', style: kfightNameB),
                        SizedBox(height: 20),
                        Text(newFromWhere, style: kfightName),
                        Icon(Icons.flight_land_rounded,color: kBorange,),
                        Text(newToWhere, style: kfightName),
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                        Text('D48', style: kfightName.copyWith(fontSize: 30, color:kPorange,fontWeight: FontWeight.w300),),
                        Text('D49', style: kfightName.copyWith(fontSize: 30,color:kPorange, fontWeight: FontWeight.w300),),
                        Text('Seats', style: kfightNameB),
                        SizedBox(height: 20),
                          Text('Ksh', style: kfightNameB.copyWith(fontSize:  20),),
                          SizedBox(width: 3,),
                          Text(newPrice, style: kfightName.copyWith(fontSize: 30,color:kPorange, fontWeight: FontWeight.w300),),
                        Text('Price', style: kfightNameB),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              BottomButton('Next', kBorange, (){
              // updateToBooked();
                Navigator.pushNamed(context, MpesaNumberScreen.id);
                }),
            ],
          ),
        ),
        ),
    );
  }

  
  //The Seat actual Design
  Widget seatDesign(List dataSeat){
    
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,),
        itemCount: dataSeat.length,
        itemBuilder:(context, index) {
          return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onDoubleTap: ()async{
                      setState(() {
                        dataSeat[index]["isSelected"] = false;

                      });
                    },
                    onTap: () async {
                      setState(() {
                        dataSeat[index]["isSelected"] =true;
                      });
                    },
                    child: dataSeat[index]["isBooked"]
                     ? Image.asset('images/seat3.png')
                     : dataSeat[index]["isSelected"]
                     ? Image.asset('images/seat2.png')
                     : Image.asset('images/seat1.png')),
                );
        }
        ),
    );
  }
}

//For the StreamBuilder to fetch data from Firestore and Display for Available Flights
class SeatDeignStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('seats').snapshots(),
      builder: (context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        final seats = snapshot.data.docs;
        List <SeatContainer> SeatContainers = [];
        for(var seat in seats){
          final seatId = seat['id'];
          final isItAvailable = seat['isAvailable'];
          final isItSelected = seat['isSelected'];
          final isItBooked = seat['isBooked'];
          final seatContainer = SeatContainer(seatId, isItAvailable, isItSelected, isItBooked,()async{
            await FirebaseFirestore.instance.collection('seats').doc(seatId).update({"isBooked": true});

            Fluttertoast.showToast(msg: 'Seat has been booked!', gravity: ToastGravity.TOP);
          });


          SeatContainers.add(seatContainer);

        }

        return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,),
        itemCount: 36,
        itemBuilder:(context, index) {
          return ListView(children: SeatContainers,);
        }
        ),
    );
      },
      );
  }




  // Option. 1

  void updateToBooked(seatId) async {
    //IF SEAT IS SELECTED AND PAYMENT MADE THEN => BOOK


      await FirebaseFirestore.instance.collection('seats').doc(seatId).update({'isBooked': true});

      Fluttertoast.showToast(msg: 'Seat has been booked!', gravity: ToastGravity.TOP);

  }

  //Option. 2

  //Changing seat to booked from isSelected
//   void updatingToBooked(id) async {
//     final setToBooked = await FirebaseFirestore.instance.collection('seats').doc(id);
//     if(setToBooked){
//       setToBooked.update({'isBooked' : true});
//         };
//
//     Fluttertoast.showToast(msg: 'seat Booked', gravity: ToastGravity.TOP);
//   }
 }

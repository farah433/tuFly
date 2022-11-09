import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Design of Each Seats
class SeatContainer extends StatefulWidget {

  SeatContainer(this.seatId, this.isAvailable, this.isSelected, this.isBooked, this.bookNow);
  String seatId;
  bool isAvailable;
  bool isSelected;
  bool isBooked;
  void Function () bookNow;


  @override
  State<SeatContainer> createState() => _SeatContainerState();
}

class _SeatContainerState extends State<SeatContainer> {


  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onDoubleTap: () async{
                      setState(() {
                        widget.isSelected =false;

                      });

                    },
                    onTap: () async {
                      setState(() {
                        widget.isSelected = true;
                        //if payment is made => book
                        widget.bookNow();
                       });
                       // brings error message cannot find the doc kwa firestore,some good progress lakini

                    },
                    child: widget.isBooked
                     ? Image.asset('images/seat3.png')
                     : widget.isSelected
                     ? Image.asset('images/seat2.png')
                     : Image.asset('images/seat1.png')),
                );
  }
}
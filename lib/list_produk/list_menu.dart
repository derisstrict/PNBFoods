import 'dart:io';

import 'package:flutter/material.dart';

class ListMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.file(File('lib/img.png'),),
              ),
              SizedBox(height: 5,),
              Text("Nasi Goreng Spesial",
              style: TextStyle(
                fontWeight: FontWeight.w700
              ),),
              Row(
                children: [
                  Text("Rp. 25.000"),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class ListMenuAccent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      width: 180,
      decoration: BoxDecoration(
        color: Color(0xFFF9803B),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.file(File('lib/img.png'),),
              ),
              SizedBox(height: 5,),
              Text("Nasi Goreng Spesial",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),),
              Row(
                children: [
                  Text("Rp. 25.000",
                    style: TextStyle(
                      color: Colors.white
                    ),),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 1, right: 10, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("2", 
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFF9803B)
                    ),),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
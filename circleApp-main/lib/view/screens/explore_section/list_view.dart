import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ListView1 extends StatefulWidget {
  const ListView1({Key? key}) : super(key: key);

  @override
  State<ListView1> createState() => _ListView1State();
}

class _ListView1State extends State<ListView1> {
  List<String>  data=[
    "jan","feb","march","april","may","june","july","aug""sep"
  ];
  List<String> list=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: data.length,
            itemBuilder: (context,index){
          return
              GestureDetector(
                onTap: () {
                  setState(() {
                    if(list.contains(data[index])){
                      list.remove(data[index]);
                    }else{
                      list.add(data[index]);
                    }
                  });
                  log("the value is");
                  log(list.toString());
                },
                child: Card(child: ListTile(
                  title: Text(data[index]),
                  trailing: Container(
                    height: 30,width: 50,
                    decoration: BoxDecoration(borderRadius:
                    BorderRadius.circular(10),color:list.contains(data[index])? Colors.red:Colors.green),
                    child: Center(child: Text(list.contains(data[index])? "Remove":"Add")),
                  ),
                ),),
              );
        }),
      )
      ],),
    );
  }
}

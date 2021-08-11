import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('To do list'),
        centerTitle: true,
      ),
      body: Column(
        children:[
          Text('MainScreen'),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, '/todo');
          }, child: Text('Next'))
        ]
      ),
    );
  }
}

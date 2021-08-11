import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  String _teg='';
  String _link='';

  void initFireBase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

 @override
  void initState() {
    super.initState();
    initFireBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('To do list'),
        centerTitle: true,
        actions:[
          IconButton(onPressed: _menuOpen, icon: Icon(Icons.menu))
        ]
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Text('No_data');
          return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index){
                    return Dismissible(
                      key: Key(snapshot.data!.docs[index].id),
                      child: Card(
                        child: ListTile(
                          title: Text(snapshot.data!.docs[index].get('link')),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.blue,),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('Videos').doc(snapshot.data!.docs[index].id).delete();
                            },
                          ) ,
                        ),
                      ),
                      onDismissed: (direction){
                        FirebaseFirestore.instance.collection('Videos').doc(snapshot.data!.docs[index].id).delete();
                      },
                    );
                  });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text('Add'),
              content: Column(
                children: [
                  TextField(
                    onChanged: (String value){
                      _teg=value;
                    },

                  ),
                  TextField(
                    onChanged: (String value){
                      _link=value;
                    },

                  ),
                ],
              ),
              actions: [
                ElevatedButton(onPressed: (){
                  FirebaseFirestore.instance.collection('Videos').add({'teg':_teg, 'link': _link});
                  Navigator.of(context).pop();
                }, child: Text('Add'))
              ],
            );
          });
        },
        child: Icon(
            Icons.add_box,
        ),
      ),

    );
  }

  void _menuOpen() {
   Navigator.of(context).push(
     MaterialPageRoute(builder: (BuildContext context){
       return Scaffold(
         appBar: AppBar(title: Text('Menu'),),
         body: Row(
           children: [
             ElevatedButton(onPressed: (){
               Navigator.pop(context);
               Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
             }, child: Text('Go')),

             Padding(padding: EdgeInsets.only(left:15),),
             Text('Home')
           ],
         )
       );
     })
   );
  }
}

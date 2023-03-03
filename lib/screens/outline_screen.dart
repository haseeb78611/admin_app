import 'dart:io';

import 'package:class_appp/Services/taost.dart';
import 'package:class_appp/screens/pdf.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class OutlineScreen extends StatefulWidget {
  final query;
  final name;

  const OutlineScreen({super.key,
     this.query,
     this.name,
  });
  @override
  State<OutlineScreen> createState() => _OutlineScreenState(query : query, name : name, );
}
class _OutlineScreenState extends State<OutlineScreen> {
  final query;
  final name;
  _OutlineScreenState({this.query, this.name, });

  bool loading = false;
  double progress = 0.0;

  saveFile(String url, String fileName) async {
    try{
      if(await permissionCheck(Permission.storage)){
        FileDownloader.downloadFile(url: url,name: fileName,
          onDownloadCompleted: (path) {
            Toast().show('$fileName Downloaded');
            setState(() {loading = false;});
          },
          onDownloadError: (errorMessage) {
            showDialog(context: context, builder: (context) {
              return Container(
                child: AlertDialog(
                  title : Text('Error'),
                  content: Text(errorMessage.toString()),
                  actions: [
                    TextButton(onPressed: ()=> Navigator.pop(context), child: Text('OK', style: TextStyle(color: Colors.black)))
                  ],
                ),
              );
            },
            );
            setState(() {loading = false;});
          },);
      }
    }catch(e){
      print(e);
    }
  }
  Future<bool> permissionCheck(Permission permission) async{
    if(await permission.isGranted){
      Toast().show('Permission Granted');
      return true;
    }
    else{
      var result = await permission.request();
      if(result ==  PermissionStatus.granted){
        Toast().show('Permission Granted');
        return true;
      }
      else{
        Toast().show('Permission Denied');
        return false;
      }
    }

  }
  downloadFile(String url, String fileName) async {
    setState(() {loading = true;});
    await saveFile(url, fileName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            loading ?
            CircularProgressIndicator(color: Colors.black,)
                :
                Container()

          ],
        )

      ),
      body: StreamBuilder(
        stream: query.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent>snapshot) {
          if(snapshot.hasData){
            var list = snapshot.data!.snapshot.children.toList();
            return ListView.builder(
              itemCount: list.length-1,
              itemBuilder: (context, index) {
                String path = list[index].child('url').value as String;
                String name = list[index].child('name').value as String;
                String time = list[index].child('time').value as String;
                return InkWell(
                  onTap: () {
                  },
                  child: Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(name,
                                style: const TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      children: [
                                        Container(width: 50,),
                                        InkWell(
                                            onTap: (){
                                              query.child(time).remove();
                                            },
                                            child: Icon(Icons.highlight_remove_rounded, color: Colors.white,size: 35)),
                                      ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => PDf(path: path, name: name),));
                                          },
                                          child: Icon(Icons.remove_red_eye, color: Colors.white, size: 30,)),
                                      SizedBox(width: 20,),
                                      InkWell(
                                          onTap: (){
                                            downloadFile(path, name);
                                          },
                                          child: Icon(Icons.download, color: Colors.white, size: 30))
                                    ],

                                  ),


                                ],
                              ),
                            ),
                          ],

                        ),
                      )
                  ),
                );
              },);

          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}

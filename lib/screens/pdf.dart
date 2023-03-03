import 'package:class_appp/Widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDf extends StatefulWidget {
  final path;
  final name;
  const PDf({super.key,  this.path,  this.name});
  @override
  State<PDf> createState() => _PDfState(path : path, name: name);
}

class _PDfState extends State<PDf> {
  final path;
  final name;
  _PDfState({this.name,this.path});

  PDFDocument? document;
  bool loading = true;

  loadDocument() async {
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDocument();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name),),
      body: Center(
        child:
            loading ?
                const CircularProgressIndicator()
            :
                SfPdfViewer.network(
                    path,
                  onDocumentLoadFailed: (details) {
                      Navigator.pop(context);
                    showDialog(context: context, builder: (context) {
                      return Container(
                        child: AlertDialog(
                          title: Center(child: Text(details.error, style: TextStyle(color: Colors.red,fontSize: 30,fontFamily:'ShantellSans', fontWeight: FontWeight.bold ),)),
                          content: Container(
                            height: 160,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, size: 100,color: Colors.red,),
                                Center(child: Text(details.description)),
                              ],
                            ),
                          ),
                          actions: [
                            Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:MaterialStatePropertyAll(Colors.red)
                                  ),
                                  onPressed: ()=> Navigator.pop(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      color: Colors.red,

                                    ),
                                    child: Text('OK', style: TextStyle(color: Colors.white)),
                                  ),

                                )
                            )
                          ],
                        ),
                      );
                    },);
                  },
                )
      )

    );
  }
}

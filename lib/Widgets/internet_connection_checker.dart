import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnectionWidget extends StatelessWidget {
  final AsyncSnapshot<ConnectivityResult> snapshot;
  const InternetConnectionWidget({
    Key? key,
    required this.snapshot,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(snapshot.connectionState){
      case  ConnectionState.active :
        return  CircularProgressIndicator();
      default:
        return
            Center(child: Icon(Icons.signal_wifi_connected_no_internet_4_outlined, size: 200,));
    }
  }
}

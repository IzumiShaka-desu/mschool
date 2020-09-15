import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mschool/models/school.dart';

import '../utils.dart';

class Detail extends StatefulWidget {
  Detail(this.school,);
  final School school;
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isEditMode=false;
  
  Map<String, TextEditingController> controller = {
    'npsn': TextEditingController(),
    'name': TextEditingController(),
    'desc': TextEditingController()
  };
  bool isLoading =false;
  
  
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      appBar: AppBar(
        title: Text(widget.school.name ?? ''),
        actions: [],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(children: [
          Positioned.fill(
              child: SizedBox(
            height: size.height,
            width: size.width,
            child: GoogleMap(
              markers: {Marker(markerId: MarkerId('place'),position: LatLng(widget.school.lat,widget.school.long))},
              initialCameraPosition: CameraPosition( target:LatLng(widget.school.lat,widget.school.long),zoom: 15,)),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                width: size.width,
                height: 200,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child:Center(
                      child: ListView(children: [
                        Center(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.school.name,style:TextStyle(fontWeight: FontWeight.bold,fontSize:18)),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("NPSN : "+widget.school.npsn.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Deskripsi : "+widget.school.desc),
                        )
                      ],),
                    )

                  ),
                  elevation: 5,
                  color: Colors.grey[100],
                )),
          ),AnimatedPositioned(
                bottom: (!isEditMode) ? -(size.height * 2) : null,
                curve: Curves.bounceInOut,
                child: Container(
                  color: Colors.grey[100],
                  width: size.width,
                  height: size.height,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            '',
                            style: TextStyle(fontSize: 20),
                          ),
                          TextFormField(
                            controller: controller['npsn'],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'NPSN',
                                border: OutlineInputBorder(),
                                hintText: 'ex 2435..'),
                          ),
                          TextFormField(
                            controller: controller['name'],
                            decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                                hintText: 'ex SMKN1'),
                          ),
                          TextFormField(
                            controller: controller['desc'],
                            decoration: InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                                hintText: 'smkn1 is a'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'latitude : ${widget.school.lat.toStringAsFixed(5)}'))),
                              SizedBox(width: 20),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'longitude : ${widget.school.long.toStringAsFixed(5)}')))
                            ],
                          ),
                          SizedBox(
                            width: size.width,
                            height: 200,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(widget.school.lat, widget.school.long), zoom: 8),
                              onTap: (LatLng latlong) {
                                setState(() {
                                  widget.school.lat = latlong.latitude;
                                  widget.school.long = latlong.longitude;
                                });
                              },
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: FlatButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    if (!isLoading) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (isEmptyMapText(controller)) {
                                        _sk.currentState.showSnackBar(
                                            createSnackbar(
                                                'all field is required'));
                                      } else {
                                        School _school = School(
                                            npsn: int.parse(
                                                controller['npsn'].text),
                                            desc: controller['desc'].text,
                                            name: controller['name'].text,
                                            lat: widget.school.lat,
                                            long: widget.school.long);
                                       try{
                                          widget.school.ref.update(_school.map);
                                          
                                          _sk.currentState.showSnackBar(
                                              createSnackbar(
                                                  'data has been updated'));
                                          setState(() {
                                            widget.school.name=_school.name;
                                            widget.school.npsn=_school.npsn;
                                            widget.school.desc=_school.desc;


                                            setControllerEmpty();
                                          });
                                        } catch(e) {
                                          debugPrint(e.toString());
                                          _sk.currentState.showSnackBar(
                                              createSnackbar(
                                                  'data has not edited'));
                                        }
                                      }
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: Text(
                                    'Update',
                                    style: TextStyle(color: Colors.white),
                                  )))
                        ],
                      ),
                    ),
                  ),
                ),
                duration: Duration(milliseconds: 300))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Transform.rotate(
              angle: (isEditMode) ? 8.7 : 0, child: 
              
              (isEditMode)?Icon(Icons.add):Icon(Icons.edit)),
          onPressed: () {
            setState(() {
              controller['npsn'].text=widget.school.npsn.toString();
              controller['name'].text=widget.school.name;
              controller['desc'].text=widget.school.desc;

              isEditMode = !isEditMode;
            });
          }),
    );
  }
    setControllerEmpty() {
    for (String i in controller.keys) {
      controller[i].text = '';
    }
  }
}

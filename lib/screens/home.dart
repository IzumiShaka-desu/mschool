import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mschool/components/drawer.dart';
import 'package:mschool/models/school.dart';
import 'package:mschool/service/auth_service.dart';
import 'package:mschool/service/firestore_service.dart';

import '../utils.dart';
import 'detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User curent;
  gets() async {
    User user = await AuthService().getCurrentUser();
    setState(() {
      curent = user;
    });
  }

  bool isAddMode = false;
  bool isLoading = false;

  Map<String, TextEditingController> controller = {
    'npsn': TextEditingController(),
    'name': TextEditingController(),
    'desc': TextEditingController()
  };
  GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  double lat = 0;
  double long = 0;
  List<School> list = [];

  loadData() async {
    setState(() {
      isLoading = true;
    });
    List<School> result = await FirestoreService().getData();
    if(mounted)setState(() {
      list = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    gets();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      drawer: DrawerCust(),
      appBar: AppBar(title: Text((isAddMode) ? 'Add Data' : 'List of School')),
      drawerEnableOpenDragGesture: true,
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
                height: size.height,
                width: size.width,
                child: (isLoading)
                    ? Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      )
                    : (list.length < 1)
                        ? Center(
                            child: Text('the school list is still empty',
                                style: TextStyle(color: Colors.redAccent)))
                        : ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (ctx, index) {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Dismissible(
                                  key: Key(list[index].ref.id),
                                  onDismissed: (direction) async {
                                    try {
                                      await list[index].ref.delete();

                                      _sk.currentState.showSnackBar(
                                          createSnackbar('item has deleted'));
                                    } catch (e) {
                                      _sk.currentState.showSnackBar(
                                          createSnackbar(
                                              'item has not deleted'));
                                    }
                                    loadData();
                                  },
                                  background: Container(
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.delete),
                                          ))),
                                  confirmDismiss: (direction) {
                                    return showDialog(
                                        context: context,
                                        builder: (ctx) => confirmDelete(ctx));
                                  },
                                  child: Card(
                                    child: ListTile(
                                        title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${list[index].name}'),
                                        IconButton(
                                            icon: Icon(Icons.info_outline),
                                            onPressed: () => Navigator.of(
                                                    context)
                                                .push(MaterialPageRoute(
                                                    builder: (ctx) => Detail(
                                                          list[index],
                                                        )))),
                                      ],
                                    )),
                                  ),
                                ),
                              );
                            })),
            AnimatedPositioned(
                bottom: (!isAddMode) ? -(size.height * 2) : null,
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
                                          'latitude : ${lat.toStringAsFixed(5)}'))),
                              SizedBox(width: 20),
                              Expanded(
                                  child: Center(
                                      child: Text(
                                          'longitude : ${long.toStringAsFixed(5)}')))
                            ],
                          ),
                          SizedBox(
                            width: size.width,
                            height: 200,
                            child: GoogleMap(
                              markers: {
                                Marker(
                                    markerId: MarkerId('place'),
                                    position: LatLng(lat, long))
                              },
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, long), zoom: 10),
                              onTap: (LatLng latlong) {
                                setState(() {
                                  lat = latlong.latitude;
                                  long = latlong.longitude;
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
                                        School school = School(
                                            npsn: int.parse(
                                                controller['npsn'].text),
                                            desc: controller['desc'].text,
                                            name: controller['name'].text,
                                            lat: lat,
                                            long: long);
                                        var result = FirestoreService()
                                            .addSchool(school);
                                        if (result != null) {
                                          _sk.currentState.showSnackBar(
                                              createSnackbar(
                                                  'data has been added'));
                                          setState(() {
                                            setControllerEmpty();
                                          });
                                        } else {
                                          _sk.currentState.showSnackBar(
                                              createSnackbar(
                                                  'data not successfully added'));
                                        }
                                      }
                                    }
                                    loadData();
                                    setState(() {
                                      isLoading = false;
                                      isAddMode = false;
                                    });
                                  },
                                  child: Text(
                                    'Add',
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
              angle: (isAddMode) ? 8.7 : 0, child: Icon(Icons.add)),
          onPressed: () {
            setState(() {
              isAddMode = !isAddMode;
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

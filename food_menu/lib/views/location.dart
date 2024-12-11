import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
 
import 'package:food_menu/service/user_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/views/credi_card.dart';

import 'package:food_menu/widget/mybutton.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Location extends StatefulWidget {
  List<Map<String, dynamic>> sepet;
   Location({super.key,required this.sepet});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  LatLng points = const LatLng(37.066666, 37.383331);
  final MapController _mapController = MapController();
  final TextEditingController _konumController = TextEditingController();
  double _currentZoom = 13.0;
  bool _loading = false;

  Future<void> _getAddressFromLatLng() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(points.latitude, points.longitude);
    setState(() {
      _konumController.text =
          "${placemarks[0].name} ${placemarks[0].country} ${placemarks[0].administrativeArea} ${
            placemarks[0].subAdministrativeArea} ${
            placemarks[0].street} Mahallesi No:${placemarks[0].subThoroughfare} ";
  
   
    });
  }

  void bekle() async {
    setState(() {
      _loading = true; 
    });

    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
    try {
      Position guncelKonum = await enlemBoylam();
      setState(() {
        points = LatLng(guncelKonum.latitude, guncelKonum.longitude);
        _mapController.move(points, _currentZoom);
      });
      _getAddressFromLatLng();
     
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Hata"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Tamam"),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _loading = false; 
      });
    }
  }

  Future<Position> enlemBoylam() async {
    if (!await GeolocatorAndroid().isLocationServiceEnabled()) {
      return Future.error("Konum Servisleri Devre Dışı..");
    }
    if (await GeolocatorAndroid().checkPermission() ==
        LocationPermission.denied) return Future.error("İzin Reddedildi..");

    if (await GeolocatorAndroid().requestPermission() ==
        LocationPermission.deniedForever) {
      return Future.error("İzin Temelli olarak reddedildi..");
    }

    return await GeolocatorAndroid().getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
    bekle();
    //print(widget.sepet);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: appcolor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appcolor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Konumu Bul",
          style: TextStyleClass.mainTitle.copyWith(fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                FlutterMap(

                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: points,
                    initialZoom: _currentZoom,
                    onTap: (tapPosition, point) {
                      setState(() {
                        points = point;
                      });
                      _getAddressFromLatLng();
                    },
                    onPositionChanged: (mapPosition, _) {
                      _currentZoom = mapPosition.zoom;
                    },
                  ),
                  children: [
                    TileLayer(
                      
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
           // tileProvider: NonCachingNetworkTileProvider(),
                    ),

                    MarkerLayer(
                      markers: [
                        Marker(
                          child: const Icon(Icons.location_on, color: Colors.red),
                          width: 120,
                          height: 120,
                          point: points,
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _loading
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : IconButton(
                            onPressed: () {
                              bekle();
                            },
                            icon: const Icon(
                              Icons.my_location_rounded,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: enabledColor),
                    ),
                    child: TextField(
                      minLines: 1,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      controller: _konumController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        iconColor: Colors.white,
                        border: InputBorder.none,
                        hintText:
                            "Konumuzunu İsterseniz Haritadan Seçin\n İsterseniz Kendiniz Yazın",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                myButton(() {
                  //foodService.placeOrder(context, currentUser!.uid.toString(), _konumController.text, widget.sepet);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  CrediCard(_konumController.text,widget.sepet),));

                }, "İşlemi Tamamla"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

void main() => runApp(
      const MaterialApp(
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  final Map<String, Polyline> _polylines = {};

  BitmapDescriptor? _markerIcon;
  img.Image? _mergeImage;
  late GoogleMapController mapController;
  bool inShow = false;

  final LatLng _center = const LatLng(35.80099213322445, 139.71850198834352);

  @override
  void initState() {
    _makeMarkerIcon();
    // _createRoute(
    //   'wnpyE}m{sY[k@ZWh@_@bIxNnG`LPh@LrAb@Br@Tt@d@rEdElAjA~GlG\\f@Xz@ZjBtGbJb@`@`@NP@TEGj@Qf@{AxCmIbOLTBVUrEjAdH@l@YdBc@@mFd@JrB',
    // );
  }

  Future<img.Image?> decodeAsset(String path) async {
    final data = await rootBundle.load(path);

    // Utilize flutter's built-in decoder to decode asset images as it will be
    // faster than the dart decoder.
    final buffer =
        await ui.ImmutableBuffer.fromUint8List(data.buffer.asUint8List());

    final id = await ui.ImageDescriptor.encoded(buffer);
    final codec = await id.instantiateCodec(
        targetHeight: id.height, targetWidth: id.width);

    final fi = await codec.getNextFrame();

    final uiImage = fi.image;
    final uiBytes = await uiImage.toByteData();

    final image = img.Image.fromBytes(
        width: id.width,
        height: id.height,
        bytes: uiBytes!.buffer,
        numChannels: 4);

    return image;
  }

  Future<void> _makeMarkerIcon() async {
    final cardImageOrNull = await decodeAsset('assets/icons/00-101-A01.png');
    final pinImageOrNull = await decodeAsset('assets/icons/icon.png');
    final cardImage = cardImageOrNull!;
    final pinImage = pinImageOrNull!;

    final cardThumbnail = img.copyResize(cardImage, width: 259, height: 361);
    final pinThumbnail = img.copyResize(pinImage, width: 517, height: 722);

    final mergeImage = img.Image(
      width: 517,
      height: 722,
    );
    img.compositeImage(
      mergeImage,
      pinThumbnail,
    );
    img.compositeImage(
      mergeImage,
      cardThumbnail,
      dstX: 100,
      dstY: 100,
    );

    final appDirectory = await getApplicationDocumentsDirectory();
    final appPath = '${appDirectory.path}/00-101-A01.png';
    img.encodeJpgFile(appPath, mergeImage);

    final data1 = await rootBundle.load(appPath);
    final data2 = data1.buffer.asUint8List();

    setState(() {
      _markers.clear();
      _mergeImage = cardImage;
      _markerIcon = BitmapDescriptor.fromBytes(
          img.encodeJpg(mergeImage).buffer.asUint8List());
      final marker = Marker(
        markerId: const MarkerId("00-101-A01"),
        icon: _markerIcon ?? BitmapDescriptor.defaultMarker,
        position: const LatLng(35.80099213322445, 139.71850198834352),
        infoWindow: const InfoWindow(
          title: '日本下水道事業団',
        ),
        onTap: _onPressed,
      );
      _markers[marker.markerId.toString()] = marker;
    });
  }

  Future<void> _createRoute(String encondedPoly) async {
    setState(() {
      _polylines.clear();
      final polyline = Polyline(
        polylineId: const PolylineId("00-101-A01"),
        width: 6,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue,
      );
      _polylines[polyline.polylineId.toString()] = polyline;
    });
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    List<double> lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;
      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negative then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }
    print(lList.toString());
    return lList;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: [
            Flexible(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17.0,
                ),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: _markers.values.toSet(),
                polylines: _polylines.values.toSet(),
              ),
            ),
            if (inShow)
              const SizedBox(
                height: 400,
                width: double.infinity,
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await getUserCurrentLocation();
          },
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    setState(() {
      inShow = true;
    });
    final aaa = await showCardModal();
    setState(() {
      inShow = false;
    });
  }

  // created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> showCardModal() async {
    final cardImageOrNull = await decodeAsset('assets/icons/00-101-A01.png');
    final cardImage = cardImageOrNull!;

    final cardThumbnail = img.copyResize(cardImage, width: 259, height: 361);
    final grayCardThumbnail = img.grayscale(cardThumbnail);
    final byte = img.encodeJpg(grayCardThumbnail).buffer.asUint8List();

    if (!context.mounted) {
      return Future(() {
        return false;
      });
    }

    final b = await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 400,
              child: Column(
                children: [
                  SizedBox(
                    width: 155.1,
                    height: 216.6,
                    child: Image.memory(byte),
                  ),
                  const Text('data'),
                  const Text('data2'),
                ],
              ),
            );
          },
        ) ??
        false;
    return b;
  }
}

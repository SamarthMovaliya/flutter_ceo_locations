import 'package:ceo_pages_location/globals/global.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyApp(),
        'nxtPage': (context) => nxtPage(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Permission.location.request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Company Locations',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
        ),
        body: Column(
          children: datas
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'nxtPage', arguments: e);
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      title: Text(
                        e['comapany'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      trailing: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          e['logo'],
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(e['image']),
                      ),
                      subtitle: Text(
                        e['Ceo'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ));
  }
}

class nxtPage extends StatefulWidget {
  const nxtPage({Key? key}) : super(key: key);

  @override
  State<nxtPage> createState() => _nxtPageState();
}

class _nxtPageState extends State<nxtPage> {
  Placemark? placeMark;

  @override
  Widget build(BuildContext context) {
    Map e = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          e['comapany'],
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 90,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(e['image']),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    e['Ceo'],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    e['comapany'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Location',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              backgroundImage: NetworkImage(e['logo']),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: StreamBuilder(
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (snapshot.hasData) {
                    placemarkFromCoordinates(e['latitude'], e['longitude'])
                        .then((List<Placemark> placemarks) {
                      setState(() {
                        placeMark = placemarks[0];
                      });
                    });
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            placeMark.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Spacer(),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

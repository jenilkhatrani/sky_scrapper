import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_scrapper/Helper/APIHelper.dart';
import 'package:sky_scrapper/Provider/ThemeProvider.dart';
import '../Provider/ConnecitivityProvider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int index = 0;
  TextEditingController Search = TextEditingController();
  late Future<Map?> search;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkConnectivity();
    search = APIHelper.apiHelper.Weather(Search: 'Ahmedabad');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: 280,
        backgroundColor: Colors.grey,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            DrawerHeader(
              child: TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.search),
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  hintText: 'Search location',
                ),
                controller: Search,
                onSubmitted: (val) {
                  search = APIHelper.apiHelper.Weather(Search: val);
                  setState(() {});
                },
              ),
            ),
            Row(
              children: [
                const Text(
                  'dark Mode',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Switch(
                    value:
                        (Provider.of<ThemeProvider>(context).themeModel.isdark),
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .theme();
                    }),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/image/bg.jpg',
                ),
                fit: BoxFit.fill)),
        child: (Provider.of<ConnectivityProvider>(context)
                    .connecitivityModel
                    .isInternet ==
                false)
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No internet connection available',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              )
            : FutureBuilder(
                future: search,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    Map? data = snapshot.data;

                    return (data == null)
                        ? const Center(
                            child: Text('No any data yet...'),
                          )
                        : CustomScrollView(
                            slivers: [
                              SliverAppBar(
                                backgroundColor:
                                    const Color.fromRGBO(107, 192, 237, 0),
                                centerTitle: true,
                                title: Row(
                                  children: [
                                    Text(
                                      '${data['address']}',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.location_pin,
                                    )
                                  ],
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      ' ${data['currentConditions']['temp'].toString().split('.')[0]}°',
                                      style: const TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' ${data['days'][0]['preciptype'][0]}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      ' ${data['days'][0]['tempmax'].toString().split('.')[0]}° /${data['days'][0]['tempmin'].toString().split('.')[0]}°  Feels like  ${data['days'][0]['feelslike'].toString().split('.')[0]}°',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                          maxHeight: 250, minHeight: 60),
                                      child: ListView.builder(
                                          itemCount: 7,
                                          itemBuilder: (context, i) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      ' ${data['days'][i]['datetime']}',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    const Icon(
                                                      Icons.water_drop,
                                                      size: 18,
                                                    ),
                                                    Text(
                                                      '${data['days'][i]['dew'].toString().split('.')[0]}°',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '${data['days'][i]['tempmax'].toString().split('.')[0]}° /${data['days'][i]['tempmin'].toString().split('.')[0]}° ',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                    Row(
                                      children: [
                                        Card(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons.air,
                                                    color: Colors.white60,
                                                  ),
                                                  Text('Wind',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                height: 80,
                                                width: 160,
                                                child: Center(
                                                  child: Text(
                                                    ' ${data['currentConditions']['windspeed'].toString().split('.')[0]} Km/h',
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Card(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons.water_drop_sharp,
                                                    color: Colors.white60,
                                                  ),
                                                  Text(
                                                    'Humidity',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 80,
                                                width: 160,
                                                child: Center(
                                                  child: Text(
                                                    ' ${data['currentConditions']['humidity'].toString().split('.')[0]} Km/h',
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons.sunny,
                                                    color: Colors.white60,
                                                  ),
                                                  Text(
                                                    'UV index',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 80,
                                                width: 160,
                                                child: Center(
                                                  child: Text(
                                                    ' ${data['currentConditions']['uvindex']}',
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Card(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .device_thermostat_rounded,
                                                    color: Colors.white60,
                                                  ),
                                                  Text(
                                                    'Dew point',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 80,
                                                width: 160,
                                                child: Center(
                                                  child: Text(
                                                    ' ${data['currentConditions']['dew'].toString().split('.')[0]}°',
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Card(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .compare_arrows_rounded,
                                                    color: Colors.white60,
                                                  ),
                                                  Text(
                                                    'Pressure',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 80,
                                                width: 160,
                                                child: Center(
                                                  child: Text(
                                                    ' ${data['currentConditions']['uvindex']}',
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Card(
                                          color: Colors.transparent,
                                          margin: const EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    color: Colors.white60,
                                                  ),
                                                  Text(
                                                    'Visibility',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 80,
                                                width: 160,
                                                child: Center(
                                                  child: Text(
                                                    ' ${data['currentConditions']['visibility']} Km',
                                                    style: const TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            search = APIHelper.apiHelper
                                .Weather(Search: 'ahmedabad');
                            setState(() {});
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                }),
      ),
    );
  }
}
